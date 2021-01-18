import 'package:flutter/material.dart';

// custom lib
import '../../services/services.dart';
import 'all_chats.dart';

import '../something_went_wrong.dart';

class ChatNavigator extends StatefulWidget {
  @override
  _ChatNavigatorState createState() => _ChatNavigatorState();
}

class _ChatNavigatorState extends State<ChatNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: NavService.chatNavState,
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
