// Haven't worked out whether this file is actually needed yet
// at the moment chats are working purely with streams so no state is needed.

import 'package:flutter/material.dart';
import 'package:flutter_calendar/models/models.dart';
import 'package:flutter_calendar/screens/screens.dart';
import 'package:flutter_calendar/services/services.dart';

class ChatState extends ChangeNotifier {
  // this file is to have all interaction with the db in one place
  final ChatDB _chatDB = locator<ChatDB>();

  // if multiple chats with the same person
  //
  Stream<List<ChatModel>> get chatStream => _chatDB.chatStream();

  Future<ChatModel> createChat({
    List<MemberModel> members,
    UserModel currentUser,
    String groupName = '',
  }) async {
    Map<String, dynamic> memberUIDs = {}; // used to find chats in the db easily
    Map<String, dynamic> isVisibleTo = {}; // used to delete a user from a chat
    List<MemberModel> memberRoles = []; // used to determine who can edit things
    // Take the incoming contacts and set them to visible and add them to the chat
    members.forEach((member) {
      memberUIDs[member.uid] = true;
      isVisibleTo[member.uid] = true;
      memberRoles.add(MemberModel(
        role: Role.member,
        nickname: member.nickname,
        uid: member.uid,
      ));
    });
    // add the current use to the chat
    memberRoles.add(
      MemberModel(
          uid: currentUser.uid,
          nickname: currentUser.displayName,
          role: Role.admin),
    );
    isVisibleTo[currentUser.uid] = true;
    memberUIDs[currentUser.uid] = true;

    // use the memberUIDs list to check if this chat already exists.
    // it will use the length of the memberUIDs to make sure it will only
    // check for chats with ONLY the incoming members.
    ChatModel chat;
    ChatModel existingChat = await _chatDB.getExistingChat(memberUIDs);
    if (existingChat == null) {
      // currently creating chat does not exist
      // create a temporary chat, leave the chatID blank so that firebase generates the id
      chat = ChatModel(
        groupName: groupName,
        groupSize: memberUIDs.length,
        latestMessage: '',
        memberUIDs: memberUIDs,
        memberRoles: memberRoles,
        isVisibleTo: isVisibleTo,
      );
    } else {
      chat = ChatModel(
        groupName: existingChat.groupName,
        groupSize: existingChat.groupSize,
        latestMessage: existingChat.latestMessage,
        memberUIDs: existingChat.memberUIDs,
        memberRoles: existingChat.memberRoles,
        isVisibleTo: isVisibleTo,
      );
    }

    String newChatID = await _chatDB.createChat(chat);

    // create another new chat with the correctly generated document id
    chat = ChatModel(
      chatID: newChatID,
      groupName: chat.groupName,
      groupSize: chat.groupSize,
      latestMessage: chat.latestMessage,
      memberUIDs: chat.memberUIDs,
      memberRoles: chat.memberRoles,
      isVisibleTo: chat.isVisibleTo,
    );
    return chat;
  }

  void gotoChat(BuildContext context, ChatModel chat) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        settings: RouteSettings(name: '/chat'),
        builder: (_) => ChatScreen(
          chat: chat,
        ),
      ),
    );
  }
}
