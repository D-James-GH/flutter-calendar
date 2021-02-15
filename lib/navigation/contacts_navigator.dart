import 'package:flutter/material.dart';
import 'package:flutter_calendar/screens/contact_screen.dart';

// custom lib
import '../screens/something_went_wrong.dart';
import '../screens/contacts_screen.dart';
import 'navigation_keys.dart';

class ContactNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: NavigationKeys.contactNavState,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              switch (settings.name) {
                case '/':
                  return Contacts();
                case ContactScreen.routeName:
                  ContactsScreenArguments args = settings.arguments;
                  return ContactScreen(
                    contact: args.contact,
                  );
                default:
                  return SomethingWentWrong();
              }
            });
      },
    );
  }
}
