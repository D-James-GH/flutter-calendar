import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar/bloc/calendar_bloc.dart';
import 'package:flutter_calendar/helpers/navService.dart';
import 'package:flutter_calendar/screens/calendar/eventScreen/AddEventScreen.dart';
import 'package:flutter_calendar/screens/calendar/eventScreen/EditEventScreen.dart';
import 'package:flutter_calendar/screens/calendar/eventScreen/EventScreen.dart';
import 'package:flutter_calendar/services/models.dart';

class DayView extends StatelessWidget {
  final String day;
  final String month;
  final String dateID;
  final DateTime dateObject;

  DayView({
    @required this.day,
    @required this.month,
    @required this.dateID,
    this.dateObject,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$day $month'),
      ),
      body: BlocBuilder<CalendarBloc, CalendarState>(builder: (context, state) {
        var events;
        if (state is CalendarLoadMonthSuccess) {
          if (state.events[dateID] != null) {
            events = state.events[dateID];
          }
        }
        if (state is CalendarLoading) {
          events = [];
        }
        return events.length != 0
            ? ListView.builder(
                itemCount: events.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () => _gotoEventScreen(index, true),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 0),
                            // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(events[index].title),
                          Text(TimeOfDay.fromDateTime(events[index].timestamp)
                              .format(context)),
                          Text(events[index].notes),
                        ],
                      ),
                    ),
                  );
                },
              )
            : Center(child: Text('No events yet...'));
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _gotoEventScreen(), //addEvent,
        child: Icon(Icons.add),
      ),
    );
  }

  void _gotoEventScreen([int index, bool edit]) {
    var _navState = NavService.calendarNavState;
    _navState.currentState.push(MaterialPageRoute(
        settings: RouteSettings(name: 'eventScreen'),
        builder: (_) {
          return EventScreen(
            dateObject: dateObject,
            dateID: dateID,
            index: index,
            edit: edit,
          );
        }));
  }

  // void _editEvent(EventModel event, int index) {
  //   var _navState = NavService.calendarNavState;
  //   _navState.currentState.push(MaterialPageRoute(
  //       settings: RouteSettings(name: 'addEvent'),
  //       builder: (_) {
  //         return EditEventScreen(
  //           event: event,
  //           index: index,
  //         );
  //       }));
  // }
}
