part of 'calendar_bloc.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object> get props => [];
}

class CalendarFetched extends CalendarEvent {
  final String dateID;
  const CalendarFetched({@required this.dateID}) : assert(dateID != null);
  @override
  List<Object> get props => [dateID];
}

class CalendarDeletedEvent extends CalendarEvent {
  final eventID;
  final dateID;
  const CalendarDeletedEvent({this.eventID, this.dateID})
      : assert(eventID != null && dateID != null);

  @override
  List<Object> get props => [eventID, dateID];
}

class CalendarAddEvent extends CalendarEvent {
  final String dateID;
  final EventModel calendarEvent;
  const CalendarAddEvent({@required this.calendarEvent, @required this.dateID})
      : assert(dateID != null);

  @override
  List<Object> get props => [dateID, calendarEvent];
}
// class CalendarFetched extends CalendarEvent {}
