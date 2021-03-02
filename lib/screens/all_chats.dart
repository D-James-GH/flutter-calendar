import 'package:flutter/material.dart';
import 'package:flutter_calendar/app_state/chat_state.dart';
import 'package:flutter_calendar/components/chat_title.dart';
import 'package:flutter_calendar/components/user_avatar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

// custom lib
import '../models/member_model.dart';
import '../app_state/user_state.dart';
import '../models/models.dart';
import '../services/services.dart';
import 'pick_contact_screen.dart';
import 'screens.dart';

class AllChatScreen extends StatelessWidget {
  final ChatDB _chatDB = locator<ChatDB>();

  @override
  Widget build(BuildContext context) {
    var userState = Provider.of<UserState>(context);
    ChatState chatState = Provider.of<ChatState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        actions: <Widget>[
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
                    isPickGroupNameVisible: true,
                    onTapContactFunction: (List<MemberModel> members,
                        [String groupName]) async {
                      ChatModel createdChat = await chatState.createChat(
                        members: members,
                        groupName: groupName,
                        currentUser: userState.currentUser,
                      );
                      return chatState.gotoChat(context, createdChat);
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<ChatModel>>(
        stream: _chatDB.chatStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ChatModel> chats = snapshot.data;
            return ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, i) {
                  var leadingIcon;
                  // if there are only two members then one is the user and the other is one contact
                  // set leading icon to the display picture of the contact
                  // otherwise display picture should be the group symbol
                  if (chats[i].memberRoles.length == 2) {
                    MemberModel contact = chats[i].memberRoles.firstWhere(
                        (element) => element.uid != userState.currentUser.uid);
                    leadingIcon = UserAvatar(
                      uid: contact.uid,
                      name: contact.nickname,
                    );
                  } else {
                    leadingIcon = Container(
                      child: Icon(
                        FontAwesomeIcons.users,
                        color: Colors.white,
                        size: 20,
                      ),
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor,
                      ),
                    );
                  }
                  return ListTile(
                    leading: leadingIcon,
                    title:
                        chats[i].groupName == null || chats[i].groupName == ''
                            ? ChatTitle(members: chats[i].memberRoles)
                            : Text(chats[i].groupName),
                    subtitle: Text(chats[i].latestMessage),
                    trailing: Text(
                        TimeOfDay.fromDateTime(chats[i].latestMessageTime)
                            .format(context)),
                    onTap: () => chatState.gotoChat(context, chats[i]),
                  );
                });
          } else {
            return Center(child: Text('Start a chat now...'));
          }
        },
      ),
    );
  }
}
