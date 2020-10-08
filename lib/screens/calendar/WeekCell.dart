import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar/helpers/navService.dart';
import 'package:provider/provider.dart';
import 'package:flutter_calendar/services/db.dart';
import 'package:flutter_calendar/services/models.dart';
import 'package:intl/intl.dart';
import 'DayViewScreen.dart';

class ScreenArguments {
  final String day;
  final String month;
  final String dateID;
  final List events;
  ScreenArguments({this.day, this.month, this.dateID, this.events});
}

class WeekCell extends StatelessWidget {
  final bool isCurrentMonth;
  final dateObject;
  final int testDate;
  String dateID;

  WeekCell({this.dateObject, this.isCurrentMonth, this.testDate}) {
    dateID = DateFormat.yMMMd().format(dateObject).toString();
    dateID = dateID.replaceAll(' ', '');
    dateID = dateID.replaceAll(',', '');
  }

  void selectDay({context, month, date, events}) {
    var _navState = NavService.calendarNavState;
    print(events);
    _navState.currentState.pushNamed(
      '/dayView',
      arguments: ScreenArguments(
        dateID: dateID,
        day: date,
        month: month,
        events: events,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final month = DateFormat.MMMM().format(dateObject);
    final date = DateFormat.d().format(dateObject);
    UserData userData = UserData();

    return StreamBuilder<List<EventModel>>(
        stream: userData.eventStream(dateID),
        builder: (context, snapshot) {
          var events = snapshot.data;
          var _eventList = snapshot.hasData
              ? events.map((e) => eventTitle(e.title)).toList()
              : [Text('')];
          return InkWell(
              child: (Container(
                child: Column(
                  children: <Widget>[
                    Text(
                      date,
                      style: TextStyle(),
                    ),
                    ..._eventList
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                color: isCurrentMonth ? const Color(0x1A379182) : null,
                padding: EdgeInsets.fromLTRB(5, 8, 5, 8),
              )),
              onTap: () => selectDay(
                    context: context,
                    month: month,
                    date: date,
                    events: events,
                  ));
        });
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
