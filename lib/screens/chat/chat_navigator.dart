import 'package:flutter/material.dart';
import 'package:flutter_calendar/helpers/nav_service.dart';
import 'package:flutter_calendar/screens/chat/all_chats.dart';

import '../SomethingWentWrong.dart';

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
