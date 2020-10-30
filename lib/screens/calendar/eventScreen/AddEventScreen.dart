import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar/services/db.dart';
import 'package:flutter_calendar/services/models.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddEventScreen extends StatefulWidget {
  final String dateID;
  final DateTime dateObject;
  final addNewEventToState;

  AddEventScreen({this.dateID, this.addNewEventToState, this.dateObject});

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final formKey = GlobalKey<FormState>();

  TimeOfDay _time = new TimeOfDay.now();
  String _title;
  String _notes;

  Future selectTime(BuildContext context) async {
    final TimeOfDay selectedTimeRTL = await showTimePicker(
      context: context,
      initialTime: _time,
      builder: (BuildContext context, Widget child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child,
        );
      },
    );
    if (selectedTimeRTL != null) {
      setState(() {
        _time = selectedTimeRTL;
        // _stringTime = _time.format(context);
      });
    }
  }

  void onSubmit(BuildContext context) {
    String eventID = Uuid().v4();
    User user = Provider.of<User>(context, listen: false);
    EventModel newEvent = EventModel(
      title: _title,
      notes: _notes,
      // time: _stringTime,
      timestamp: new DateTime(widget.dateObject.year, widget.dateObject.month,
          widget.dateObject.day, _time.hour, _time.minute),
      dateID: widget.dateID,
      eventID: eventID,
      members: [user.uid],
    );
    // UserData().createEvent(newEvent, eventID);
    widget.addNewEventToState(newEvent);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Event'),
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  onChanged: (txt) {
                    setState(() {
                      _title = txt;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Event Title',
                    labelStyle: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Text(
                      'Time of the Event:',
                      style: TextStyle(fontSize: 18),
                    ),
                    RaisedButton(
                      onPressed: () {
                        selectTime(context);
                      },
                      child: Text(
                        _time.format(context),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  onChanged: (txt) {
                    setState(() {
                      _notes = txt;
                    });
                  },
                  minLines: 4,
                  maxLines: 10,
                  decoration: const InputDecoration(
                      labelText: 'Notes',
                      hintText: 'Enter notes on your event',
                      labelStyle: TextStyle(fontSize: 18)),
                ),
                RaisedButton(
                  onPressed: () => onSubmit(context),
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ));
  }
}
