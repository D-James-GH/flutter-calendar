import 'package:flutter/material.dart';
import 'package:flutter_calendar/helpers/navService.dart';
import 'package:flutter_calendar/services/service_locator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import '../../services/models.dart';
import '../../services/db.dart';
import 'CreateChatScreen.dart';

import 'ChatScreen.dart';

class AllChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserData userData = locator<UserData>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        actions: [
          IconButton(
              icon: Icon(
                FontAwesomeIcons.edit,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    settings: RouteSettings(name: '/createChat'),
                    builder: (_) => CreateChatScreen(),
                  ),
                );
              }),
        ],
      ),
      body: StreamBuilder<List<ChatModel>>(
          stream: userData.chatModelStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<ChatModel> chats = snapshot.data;

              return ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      leading: Icon(Icons.person),
                      title: _listMembers(chats[0].members),
                      subtitle: Text(chats[i].latestMessage),
                      trailing: Text('Time Sent'),
                      onTap: () =>
                          _gotoChat(context, chats[i].chatID, chats[i].members),
                    );
                  });
            } else {
              return Center(child: Text('Start a chat now...'));
            }
          }),
    );
  }

  Widget _listMembers(Map members) {
    String output = '';
    members.keys.forEach((e) => output += e);
    return Text(output);
  }

  void _gotoChat(context, chatID, members) {
    // NavService.chatNavState.currentState.pushNamed('/chat');
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        settings: RouteSettings(name: '/chat'),
        builder: (_) => Chat(
          chatID: chatID,
          members: members,
        ),
      ),
    );
  }
}

// children: [
// ListTile(
// leading: Icon(Icons.person),
// title: Text('Members Name'),
// subtitle: Text('Some Recent message'),
// trailing: Text('Time Sent'),
// onTap: () => _gotoChat(context),
// )
// ],
