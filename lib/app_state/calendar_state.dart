import 'package:flutter/material.dart';
import 'package:flutter_calendar/services/db.dart';
import 'package:flutter_calendar/models/models.dart';
import 'package:flutter_calendar/services/service_locator.dart';
import 'package:intl/intl.dart';

class CalendarState extends ChangeNotifier {
  CalendarData _userData = locator<CalendarData>();
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
    final calEvents = await _userData.getEvents(dateID);
    //  store events grouped by day for easier display
    _events[dateID] = calEvents; // possibly ?? []
    if (_events.length >= 40) {
      notifyListeners();
    }
  }

  Future<void> deleteEvent({String eventID, String dateID}) async {
    await _userData.deleteEvent(eventID);
    var _currentEvents = _events;
    _currentEvents[dateID].removeWhere((e) => e.eventID == eventID);
    notifyListeners();
  }

  Future<void> saveEventToDB(EventModel event) async {
    String dateID = event.dateID;
    await _userData.createEvent(
      data: event,
      docRefIn: event.eventID,
    );
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
}
