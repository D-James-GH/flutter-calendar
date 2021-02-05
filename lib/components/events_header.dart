import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_calendar/app_state/calendar_state.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventsHeader extends StatelessWidget {
  final bool isListViewOpen;
  final Function gotoListView;
  final GlobalKey<FormState> formKey;
  final Function toggleEditMode;
  final Function gotoEvent;
  final bool isEditable;
  final TextStyle headingText =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  EventsHeader({
    Key key,
    this.isListViewOpen,
    this.toggleEditMode,
    this.gotoListView,
    this.gotoEvent,
    this.isEditable,
    this.formKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CalendarState calendarState = Provider.of<CalendarState>(context);
    DateTime currentDate = calendarState.currentSelectedDate;

    // check if current date is the same as event date,
    // if not the event page should be list page
    if (calendarState.calcDateID(currentDate) !=
        calendarState.editFormEvent.dateID) {
      gotoListView();
    }

    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _displayLeadingIcon(context),
          isListViewOpen
              ? Text('')
              : SizedBox(
                  width: 10,
                ),
          ..._buildDate(currentDate, context),
          Expanded(
            child: Text(''),
          ),
          _displayTailIcon(context, calendarState),
        ],
      ),
    );
  }

  Widget _displayLeadingIcon(BuildContext context) {
    // no leading button in list view
    if (isListViewOpen) return Text('');
    // if not editing then you can go back to the list view
    if (!isEditable) {
      return IconButton(
        icon: Icon(
          FontAwesomeIcons.chevronLeft,
          color: Theme.of(context).primaryColor,
          size: 20,
        ),
        onPressed: gotoListView,
      );
    }
    // allow the user to exit edit mode without saving
    return IconButton(
      icon: Icon(
        FontAwesomeIcons.times,
        color: Theme.of(context).primaryColor,
        size: 20,
      ),
      onPressed: toggleEditMode,
    );
  }

  Widget _displayTailIcon(BuildContext context, CalendarState calendarState) {
    // trailing icon should add a new event if the list view(all events) page is shown
    if (isListViewOpen) {
      return IconButton(
        enableFeedback: true,
        onPressed: gotoEvent,
        icon: Icon(
          FontAwesomeIcons.calendarPlus,
          color: Theme.of(context).primaryColor,
        ),
      );
    }
    // if the event page is shown; the trailing icon button should change the event
    // to edit mode
    if (!isEditable) {
      return IconButton(
        enableFeedback: true,
        onPressed: toggleEditMode,
        icon: Icon(
          FontAwesomeIcons.edit,
          color: Theme.of(context).primaryColor,
        ),
      );
    }
    // finally, if the event page is in edit mode; the trailing icon button should
    // save and commit the event form
    return RaisedButton(
      onPressed: () => _submitEventForm(context, calendarState),
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Save', style: TextStyle(color: Colors.white)),
          SizedBox(
            width: 5,
          ),
          Icon(
            FontAwesomeIcons.save,
            color: Colors.white,
            size: 20,
          ),
        ],
      ),
    );
  }

  void _submitEventForm(BuildContext context, CalendarState calendarState) {
    // Validate returns true if the form is valid, otherwise false.
    // TODO: set up validate function
    if (formKey.currentState.validate()) {
      // If the form is valid, display a snack bar.
      formKey.currentState.save();

      // save event to db and state
      var calendarState = Provider.of<CalendarState>(context, listen: false);

      calendarState.saveEventToDB(calendarState.editFormEvent);
      toggleEditMode();
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Saving Event')));
    }
  }

  List<Widget> _buildDate(DateTime currentDate, BuildContext context) {
    return [
      Text(DateFormat.EEEE().format(currentDate), style: headingText),
      SizedBox(
        width: 5,
      ),
      Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            currentDate.day.toString(),
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      ),
      SizedBox(
        width: 5,
      ),
      Text(
        DateFormat.MMMM().format(currentDate),
        style: headingText,
      ),
    ];
  }
}
