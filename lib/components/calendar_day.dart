import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// custom files
import '../app_state/calendar_state.dart';
import '../models/event_model.dart';
import '../helpers/extension_methods.dart';

class CalendarDay extends StatefulWidget {
  final DateTime dateObject;
  final bool isCurrentMonth;

  const CalendarDay(
      {Key key, @required this.dateObject, this.isCurrentMonth = false})
      : super(key: key);

  @override
  _CalendarDayState createState() => _CalendarDayState();
}

class _CalendarDayState extends State<CalendarDay> {
  bool _isToday = false;

  @override
  Widget build(BuildContext context) {
    _isToday = false;
    String dateID;
    CalendarState calendarState = Provider.of<CalendarState>(context);
    dateID = calendarState.calcDateID(widget.dateObject);
    // Todo: this should be in initstate
    calendarState.fetchEventFromDB(dateID);
    TextStyle dateNumberStyle;
    if (widget.dateObject.isSameDate(DateTime.now())) {
      _isToday = true;
      dateNumberStyle = TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 18);
    } else if (widget.isCurrentMonth) {
      dateNumberStyle = TextStyle(color: Colors.white);
    } else {
      dateNumberStyle = TextStyle(color: Color(0x77ffffff));
    }
    return GestureDetector(
      onTap: () => calendarState.selectDate(widget.dateObject),
      child: Container(
        margin: EdgeInsets.all(2),
        height: 43,
        width: 43,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _isToday ? Colors.white : Colors.transparent,
          border: calendarState.currentSelectedDate == widget.dateObject
              ? Border.all(color: Colors.white, width: 2)
              : null,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: _isToday
                ? Border.all(color: Theme.of(context).primaryColor)
                : null,
            shape: BoxShape.circle,
          ),
          child: Stack(
            children: [
              Center(
                child: Text(
                  widget.dateObject.day.toString(),
                  style: dateNumberStyle,
                ),
              ),
              Align(
                alignment: Alignment(0, 0.7),
                child: Container(
                  height: 6,
                  width: 35,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    direction: Axis.horizontal,
                    spacing: 1,
                    clipBehavior: Clip.hardEdge,
                    children: calendarState.events[dateID] != null
                        // if the day has events. The color must change is day if the day is selected.
                        ? _eventDot(
                            calendarState.events[dateID],
                            calendarState.currentSelectedDate ==
                                widget.dateObject)
                        : [Container(child: null)],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _eventDot(List<EventModel> events, bool isSelected) {
    return events
        .map((e) => Container(
              height: 6,
              width: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isToday ? Theme.of(context).primaryColor : Colors.white,
              ),
              child: null,
            ))
        .toList();
  }
}
