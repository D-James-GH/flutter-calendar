import 'package:flutter/material.dart';
import 'package:flutter_calendar/services/calendar_db.dart';
import 'package:flutter_calendar/models/models.dart';
import 'package:flutter_calendar/services/service_locator.dart';
import 'package:intl/intl.dart';

class CalendarState extends ChangeNotifier {
  CalendarDB _calendarDB = locator<CalendarDB>();
  Map<String, List<EventModel>> _events = {};
  DateTime _currentDate = DateTime.now();
  EventModel editFormEvent = EventModel();

  // getters
  DateTime get currentSelectedDate => _currentDate;

  Map<String, List<EventModel>> get events => _events;
  // calendar state ===================================
  void setEditFormEvent(EventModel event) {
    this.editFormEvent = event;
    notifyListeners();
  }

  void selectDate(DateTime date) {
    _currentDate = date;
    notifyListeners();
  }

  void nextMonth() {
    _currentDate = new DateTime(
        _currentDate.year, _currentDate.month + 1, _currentDate.day);
    notifyListeners();
  }

  void prevMonth() {
    _currentDate = new DateTime(
        _currentDate.year, _currentDate.month - 1, _currentDate.day);
    notifyListeners();
  }

  String calcDateID(DateTime dateObject) {
    String dateID = DateFormat.yMMMd().format(dateObject).toString();
    dateID = dateID.replaceAll(' ', '');
    dateID = dateID.replaceAll(',', '');
    return dateID;
  }

  // event state ======================================
  Future<void> fetchEventFromDB(String dateID) async {
    final calEvents = await _calendarDB.getEvents(dateID);
    //  store events grouped by day for easier display
    _events[dateID] = calEvents; // possibly ?? []
    if (_events.length >= 40) {
      notifyListeners();
    }
  }

  Future<List<EventModel>> fetchEventsWithContact(String contactUID) async {
    List<EventModel> events =
        await _calendarDB.getEventsWithContact(contactUID);
    return events;
  }

  Future<void> deleteEvent(EventModel event,
      {bool isAdmin = false, String uid}) async {
    // check the user role, should not be able to delete event if not the owner
    if (isAdmin) {
      await _calendarDB.deleteEvent(event.eventID);
    } else {
      print('removing user');
      // update the event without the current user
      var memberRoles = event.memberRoles;
      memberRoles.removeWhere((element) => element.uid == uid);

      var changedEvent = EventModel(
        dateID: event.dateID,
        endTimestamp: event.endTimestamp,
        eventID: event.eventID,
        isPast: event.isPast,
        memberRoles: memberRoles,
        startTimestamp: event.startTimestamp,
        notes: event.notes,
        title: event.title,
      );
      print(changedEvent.memberUIDs);
      _calendarDB.removeUserFromEvent(changedEvent);
    }
    var _currentEvents = _events;
    _currentEvents[event.dateID].removeWhere((e) => e.eventID == event.eventID);
    notifyListeners();
  }

  Future<void> saveEventToDB(EventModel event) async {
    String dateID = event.dateID;
    // create event in db
    await _calendarDB.createEvent(event);
    var _currentEvents = _events;
    // If creating an event for the first time indexOfEvent will return -1
    var indexOfEvent =
        _currentEvents[dateID].indexWhere((e) => e.eventID == event.eventID);
    if (indexOfEvent == -1) {
      _currentEvents[dateID].add(event);
    } else {
      // if the event exists in state then replace that index with the update version
      _currentEvents[dateID][indexOfEvent] = event;
    }
    notifyListeners();
  }

  void reset() {
    _events = {};
    _currentDate = DateTime.now();
    editFormEvent = EventModel();
  }
}
