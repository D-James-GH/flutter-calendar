import 'package:flutter/material.dart';

// custom lib
import '../screens/something_went_wrong.dart';
import '../screens/contacts_screen.dart';
import 'navigation_keys.dart';

class ContactNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: NavigationKeys.profileNavState,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              switch (settings.name) {
                case '/':
                  return Contacts();
                default:
                  return SomethingWentWrong();
              }
            });
      },
    );
  }
}
