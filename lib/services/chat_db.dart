import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

import '../models/models.dart';

class ChatDB {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<List<MessageModel>> messageStream(String chatID) {
    return _auth.authStateChanges().switchMap((user) {
      if (user != null) {
        return _db
            .collection('chats')
            .doc(chatID)
            .collection('messages')
            .orderBy('sentTime', descending: true)
            .limit(20)
            .snapshots()
            .map((snap) =>
                snap.docs.map((e) => MessageModel.fromMap(e.data())).toList());
      } else {
        return Stream<List<MessageModel>>.value(null);
      }
    });
  }

  Stream<List<ChatModel>> chatStream() {
    return _auth.authStateChanges().switchMap((user) {
      if (user != null) {
        return _db
            .collection('chats')
            .where('memberUIDs.' + user.uid, isEqualTo: true)
            .where('isVisibleTo.' + user.uid, isEqualTo: true)
            .snapshots()
            .map((snap) {
          return snap.docs.map((e) => ChatModel.fromFirestore(e)).toList();
        });
      } else {
        return Stream<List<ChatModel>>.value(null);
      }
    });
  }

  // Future<List<UserModel>> getUserByEmail(String email) {
  //   return _db
  //       .collection('users')
  //       .where('email', isEqualTo: email)
  //       .get()
  //       .then((value) {
  //     if (value.docs.isNotEmpty) {
  //       return value.docs.map((e) => UserModel.fromMap(e.data())).toList();
  //     } else {
  //       // return null if user does not exist in the db
  //       return null;
  //     }
  //   }).catchError((error) => print(error));
  // }

  // Future<bool> createChat({
  //   // List<String> userEmails = const [],
  //   List<UserModel> contacts = const [],
  // }) async {
  //   User loggedInUser = _auth.currentUser;
  //   Map<String, dynamic> members = {};
  //
  //   // if (userEmails == []) {
  //   //   // need to convert emails to uid
  //   //   for (String email in userEmails) {
  //   //     List<UserModel> tempUser = await UserDB().getUserByEmail(email);
  //   //     if (tempUser != null) {
  //   //       members[tempUser[0].uid] = {
  //   //         'displayName': tempUser[0].displayName,
  //   //         'role': 'member',
  //   //       };
  //   //     }
  //   //   }
  //   // } else {
  //   // uids were given rather than emails
  //   for (UserModel contact in contacts) {
  //     members[contact.uid] = {
  //       'displayName': contact.displayName,
  //       'role': Role.member.toShortString,
  //     };
  //   }
  //   // }
  //   // if at least one of the members needed to create the chat exist
  //   if (members.length != 0) {
  //     if (loggedInUser != null) {
  //       // add the logged in user to the chat
  //       members[loggedInUser.uid] = {
  //         'displayName': loggedInUser.displayName,
  //         'role': 'admin',
  //       };
  //
  //       _db.collection('chats').add({
  //         'members': members,
  //         'latestMessage': ' ',
  //       }).then((value) => print('chat added'));
  //     }
  //     /* returning true signifies the invited users are in the db */
  //     return true;
  //   } else {
  //     /* this will run if the email of the invited user does
  //      not exist when creating a chat */
  //     return false;
  //   }
  // }
  Future<ChatModel> getExistingChat(
    Map<String, dynamic> memberUIDs,
  ) async {
    CollectionReference ref = _db.collection('chats');
    Query query = ref;
    for (var k in memberUIDs.keys) {
      query = query.where('memberUIDs.' + k, isEqualTo: true);
    }
    var result =
        await query.where('groupSize', isEqualTo: memberUIDs.length).get();
    if (result.docs.length == 0) {
      return null;
    }
    if (result.docs.length > 1) {
      print('there should not be more than one');
    }
    return ChatModel.fromFirestore(result.docs[0]);
  }

  Future<String> createChat(ChatModel chat) {
    print('creating chat');
    print(chat.memberUIDs);
    var chatID = chat.chatID == '' ? null : chat.chatID;
    DocumentReference docRef = _db.collection('chats').doc(chatID);
    print(chat.toMap());
    return docRef
        .set(chat.toMap(), SetOptions(merge: true))
        .then((val) => docRef.id);
  }

  void updateGroupName({String groupName, String chatID}) {
    // could use create chat to do this but that requires creating a new ChatModel
    _db.collection('chats').doc(chatID).update({'groupName': groupName}).then(
        (value) => print('group name changed'));
  }

  Future<void> removeUserFromChat(ChatModel chat) {
    // delete chat from that user
    // this is equivalent to deleting the user from the chat
    CollectionReference chatRef = _db.collection('chats');

    // create a new chat without current user
    // remove user from isVisible to
    Map<String, dynamic> newIsVisibleTo = chat.isVisibleTo;
    newIsVisibleTo[_auth.currentUser.uid] = false;

    ChatModel newChat = ChatModel(
      chatID: chat.chatID,
      latestMessage: chat.latestMessage,
      isVisibleTo: newIsVisibleTo,
      memberRoles: chat.memberRoles,
      memberUIDs: chat.memberUIDs,
      groupSize: chat.groupSize,
    );

    if (_auth.currentUser != null) {
      return chatRef
          .doc(chat.chatID)
          .set(newChat.toMap(), SetOptions(merge: true));
    }

    return Future.value(null);
  }

  void sendMessage(MessageModel message, String chatID) {
    User user = _auth.currentUser;
    if (user != null) {
      WriteBatch batch = _db.batch();
      // write to the messages collection
      DocumentReference messageRef =
          _db.collection('chats').doc(chatID).collection('messages').doc();
      batch.set(messageRef, message.toMap());

      // update the latest message on the chat
      DocumentReference chatRef = _db.collection('chats').doc(chatID);
      batch.set(
          chatRef,
          {
            'latestMessage': message.text,
            'latestMessageTime': message.sentTime
          },
          SetOptions(merge: true));

      batch
          .commit()
          .then((value) => print('message added'))
          .catchError((error) => print(error));
    }
  }
}
