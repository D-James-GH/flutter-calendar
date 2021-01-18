import 'package:flutter/material.dart';
import 'package:flutter_calendar/services/db.dart';
import 'package:flutter_calendar/models/models.dart';
import 'package:flutter_calendar/services/service_locator.dart';

class CalendarState extends ChangeNotifier {
  CalendarData _userData = locator<CalendarData>();
  Map<String, List<EventModel>> _events = {};
  Map<String, List<EventModel>> get events => _events;

  Future<void> fetchEventFromDB({String dateID}) async {
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

  Future<void> editEvent({String dateID, EventModel event}) async {
    await _userData.createEvent(
      data: event,
      docRefIn: event.eventID,
    );
    var _currentEvents = _events;
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
