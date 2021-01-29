import 'package:flutter/material.dart';

// custom lib
import '../screens/all_chats.dart';

import '../screens/something_went_wrong.dart';
import 'navigation_keys.dart';

class ChatNavigator extends StatefulWidget {
  @override
  _ChatNavigatorState createState() => _ChatNavigatorState();
}

class _ChatNavigatorState extends State<ChatNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: NavigationKeys.chatNavState,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              switch (settings.name) {
                case '/':
                  return AllChatScreen();
                // case '/chat':
                // return Chat();
                default:
                  return SomethingWentWrong();
              }
            });
      },
    );
  }
}
