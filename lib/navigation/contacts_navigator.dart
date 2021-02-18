import 'package:flutter/material.dart';

// custom lib
import '../screens/something_went_wrong.dart';
import '../screens/contacts_screen.dart';
import 'navigation_keys.dart';

class ContactsNavigator extends StatelessWidget {
  final bool isVisible;

  const ContactsNavigator({Key key, this.isVisible}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return isVisible
        ? Navigator(
            key: NavigationKeys.contactNavState,
            onGenerateRoute: (RouteSettings settings) {
              return MaterialPageRoute(
                  settings: settings,
                  builder: (BuildContext context) {
                    switch (settings.name) {
                      case '/':
                        return ContactsScreen();
                      // case '/contactScreen':
                      //   ContactsScreenArguments args = settings.arguments;
                      //   return ContactScreen(
                      //     contact: args.contact,
                      //   );
                      default:
                        return SomethingWentWrong();
                    }
                  });
            },
          )
        : Container();
  }
}
