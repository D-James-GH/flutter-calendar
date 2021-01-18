import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// custom lib
import '../../models/models.dart';
import '../../services/services.dart';
import 'all_chat_screens.dart';

class AllChatScreen extends StatelessWidget {
  final MessageData messageData = locator<MessageData>();

  @override
  Widget build(BuildContext context) {
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
          stream: messageData.chatStream(),
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
