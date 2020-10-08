import 'package:flutter/material.dart';
import 'package:flutter_calendar/helpers/navService.dart';
import 'package:flutter_calendar/screens/chat/AllChats.dart';
import 'package:provider/provider.dart';
import '../../services/db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../SomethingWentWrong.dart';
import 'ChatScreen.dart';

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
