import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_calendar/services/db.dart';
import 'package:flutter_calendar/services/models.dart';
import 'package:flutter_calendar/services/service_locator.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final UserData userData = locator<UserData>();
  CalendarBloc() : super(CalendarInitial());

  @override
  Stream<CalendarState> mapEventToState(
    CalendarEvent event,
  ) async* {
    // TODO: implement mapEventToState
    final currentState = state;
    // * Get the calendar from db
    if (event is CalendarFetched) {
      try {
        if (currentState is CalendarInitial) {
          final calEvents = await userData.getEvents(event.dateID);
          //  store events grouped by day for easier display
          yield CalendarLoadSuccess(events: {event.dateID: calEvents});
        }
        if (currentState is CalendarLoadSuccess) {
          final calEvents = await userData.getEvents(event.dateID);

          Map<String, List<EventModel>> newStateEvents = currentState.events;
          newStateEvents[event.dateID] = calEvents;

          if (newStateEvents.length >= 40) {
            yield CalendarLoadMonthSuccess(
                events: newStateEvents, hasLoadedMonth: true);
          } else {
            yield CalendarLoadSuccess(
                events: newStateEvents, hasLoadedMonth: false);
          }
        }
      } catch (_) {
        yield CalendarFailure();
      }
    } else if (event is CalendarDeletedEvent) {
      // * delete a specific event.
      var _blocEvent = event;
      yield CalendarLoading();
      try {
        if (currentState is CalendarLoadMonthSuccess) {
          // delete from db
          await userData.deleteEvent(_blocEvent.eventID);
          // delete from state
          var newStateEvents = currentState.events;
          newStateEvents[_blocEvent.dateID]
              .removeWhere((e) => e.eventID == _blocEvent.eventID);
          // Return the new state without the event
          yield CalendarLoadMonthSuccess(
              events: newStateEvents, hasLoadedMonth: true);
        }
      } catch (_) {
        yield CalendarFailure();
      }
    } else if (event is CalendarAddEvent) {
      // * Add or Edit an event in the calendar
      var _blocEvent = event;
      yield CalendarLoading();
      try {
        if (currentState is CalendarLoadMonthSuccess) {
          // add to db
          await userData.createEvent(
            data: _blocEvent.calendarEvent,
            docRefIn: _blocEvent.calendarEvent.eventID,
          );

          //add to state
          // save current state events to new variable
          var newStateEvents = currentState.events;

          // check if the event already exists on that day by comparing the
          // one stored in state to the given bloc event
          var indexOfEvent = newStateEvents[_blocEvent.dateID]
              .indexWhere((e) => e.eventID == _blocEvent.calendarEvent.eventID);
          // indexOfEvent will return -1 if the event is not found in state
          if (indexOfEvent == -1) {
            newStateEvents[_blocEvent.dateID].add(_blocEvent.calendarEvent);
          } else {
            // if the event exists in state then replace that index with the update version
            newStateEvents[_blocEvent.dateID][indexOfEvent] =
                _blocEvent.calendarEvent;
          }
          yield CalendarLoadMonthSuccess(
              events: newStateEvents, hasLoadedMonth: true);
        }
      } catch (_) {
        yield CalendarFailure();
      }
    }
  }
}
