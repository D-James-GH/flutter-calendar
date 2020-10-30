part of 'calendar_bloc.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object> get props => [];
}

class CalendarInitial extends CalendarState {
  final Map<String, List<EventModel>> events = {
    'Sept392020': [EventModel()]
  };
  List<Object> get props => [events];
}

class CalendarLoading extends CalendarState {}

class CalendarLoadSuccess extends CalendarState {
  final Map<String, List<EventModel>> events;
  final bool hasLoadedMonth;

  const CalendarLoadSuccess({
    @required this.events,
    this.hasLoadedMonth,
  }) : assert(events != null);

  CalendarLoadSuccess copyWith({
    Map<String, List<EventModel>> events,
    bool hasLoadedMonth,
  }) {
    return CalendarLoadSuccess(
      events: events ?? this.events,
      hasLoadedMonth: hasLoadedMonth ?? false,
    );
  }

  @override
  List<Object> get props => [events, hasLoadedMonth];
}

class CalendarLoadMonthSuccess extends CalendarState {
  final Map<String, List<EventModel>> events;
  final bool hasLoadedMonth;

  const CalendarLoadMonthSuccess({
    @required this.events,
    this.hasLoadedMonth,
  }) : assert(events != null);

  CalendarLoadMonthSuccess copyWith({
    Map<String, List<EventModel>> events,
    bool hasLoadedMonth,
  }) {
    return CalendarLoadMonthSuccess(
      events: events ?? this.events,
      hasLoadedMonth: hasLoadedMonth ?? false,
    );
  }

  @override
  List<Object> get props => [events, hasLoadedMonth];
}

class CalendarFailure extends CalendarState {}
