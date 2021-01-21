import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

// custom lib
import '../../shared/pick_contact_screen.dart';
import '../../../services/services.dart';
import '../../../models/models.dart';
import '../../../app_state/calendar_state.dart';
import '../../../app_state/user_state.dart';

class EventScreen extends StatefulWidget {
  final DateTime dateObject;
  final String dateID;
  final int index;
  final bool edit;

  EventScreen(
      {@required this.dateID,
      @required this.dateObject,
      this.index,
      this.edit = false});

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final formKey = GlobalKey<FormState>();
  // CalendarBloc _calendarBloc;
  CalendarState calendarState;
  UserModel _user;
  TimeOfDay _time;
  String _title;
  String _notes;
  EventModel _event;
  List<MemberModel> _members = [];

  @override
  void initState() {
    super.initState();
    // _calendarBloc = BlocProvider.of<CalendarBloc>(context);
    _user = Provider.of<UserState>(context, listen: false).currentUserModel;
    if (widget.edit == true) {
      calendarState = Provider.of<CalendarState>(context, listen: false);
      _event = calendarState.events[widget.dateID][widget.index];
      _members = _event.members;
      _time = TimeOfDay.fromDateTime(_event.timestamp);
      _title = _event.title;
      _notes = _event.notes;
    } else {
      _members.add(
        MemberModel(
          uid: _user.uid,
          role: Role.admin,
          displayName: _user.displayName,
        ),
      );
      _time = new TimeOfDay.now();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                onChanged: (txt) => setState(() {
                  _notes = txt;
                }),
                minLines: 4,
                maxLines: 10,
                decoration: const InputDecoration(
                    labelText: 'Notes',
                    hintText: 'Enter notes on your event',
                    labelStyle: TextStyle(fontSize: 18)),
              ),
              RaisedButton(
                onPressed: _inviteMember,
                child: Text('Invite Contacts'),
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
      });
    }
  }

  void handlePopupMenu(String value) {
    switch (value) {
      case 'Delete Event':
        // UserData().deleteEvent(widget.event.eventID);
        if (widget.edit == true) {
          print('trying to delete');
          calendarState.deleteEvent(
            eventID: _event.eventID,
            dateID: widget.dateID,
          );
          var _navState = NavService.calendarNavState;
          _navState.currentState.pop();
        }
        break;
    }
  }

  void _inviteMember() {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        settings: RouteSettings(name: '/createChat'),
        builder: (_) => PickContactScreen(
          onTapContactFunction: _addToMembers,
        ),
      ),
    );
  }

  _addToMembers(UserModel contact) {
    _members.add(MemberModel(
      displayName: contact.displayName,
      uid: contact.uid,
      role: Role.member,
    ));
  }

  void onSubmit(BuildContext context) {
    CalendarState _calendarState =
        Provider.of<CalendarState>(context, listen: false);
    String _eventID = widget.edit == true ? _event.eventID : Uuid().v4();
    DateTime _timeStamp = widget.edit == true
        ? new DateTime(
            _event.timestamp.year,
            _event.timestamp.month,
            _event.timestamp.day,
            _time.hour,
            _time.minute,
          )
        : new DateTime(widget.dateObject.year, widget.dateObject.month,
            widget.dateObject.day, _time.hour, _time.minute);
    EventModel newEvent = EventModel(
      title: _title,
      notes: _notes,
      dateID: widget.dateID,
      timestamp: _timeStamp,
      members: _members,
      eventID: _eventID,
    );

    _calendarState.editEvent(
      event: newEvent,
      dateID: widget.dateID,
    );
    var _navState = NavService.calendarNavState;

    _navState.currentState.pop();
  }
}
