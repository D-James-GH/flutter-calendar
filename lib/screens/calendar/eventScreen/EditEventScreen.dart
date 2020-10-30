import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar/services/db.dart';
import 'package:flutter_calendar/services/models.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_calendar/helpers/navService.dart';

class EditEventScreen extends StatefulWidget {
  final EventModel event;
  final editEventInState;
  final int index;
  EditEventScreen({this.event, this.editEventInState, this.index});

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final formKey = GlobalKey<FormState>();

  TimeOfDay _time;
  String _title;
  String _notes;
  @override
  void initState() {
    super.initState();
    EventModel _event = widget.event;
    _time = TimeOfDay.fromDateTime(_event.timestamp);
    _title = _event.title;
    _notes = _event.notes;
  }

  Future selectTime(BuildContext context) async {
    TimeOfDay initTime = TimeOfDay.fromDateTime(widget.event.timestamp);
    final TimeOfDay selectedTimeRTL = await showTimePicker(
      context: context,
      initialTime: initTime,
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
    User user = Provider.of<User>(context, listen: false);
    EventModel newEvent = EventModel(
      title: _title,
      notes: _notes,
      // time: _stringTime,
      dateID: widget.event.dateID,
      timestamp: new DateTime(
          widget.event.timestamp.year,
          widget.event.timestamp.month,
          widget.event.timestamp.day,
          _time.hour,
          _time.minute),
      members: [user.uid],
      eventID: widget.event.eventID,
    );
    // UserData().createEvent(newEvent, widget.event.eventID);
    var _navState = NavService.calendarNavState;
    widget.editEventInState(newEvent, widget.index);
    _navState.currentState.pop();
  }

  void handlePopupMenu(String value) {
    switch (value) {
      case 'Delete Event':
        UserData().deleteEvent(widget.event.eventID);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // EventModel _event = widget.event;
    // _time = TimeOfDay.fromDateTime(_event.timestamp);
    // _title = _event.title;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Event'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handlePopupMenu,
            itemBuilder: (BuildContext context) {
              return {'Delete Event'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(
                    choice,
                    style: TextStyle(color: Colors.red),
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _title,
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
                initialValue: _notes,
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
      ),
    );
  }
}
