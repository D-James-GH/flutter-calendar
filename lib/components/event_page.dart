import 'package:flutter/material.dart';
import 'package:flutter_calendar/app_state/calendar_state.dart';
import 'package:flutter_calendar/app_state/chat_state.dart';
import 'package:flutter_calendar/app_state/user_state.dart';
import 'package:flutter_calendar/components/contact_select_form_field.dart';
import 'package:flutter_calendar/components/list_member_avatars.dart';
import 'package:flutter_calendar/components/time_form_field.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'labeled_row.dart';
import '../models/models.dart';

class EventPage extends StatefulWidget {
  // final EventModel event;
  final bool isEditable;
  final Function gotoListView;
  final formKey;
  EventPage({
    Key key,
    @required this.gotoListView,
    @required this.isEditable,
    @required this.formKey,
  }) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  // logged in user
  CalendarState calendarState;
  bool _confirmedEventDelete = false;
  @override
  Widget build(BuildContext context) {
    bool isEdit = widget.isEditable;

    var inputDecoration = InputDecoration(
      isCollapsed: true,
      contentPadding: EdgeInsets.symmetric(vertical: 0),
      border: InputBorder.none,
      labelStyle: TextStyle(fontSize: 16),
      filled: true,
      fillColor: Colors.white,
    );

    calendarState = Provider.of<CalendarState>(context);
    EventModel currentEvent = calendarState.editFormEvent;
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
        key: widget.formKey,
        child: Column(
          children: [
            LabeledRow(
              label: 'Title',
              body: isEdit
                  ? TextFormField(
                      initialValue: currentEvent.title,
                      onSaved: (String value) => _onSaved(title: value),
                      decoration: inputDecoration,
                      validator: (value) {
                        if (value == '') {
                          return 'Title must not be empty';
                        }
                        return null;
                      },
                    )
                  : Text(
                      currentEvent.title,
                      style: TextStyle(fontSize: 16),
                    ),
            ),
            LabeledRow(
              label: 'Time',
              body: isEdit
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Start:'),
                        TimeFormField(
                          onSaved: (TimeOfDay time) =>
                              _onSaved(startTime: time),
                          initialValue: TimeOfDay.fromDateTime(
                              currentEvent.startTimestamp),
                        ),
                        Text('End:'),
                        TimeFormField(
                          onSaved: (TimeOfDay time) => _onSaved(endTime: time),
                          initialValue:
                              TimeOfDay.fromDateTime(currentEvent.endTimestamp),
                        ),
                      ],
                    )
                  : Text(
                      "${TimeOfDay.fromDateTime(currentEvent.startTimestamp).format(context)} - ${TimeOfDay.fromDateTime(currentEvent.endTimestamp).format(context)}",
                      style: TextStyle(fontSize: 16),
                    ),
            ),
            LabeledRow(
              label: 'Details',
              body: isEdit
                  ? TextFormField(
                      onSaved: (String value) => _onSaved(notes: value),
                      initialValue: currentEvent.notes,
                      minLines: 4,
                      maxLines: 10,
                      decoration: inputDecoration,
                    )
                  : Container(
                      constraints: BoxConstraints(minHeight: 40),
                      child: Text(
                        currentEvent.notes,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
            ),
            LabeledRow(
              label: 'Attendees',
              body: isEdit
                  ? ContactSelectFormField(
                      onSaved: (List<MemberModel> members) =>
                          _onSaved(memberRoles: members),
                      initialValue: currentEvent.memberRoles,
                    )
                  : Column(
                      children: [
                        ListMemberAvatars(
                          hasMargin: true,
                          members: currentEvent.memberRoles,
                          maxNum: 5,
                          showNames: false,
                        ),
                        RaisedButton(
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat,
                                color: Colors.white,
                                size: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text('Message',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                          onPressed: () => _messageMembersOfEvent(
                              members: currentEvent.memberRoles),
                        ),
                      ],
                    ),
            ),
            if (currentEvent.title != '')
              Container(
                margin: EdgeInsets.only(top: 50),
                width: 170,
                child: RaisedButton(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Delete Event',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                      FaIcon(FontAwesomeIcons.trashAlt, color: Colors.white)
                    ],
                  ),
                  onPressed: _deleteEvent,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _messageMembersOfEvent({List<MemberModel> members}) async {
    ChatState chatState = Provider.of<ChatState>(context, listen: false);
    UserState userState = Provider.of<UserState>(context, listen: false);
    ChatModel createdChat = await chatState.createChat(
      members: members,
      currentUser: userState.currentUser,
    );
    return chatState.gotoChat(context, createdChat);
  }

  void _onSaved({
    String notes,
    String title,
    List<MemberModel> memberRoles,
    TimeOfDay startTime,
    TimeOfDay endTime,
  }) {
    var calendarState = Provider.of<CalendarState>(context, listen: false);
    // updating the currently edited event ready to submit to the db
    EventModel tempEvent = calendarState.editFormEvent;
    calendarState.setEditFormEvent(
      EventModel(
        notes: notes != null ? notes : tempEvent.notes,
        eventID: tempEvent.eventID,
        title: title != null ? title : tempEvent.title,
        dateID: tempEvent.dateID,
        memberRoles: memberRoles != null ? memberRoles : tempEvent.memberRoles,
        startTimestamp: startTime != null
            ? _toDateTime(startTime, calendarState)
            : tempEvent.startTimestamp,
        endTimestamp: endTime != null
            ? _toDateTime(endTime, calendarState)
            : tempEvent.endTimestamp,
      ),
    );
  }

  DateTime _toDateTime(TimeOfDay time, CalendarState calendarState) {
    return new DateTime(
      calendarState.currentSelectedDate.year,
      calendarState.currentSelectedDate.month,
      calendarState.currentSelectedDate.day,
      time.hour,
      time.minute,
    );
  }

  void _deleteEvent() async {
    UserModel user = Provider.of<UserState>(context, listen: false).currentUser;
    EventModel event = calendarState.editFormEvent;
    // is the user allowed to delete the event?
    MemberModel userRole =
        event.memberRoles.firstWhere((member) => member.uid == user.uid);
    if (userRole.role == Role.admin) {
      // the user is allowed to delete this event
      // show alert to confirm deletion
      await alertDialog(true);
      if (_confirmedEventDelete) {
        calendarState.deleteEvent(event, isAdmin: true);
        _confirmedEventDelete = false;
        widget.gotoListView();
      }
    } else {
      // show alert, ask the user if they want to remove themselves from the event
      // Todo: remove user if they dont have permission
      await alertDialog(false);
      if (_confirmedEventDelete) {
        calendarState.deleteEvent(event, isAdmin: false, uid: user.uid);
        _confirmedEventDelete = false;
        widget.gotoListView();
      }
    }
  }

  Future<void> alertDialog(bool isFullDelete) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'Are you sure you want to delete this event?',
            style: TextStyle(color: Colors.black87),
          ),
          content: Text(
              isFullDelete
                  ? 'This cannot be undone and will delete the event for everyone.'
                  : 'This will just remove you from the event, it will not delete it for everyone else.',
              style: TextStyle(color: Colors.black54)),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                    .pop(); // Dismiss alert dialog
              },
            ),
            FlatButton(
              color: Colors.red,
              child: Row(children: [
                Text('Delete'),
                SizedBox(width: 5),
                FaIcon(FontAwesomeIcons.trashAlt)
              ]),
              onPressed: () {
                _confirmedEventDelete = true;
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
