import 'package:flutter/material.dart';
import 'package:flutter_calendar/app_state/user_state.dart';
import 'package:flutter_calendar/components/event_page.dart';
import 'package:flutter_calendar/models/models.dart';
import 'package:uuid/uuid.dart';
import '../models/event_model.dart';
import 'package:provider/provider.dart';
import '../app_state/calendar_state.dart';
import 'events_header.dart';
import 'event_tile.dart';

class Events extends StatefulWidget {
  final ScrollController listController;
  Events({Key key, this.listController}) : super(key: key);

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  bool _isEditing = false;
  PageController _pageController =
      PageController(initialPage: 0, keepPage: false);
  bool _isListViewOpen = true;
  EventPage _editEventPage;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 4,
            width: 55,
          ),
          EventsHeader(
              formKey: _formKey,
              isListViewOpen: _isListViewOpen,
              isEditable: _isEditing,
              toggleEditMode: _toggleEditMode,
              gotoListView: _gotoListView,
              gotoEvent: _gotoEvent),
          Opacity(
            opacity: 0.8,
            child: Divider(
              // endIndent: 20,
              // indent: 20,
              thickness: 2,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Expanded(
            child: Consumer<CalendarState>(
              builder: (context, state, child) {
                String dateID = state.calcDateID(state.currentSelectedDate);
                List<EventModel> events = state.events[dateID];
                return PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: _pageChanged,
                  children: [
                    events != null
                        ? ListView(
                            scrollDirection: Axis.vertical,
                            controller: widget.listController,
                            children: _buildEvents(events),
                          )
                        : Text(''),
                    _editEventPage,
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildEvents(List<EventModel> events) {
    return events.map((event) {
      return EventTile(
        event: event,
        gotoEvent: () => _gotoEvent(event),
      );
    }).toList();
  }

  void _toggleEditMode() {
    if (_formKey.currentState.validate() == false) {
      setState(() {
        _isEditing = !_isEditing;
      });
      _gotoListView();
    } else {
      setState(() {
        _isEditing = !_isEditing;
        _editEventPage = EventPage(
          formKey: _formKey,
          isEditable: _isEditing,
          gotoListView: _gotoListView,
        );
      });
    }
  }

  void _gotoEvent([EventModel event]) {
    var user = Provider.of<UserState>(context, listen: false);
    var calendarState = Provider.of<CalendarState>(context, listen: false);

    // if creating a new event setup the eventID and dateID and add the current user
    if (event == null) {
      _isEditing = true;
      String dateID =
          calendarState.calcDateID(calendarState.currentSelectedDate);
      String eventID = Uuid().v4();
      var currentUserAsMember = MemberModel(
        uid: user.currentUserModel.uid,
        role: Role.admin,
        displayName: user.currentUserModel.displayName,
      );
      event = EventModel(
        dateID: dateID,
        eventID: eventID,
        title: '',
        notes: '',
        startTimestamp: DateTime.now(),
        memberRoles: [currentUserAsMember],
      );
    }
    calendarState.setEditFormEvent(event);
    setState(() {
      _isListViewOpen = false;
      _editEventPage = EventPage(
        formKey: _formKey,
        isEditable: _isEditing,
        gotoListView: _gotoListView,
      );
    });

    _pageController.animateToPage(1,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOutSine);
  }

  void _gotoListView() {
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOutSine);
  }

  void _pageChanged(int index) {
    if (index == 0) {
      setState(() {
        _isListViewOpen = true;
        _editEventPage = EventPage(
          formKey: _formKey,
          isEditable: _isEditing,
          // listController: null,
          gotoListView: _gotoListView,
        );
      });
    }
  }
}
