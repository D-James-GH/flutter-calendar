import 'package:flutter/material.dart';
import 'package:flutter_calendar/helpers/navService.dart';
import '../SomethingWentWrong.dart';
import 'Profile.dart';

class ProfileNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: NavService.profileNavState,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              switch (settings.name) {
                case '/':
                  return Profile();
                default:
                  return SomethingWentWrong();
              }
            });
      },
    );
  }
}
