import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

//custom lib
import '../../../services/services.dart';
import '../../../app_state/calendar_state.dart';

class ScreenArguments {
  final String day;
  final String month;
  final String dateID;
  final DateTime dateObject;
  ScreenArguments({this.day, this.month, this.dateID, this.dateObject});
}

class WeekCell extends StatefulWidget {
  final bool isCurrentMonth;
  final DateTime dateObject;
  final String dateID;
  final String month;
  final String date;

  WeekCell({this.dateObject, this.isCurrentMonth, this.dateID})
      : month = DateFormat.MMMM().format(dateObject),
        date = DateFormat.d().format(dateObject);

  @override
  _WeekCellState createState() => _WeekCellState();
}

class _WeekCellState extends State<WeekCell> {
  CalendarState calendarState;

  @override
  void initState() {
    super.initState();
    calendarState = Provider.of<CalendarState>(context, listen: false);
    calendarState.fetchEventFromDB(dateID: widget.dateID);
  }

  @override
  void didUpdateWidget(WeekCell oldWidget) {
    //TODO: dont fetch if already in state

    super.didUpdateWidget(oldWidget);
    if (oldWidget.dateObject.month != widget.dateObject.month) {
      calendarState.fetchEventFromDB(dateID: widget.dateID);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: (Container(
        child: Consumer<CalendarState>(
          builder: (context, calendar, child) {
            List _eventTitles = [Text('')];

            if (calendar.events[widget.dateID] != null) {
              _eventTitles = calendar.events[widget.dateID]
                  .map((e) => eventTitle(e.title))
                  .toList();
              if (_eventTitles.length > 4) {
                _eventTitles = _eventTitles.getRange(0, 3).toList();
                _eventTitles.add(Icon(
                  FontAwesomeIcons.ellipsisH,
                  size: 10,
                  color: Colors.grey,
                ));
              }
            }

            return Column(
              children: <Widget>[
                Text(
                  widget.date,
                  style: TextStyle(),
                ),
                ..._eventTitles,
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            );
          },
        ),
        color: widget.isCurrentMonth ? const Color(0x1A379182) : null,
        padding: EdgeInsets.fromLTRB(5, 8, 5, 8),
      )),
      onTap: () => selectDay(
        context: context,
        month: widget.month,
        date: widget.date,
      ),
    );
  }

  Widget eventTitle(String title) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 1),
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: const Color(0xff389081),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        title,
        style: TextStyle(fontSize: 10, color: Color(0xffffffff)),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  void selectDay({context, month, date}) {
    var _navState = NavService.calendarNavState;
    _navState.currentState.pushNamed(
      '/dayView',
      arguments: ScreenArguments(
        dateID: widget.dateID,
        dateObject: widget.dateObject,
        day: date,
        month: month,
      ),
    );
  }
}
