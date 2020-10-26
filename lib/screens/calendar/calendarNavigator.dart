import 'package:flutter_calendar/helpers/navService.dart';
import 'package:flutter/material.dart';
import '../SomethingWentWrong.dart';
import 'allCalendarScreens.dart';

class CalendarNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: NavService.calendarNavState,
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
                  return DayView(
                    dateID: args.dateID,
                    dateObject: args.dateObject,
                    day: args.day,
                    month: args.month,
                    events: args.events,
                  );
                  break;
                default:
                  return SomethingWentWrong();
              }
            });
      },
    );
  }
}
