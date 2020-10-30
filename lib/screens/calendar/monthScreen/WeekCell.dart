import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar/bloc/calendar_bloc.dart';
import 'package:flutter_calendar/helpers/navService.dart';
import 'package:intl/intl.dart';

class ScreenArguments {
  final String day;
  final String month;
  final String dateID;
  final DateTime dateObject;
  ScreenArguments({this.day, this.month, this.dateID, this.dateObject});
}

class WeekCell extends StatefulWidget {
  final bool isCurrentMonth;
  final dateObject;
  final int testDate;
  String dateID;

  WeekCell({this.dateObject, this.isCurrentMonth, this.testDate}) {
    dateID = DateFormat.yMMMd().format(dateObject).toString();
    dateID = dateID.replaceAll(' ', '');
    dateID = dateID.replaceAll(',', '');
  }

  @override
  _WeekCellState createState() => _WeekCellState();
}

class _WeekCellState extends State<WeekCell> {
  CalendarBloc _calendarBloc;
  var month;
  var date;

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

  @override
  void initState() {
    super.initState();
    _calendarBloc = BlocProvider.of<CalendarBloc>(context)
      ..add(CalendarFetched(dateID: widget.dateID));
    month = DateFormat.MMMM().format(widget.dateObject);
    date = DateFormat.d().format(widget.dateObject);
  }

  @override
  Widget build(BuildContext context) {
    // UserData userData = UserData();
    // userData.eventStream(dateID);

    return InkWell(
      child: (Container(
        child: BlocBuilder<CalendarBloc, CalendarState>(
          builder: (context, state) {
            List _eventTitles = [Text('')];
            if (state is CalendarLoadMonthSuccess) {
              if (state.events[widget.dateID] != null) {
                _eventTitles = state.events[widget.dateID]
                    .map((e) => eventTitle(e.title))
                    .toList();
              }
            }

            return Column(
              children: <Widget>[
                Text(
                  date,
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
        month: month,
        date: date,
      ),
    );
  }

  Widget eventTitle(String title) {
    return Container(
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
}
