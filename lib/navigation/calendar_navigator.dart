import 'package:flutter/material.dart';
import 'package:flutter_calendar/navigation/navigation_keys.dart';

// custom lib
import '../screens/screens.dart';

class CalendarNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: NavigationKeys.calendarNavState,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              switch (settings.name) {
                case '/':
                  return CalendarScreen();
                  break;
                default:
                  return SomethingWentWrong();
              }
            });
      },
    );
  }
}
