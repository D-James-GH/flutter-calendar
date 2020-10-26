import 'package:flutter/material.dart';
import 'package:flutter_calendar/helpers/navService.dart';
import '../../services/models.dart';
import 'AddEventScreen.dart';
import 'EditEventScreen.dart';

class DayView extends StatefulWidget {
  final String day;
  final String month;
  final String dateID;
  final DateTime dateObject;
  final List<EventModel> events;

  DayView(
      {@required this.day,
      @required this.month,
      @required this.dateID,
      this.dateObject,
      this.events});

  @override
  _DayViewState createState() => _DayViewState();
}

class _DayViewState extends State<DayView> {
  List<EventModel> eventState = [];

  @override
  void initState() {
    super.initState();
    eventState = widget.events;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.day} ${widget.month}'),
      ),
      body: widget.events != null
          ? ListView.builder(
              itemCount: widget.events.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => _editEvent(widget.events[index], index),
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
                        Text(widget.events[index].title),
                        Text(TimeOfDay.fromDateTime(
                                widget.events[index].timestamp)
                            .format(context)),
                        Text(widget.events[index].notes),
                      ],
                    ),
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
            dateObject: widget.dateObject,
            dateID: widget.dateID,
            addNewEventToState: addNewEventToState,
          );
        }));
  }

  void _editEvent(EventModel event, int index) {
    var _navState = NavService.calendarNavState;
    _navState.currentState.push(MaterialPageRoute(
        settings: RouteSettings(name: 'addEvent'),
        builder: (_) {
          return EditEventScreen(
            event: event,
            editEventInState: editEventInState,
            index: index,
          );
        }));
  }

  void editEventInState(EventModel event, int index) {
    this.setState(() {
      eventState[index] = event;
    });
  }

  void addNewEventToState(EventModel newEvent) {
    this.setState(() {
      eventState.add(newEvent);
    });
  }
}
