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
  String dateID;
  @override
  void initState() {
    super.initState();
    // fetch any events from the database
    CalendarState calendarState =
        Provider.of<CalendarState>(context, listen: false);
    dateID = calendarState.calcDateID(widget.dateObject);
    calendarState.fetchEventFromDB(dateID);
  }

  @override
  Widget build(BuildContext context) {
    CalendarState calendarState = Provider.of<CalendarState>(context);
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
        height: 45,
        width: 45,
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
                      ? _eventDot(calendarState.events[dateID])
                      : [Text('')],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _eventDot(List<EventModel> events) {
    return events
        .map((e) => Container(
              height: 6,
              width: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor,
              ),
              child: null,
            ))
        .toList();
  }
}
