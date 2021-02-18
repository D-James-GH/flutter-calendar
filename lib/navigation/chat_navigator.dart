import 'package:flutter/material.dart';

// custom lib
import '../screens/all_chats.dart';

import '../screens/something_went_wrong.dart';
import 'navigation_keys.dart';

class ChatNavigator extends StatelessWidget {
  final bool isVisible;

  const ChatNavigator({Key key, this.isVisible}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return isVisible
        ? Navigator(
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
          )
        : Container();
  }
}
