import 'package:flutter/material.dart';
import 'package:flutter_calendar/app_state/calendar_state.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventsHeader extends StatelessWidget {
  final bool isListViewOpen;
  final Function gotoListView;
  final Function gotoEvent;
  final TextStyle headingText =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  EventsHeader(
      {Key key, this.isListViewOpen, this.gotoListView, this.gotoEvent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    CalendarState calendarState = Provider.of<CalendarState>(context);
    DateTime currentDate = calendarState.currentSelectedDate;

    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // AnimatedOpacity(
          //   duration: Duration(milliseconds: 200),
          //   opacity: isListViewOpen ? 0 : 1.0,
          isListViewOpen
              ? Text('')
              : InkWell(
                  child: Icon(
                    FontAwesomeIcons.chevronLeft,
                    color: Theme.of(context).primaryColor,
                    size: 18,
                  ),
                  onTap: isListViewOpen ? null : gotoListView,
                ),

          isListViewOpen
              ? Text('')
              : SizedBox(
                  width: 10,
                ),

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
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
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
          Expanded(
            child: Text(''),
          ),
          IconButton(
            enableFeedback: true,
            onPressed: gotoEvent,
            icon: Icon(
              FontAwesomeIcons.calendarPlus,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(
            width: 15,
          ),
        ],
      ),
    );
  }
}
