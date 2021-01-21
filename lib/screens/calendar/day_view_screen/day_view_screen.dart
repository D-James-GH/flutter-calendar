import 'package:flutter/material.dart';
import 'package:flutter_calendar/models/models.dart';
import 'package:provider/provider.dart';

// custom lib
import '../event_screen/event_screen.dart';
import '../../../services/helpers/nav_service.dart';
import '../../../app_state/calendar_state.dart';

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
      body: Consumer<CalendarState>(
        builder: (context, calendar, child) {
          List<EventModel> events = [];
          if (calendar.events[dateID] != null) {
            events = calendar.events[dateID];
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
                            Text(events[index].notes ?? ' '),
                            Row(
                              children: _buildMembers(events, index),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Center(child: Text('No events yet...'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _gotoEventScreen(), //addEvent,
        child: Icon(Icons.add),
      ),
    );
  }

  List<Widget> _buildMembers(List<EventModel> events, index) {
    return events[index]
        .members
        .map((member) => Text(member.displayName))
        .toList();
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
}
