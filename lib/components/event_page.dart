import 'package:flutter/material.dart';
import 'package:flutter_calendar/app_state/calendar_state.dart';
import 'package:flutter_calendar/components/contact_form_field.dart';
import 'package:flutter_calendar/components/list_member_avatars.dart';
import 'package:flutter_calendar/components/time_form_field.dart';
import 'package:provider/provider.dart';
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
            EventRow(
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
            EventRow(
              label: 'Time',
              body: isEdit
                  ? TimeFormField(
                      onSaved: (TimeOfDay time) => _onSaved(time: time),
                      initialValue:
                          TimeOfDay.fromDateTime(currentEvent.timestamp),
                    )
                  : Text(
                      TimeOfDay.fromDateTime(currentEvent.timestamp)
                          .format(context),
                      style: TextStyle(fontSize: 16),
                    ),
            ),
            EventRow(
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
            EventRow(
              label: 'Attendees',
              body: isEdit
                  ? ContactSelectFormField(
                      onSaved: (List<MemberModel> members) =>
                          _onSaved(memberRoles: members),
                      initialValue: currentEvent.memberRoles,
                    )
                  : ListMemberAvatars(
                      members: currentEvent.memberRoles,
                      maxNum: 5,
                      showNames: true,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSaved({
    String notes,
    String title,
    List<MemberModel> memberRoles,
    TimeOfDay time,
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
        timestamp: time != null
            ? new DateTime(
                calendarState.currentSelectedDate.year,
                calendarState.currentSelectedDate.month,
                calendarState.currentSelectedDate.day,
                time.hour,
                time.minute,
              )
            : tempEvent.timestamp,
      ),
    );
  }
}

class EventRow extends StatelessWidget {
  final String label;
  final Widget body;

  const EventRow({Key key, this.label, this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context).primaryColor.withOpacity(0.7),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              //   border: Border.all(
              // color: Theme.of(context).primaryColor.withOpacity(0.5),
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                ),
              ),
            ),
            child: body,
          ),
        ),
      ],
    );
  }
}
