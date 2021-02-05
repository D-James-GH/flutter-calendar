import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// custom files
import '../app_state/calendar_state.dart';
import '../models/event_model.dart';

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
  @override
  void initState() {
    super.initState();
    // fetch any events from the database
  }

  @override
  Widget build(BuildContext context) {
    String dateID;
    CalendarState calendarState = Provider.of<CalendarState>(context);
    dateID = calendarState.calcDateID(widget.dateObject);
    calendarState.fetchEventFromDB(dateID);
    TextStyle dateNumberStyle;
    if (calendarState.currentSelectedDate == widget.dateObject) {
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
          color: calendarState.currentSelectedDate == widget.dateObject
              ? Colors.white
              : Colors.transparent,
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
                      : [Text('')],
                ),
              ),
            )
          ],
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
                color:
                    isSelected ? Theme.of(context).primaryColor : Colors.white,
              ),
              child: null,
            ))
        .toList();
  }
}
