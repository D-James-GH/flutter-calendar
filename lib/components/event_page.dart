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

    EventModel currentEvent = Provider.of<CalendarState>(context).editFormEvent;
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
                          showNames: true,
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
      currentUser: userState.currentUserModel,
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
}
