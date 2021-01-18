import 'package:flutter/material.dart';

// custom lib
import '../../services/services.dart';
import '../something_went_wrong.dart';
import 'all_calendar_screens.dart';

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
