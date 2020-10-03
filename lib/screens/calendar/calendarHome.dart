import 'dart:developer';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar/screens/UnfoundRoute.dart';
import 'package:flutter_calendar/screens/calendar/WeekCell.dart';

import 'allCalendarScreens.dart';

class CalendarHome extends StatefulWidget {
  CalendarHome({Key key}) : super(key: key);

  @override
  _CalendarHomeState createState() => _CalendarHomeState();
}

class _CalendarHomeState extends State<CalendarHome> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Provider.of<GlobalKey<NavigatorState>>(context, listen: false),
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              switch (settings.name) {
                case '/':
                  return MonthScreen();
                  break;
                case '/dayView':
                  ScreenArguments args = settings.arguments;
                  print(args.day);
                  return DayView(
                    dateID: args.dateID,
                    day: args.day,
                    month: args.month,
                    events: args.events,
                  );
                  break;
                default:
                  return UnfoundRoute();
              }
            });
      },
    );
  }
}
