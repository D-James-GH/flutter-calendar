import 'package:flutter/material.dart';
import 'package:flutter_calendar/helpers/navService.dart';
import 'package:provider/provider.dart';
import '../../services/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../services/Auth.dart';
import '../../services/db.dart';
import 'AddEventScreen.dart';

class DayView extends StatefulWidget {
  final String day;
  final String month;
  final String dateID;
  final List<EventModel> events;

  DayView(
      {@required this.day,
      @required this.month,
      @required this.dateID,
      this.events});

  @override
  _DayViewState createState() => _DayViewState();
}

class _DayViewState extends State<DayView> {
  List<EventModel> eventState = [];
  @override
  Widget build(BuildContext context) {
    eventState = widget.events;
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.day} ${widget.month}'),
      ),
      body: widget.events != null
          ? ListView.builder(
              itemCount: widget.events.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
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
                        offset: Offset(0, 0), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(widget.events[index].title),
                      Text(widget.events[index].time),
                      Text(widget.events[index].notes),
                    ],
                  ),
                );
              },
            )
          : Center(child: Text('No events yet...')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addEvent(context), //addEvent,
        child: Icon(Icons.add),
      ),
    );
  }

  void _addEvent(BuildContext context) {
    var _navState = NavService.calendarNavState;
    _navState.currentState.push(MaterialPageRoute(
        settings: RouteSettings(name: 'addEvent'),
        builder: (_) {
          return AddEventScreen(
            dateID: widget.dateID,
            addNewEventToState: addNewEventToState,
          );
        }));
  }

  void addNewEventToState(EventModel newEvent) {
    this.setState(() {
      eventState.add(newEvent);
    });
  }
}
