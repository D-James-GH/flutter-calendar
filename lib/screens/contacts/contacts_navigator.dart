import 'package:flutter/material.dart';

// custom lib
import '../../services/services.dart';
import '../something_went_wrong.dart';
import './contact_screen/contacts.dart';

class ContactNavigator extends StatelessWidget {
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
                  return Contacts();
                default:
                  return SomethingWentWrong();
              }
            });
      },
    );
  }
}
