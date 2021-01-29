import 'package:flutter/material.dart';
import 'package:flutter_calendar/screens/pick_contact_screen.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../app_state/user_state.dart';
import '../app_state/calendar_state.dart';
import '../models/models.dart';

class EditEvent extends StatefulWidget {
  final EventModel event;
  final ScrollController listController;
  final Function gotoListView;

  EditEvent({Key key, this.event, this.listController, this.gotoListView})
      : super(key: key);
  @override
  _EditEventState createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  final _formKey = GlobalKey<FormState>();
  // CalendarBloc _calendarBloc;
  CalendarState _calendarState;
  UserModel _user;
  TimeOfDay _time;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _notesController = TextEditingController();
  List<MemberModel> _memberRoles = [];

  @override
  void initState() {
    super.initState();
    _calendarState = Provider.of<CalendarState>(context, listen: false);
    _user = Provider.of<UserState>(context, listen: false).currentUserModel;
    if (widget.event != null) {
      _memberRoles = widget.event.memberRoles;
      _time = TimeOfDay.fromDateTime(widget.event.timestamp);
      _notesController.text = widget.event.notes;
      _titleController.text = widget.event.notes;
    } else {
      _memberRoles.add(
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
  void dispose() {
    // TODO: implement dispose
    _notesController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.focusedChild.unfocus();
        }
      },
      behavior: HitTestBehavior.translucent,
      child: Form(
        key: _formKey,
        child: ListView(
          controller: widget.listController,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Event Title',
                labelStyle: TextStyle(fontSize: 20),
              ),
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
              controller: _notesController,
              minLines: 4,
              maxLines: 10,
              decoration: InputDecoration(
                  labelText: 'Notes',
                  hintText: 'Enter notes on your event',
                  labelStyle: TextStyle(fontSize: 18)),
            ),
            InvitedMembers(
              members: _memberRoles,
              user: _user,
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
    setState(() {
      _memberRoles.add(MemberModel(
        displayName: contact.displayName,
        uid: contact.uid,
        role: Role.member,
      ));
    });
  }

  void onSubmit(BuildContext context) {
    String _eventID = widget.event != null ? widget.event.eventID : Uuid().v4();
    String dateID =
        _calendarState.calcDateID(_calendarState.currentSelectedDate);
    DateTime _timeStamp = widget.event != null
        ? new DateTime(
            widget.event.timestamp.year,
            widget.event.timestamp.month,
            widget.event.timestamp.day,
            _time.hour,
            _time.minute,
          )
        : new DateTime(
            _calendarState.currentSelectedDate.year,
            _calendarState.currentSelectedDate.month,
            _calendarState.currentSelectedDate.day,
            _time.hour,
            _time.minute);
    EventModel newEvent = EventModel(
      title: _titleController.text,
      notes: _notesController.text,
      dateID: dateID,
      timestamp: _timeStamp,
      memberRoles: _memberRoles,
      eventID: _eventID,
    );

    _calendarState.editEvent(
      event: newEvent,
      dateID: dateID,
    );
    // go back to all events
    widget.gotoListView();
  }
}

class InvitedMembers extends StatelessWidget {
  final List<MemberModel> members;
  final UserModel user;
  const InvitedMembers({Key key, this.members, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Wrap(
        children: members.length > 1 ? _buildMembers() : [Text('')],
      ),
    );
  }

  List<Widget> _buildMembers() {
    return members.map((member) {
      if (member.uid != user.uid) {
        return Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.teal[100]),
          child: Text(member.displayName),
        );
      }
      return Text('');
    }).toList();
  }
}
