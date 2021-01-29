import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../app_state/calendar_state.dart';
import '../components/calendar.dart';
import '../components/events.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  bool _isPanelOpened = false;

  @override
  Widget build(BuildContext context) {
    CalendarState calendarState = Provider.of<CalendarState>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:
            Text(DateFormat.MMMM().format(calendarState.currentSelectedDate)),
      ),
      body: SlidingUpPanel(
        onPanelOpened: _onPanelOpened,
        onPanelClosed: _onPanelClosed,
        minHeight: MediaQuery.of(context).size.height * 0.35,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(25), topLeft: Radius.circular(25)),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
              stops: [
                0.2,
                0.9,
              ],
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).accentColor
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Calendar(isPanelOpened: _isPanelOpened),
            ],
          ),
        ),
        panelBuilder: (ScrollController controller) =>
            Events(listController: controller),
      ),
    );
  }

  _onPanelClosed() {
    setState(() {
      _isPanelOpened = false;
    });
  }

  _onPanelOpened() {
    setState(() {
      _isPanelOpened = true;
    });
  }
}
