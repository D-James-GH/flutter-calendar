import 'package:flutter/material.dart';
import 'package:flutter_calendar/components/edit_event.dart';
import '../models/event_model.dart';
import 'package:provider/provider.dart';
import '../app_state/calendar_state.dart';
import 'event_header.dart';
import 'event_tile.dart';

class Events extends StatefulWidget {
  final ScrollController listController;
  Events({Key key, this.listController}) : super(key: key);

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  PageController _pageController = PageController(initialPage: 0);
  CalendarState _calendarState;
  bool _isListViewOpen = true;
  EventModel _viewEvent;

  @override
  Widget build(BuildContext context) {
    _calendarState = Provider.of<CalendarState>(context);
    String dateID =
        _calendarState.calcDateID(_calendarState.currentSelectedDate);
    List<EventModel> events = _calendarState.events[dateID];
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
              isListViewOpen: _isListViewOpen,
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
            child: PageView(
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
                EditEvent(
                  event: _viewEvent,
                  listController: widget.listController,
                  gotoListView: _gotoListView,
                ),
              ],
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

  void _gotoEvent([EventModel event]) {
    if (event != null) {
      setState(() {
        _viewEvent = event;
      });
    }
    _pageController.animateToPage(1,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOutSine);
  }

  void _gotoListView() {
    setState(() {
      _viewEvent = null;
    });
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 200), curve: Curves.easeInOutSine);
  }

  void _pageChanged(int index) {
    setState(() {
      _isListViewOpen = !_isListViewOpen;
    });
  }
}
