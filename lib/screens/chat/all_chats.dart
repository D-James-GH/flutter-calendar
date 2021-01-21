import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

// custom lib
import '../../models/member_model.dart';
import '../../app_state/user_state.dart';
import '../../models/models.dart';
import '../../services/services.dart';
import '../shared/pick_contact_screen.dart';
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
                    builder: (_) => PickContactScreen(
                      onTapContactFunction: _createChat,
                    ),
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
                      title: _listMembers(chats[i].members, context),
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

  Widget _listMembers(List<MemberModel> members, BuildContext context) {
    UserState _userState = Provider.of<UserState>(context);
    String output = '';
    members.forEach((member) {
      if (members.length > 1 &&
          _userState.currentUserModel.displayName != member.displayName) {
        output += member.displayName;
      } else if (members.length == 1) {
        output += member.displayName;
      }
    });
    return Text(output);
  }

  void _createChat(UserModel contact) {
    // temp until you can add multiple people to chat
    List<UserModel> contacts = [contact];
    messageData.createChat(contacts: contacts);
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
