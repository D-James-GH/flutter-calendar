import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'WeekCell.dart';
// import 'Week.dart';

class MonthScreen extends StatefulWidget {
  final daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  _MonthScreenState createState() => _MonthScreenState();
}

class _MonthScreenState extends State<MonthScreen> {
  DateTime dateObject = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // _calcMonthStartAndEnd(dateObject: dateObject);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Colors.white,
          ),
          onPressed: _changeMonthBack,
        ),
        title: Center(
          child: Text(DateFormat.yMMMM().format(dateObject)),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.chevron_right,
              color: Colors.white,
            ),
            onPressed: _changeMonthForward,
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: widget.daysOfWeek
                .map((day) => Expanded(
                      child: Container(
                        child: Center(
                            child: Text(
                          day,
                          style:
                              TextStyle(color: Color(0xffffffff), fontSize: 18),
                        )),
                        color: const Color(0xff389081),
                      ),
                    ))
                .toList(),
          ),
          ..._buildMonthView(),
        ],
      ),
    );
  }

  void _changeMonthBack() {
    // set state of month
    var newDateObject = new DateTime(dateObject.year, dateObject.month - 1, 1);
    setState(() {
      dateObject = newDateObject;
    });
  }

  void _changeMonthForward() {
    // set state of month
    var newDateObject = new DateTime(dateObject.year, dateObject.month + 1, 1);
    setState(() {
      dateObject = newDateObject;
    });
  }

  List<Widget> _buildMonthView() {
    int index = 0;
    List<Expanded> _month = [];
    List<Expanded> _cal = _calcCalendarMonthInList();
    for (int i = 0; i < 6; i++) {
      List<Expanded> _row = [];
      for (int i = 0; i < 7; i++) {
        _row.add(_cal[index]);
        index++;
      }
      _month.add(Expanded(
        child: Row(
          children: _row,
        ),
      ));
    }
    return _month;
  }

  List<Expanded> _calcCalendarMonthInList() {
    int monthLength = DateTime(dateObject.year, dateObject.month + 1, 0).day;
    int startOfMonthDay =
        DateTime(dateObject.year, dateObject.month, 1).weekday;
    List<Expanded> _cal = [];
    if (startOfMonthDay > 1) {
      for (int d = (2 - startOfMonthDay); d <= 0; d++) {
        DateTime _dateObject = DateTime(dateObject.year, dateObject.month, d);
        _cal.add(Expanded(
          flex: 1,
          child: WeekCell(
            dateObject: _dateObject,
            isCurrentMonth: false,
            dateID: _calcDateID(_dateObject),
          ),
        ));
      }
    }
    for (int d = 1; d <= monthLength; d++) {
      DateTime _dateObject = DateTime(dateObject.year, dateObject.month, d);

      _cal.add(Expanded(
        flex: 1,
        child: WeekCell(
          dateObject: _dateObject,
          isCurrentMonth: true,
          dateID: _calcDateID(_dateObject),
        ),
      ));
    }
    for (int d = 1; _cal.length < 42; d++) {
      DateTime _dateObject = DateTime(dateObject.year, dateObject.month + 1, d);
      _cal.add(Expanded(
        flex: 1,
        child: WeekCell(
          dateObject: _dateObject,
          isCurrentMonth: false,
          dateID: _calcDateID(_dateObject),
        ),
      ));
    }
    return _cal;
  }

  String _calcDateID(DateTime dateOBJ) {
    String dateID = DateFormat.yMMMd().format(dateOBJ).toString();
    dateID = dateID.replaceAll(' ', '');
    dateID = dateID.replaceAll(',', '');
    return dateID;
  }
}
