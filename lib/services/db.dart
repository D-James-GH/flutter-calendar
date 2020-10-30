import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'models.dart';

class UserData {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<EventModel>> eventStream(dateID) {
    return _auth.authStateChanges().switchMap((user) {
      if (user != null) {
        var result = _db
            .collection('events')
            .where('members', arrayContains: user.uid)
            .where('dateID', isEqualTo: dateID)
            .snapshots()
            .map((snap) =>
                snap.docs.map((e) => EventModel.fromMap(e.data())).toList());
        return result;
      } else {
        return Stream<List<EventModel>>.value(null);
      }
    });
  }

  Future<List<EventModel>> getEvents(String dateID) async {
    User user = _auth.currentUser;
    if (user != null) {
      var result = await _db
          .collection('events')
          .where('members', arrayContains: user.uid)
          .where('dateID', isEqualTo: dateID)
          .get();
      List<EventModel> events = result.docs.length != 0
          ? result.docs.map((event) {
              return EventModel.fromMap(event.data());
            }).toList()
          : [];

      return events;
    } else {
      return Future<List<EventModel>>.value(null);
    }
  }

  Future<void> createEvent({EventModel data, String docRefIn}) {
    User user = _auth.currentUser;
    CollectionReference ref = _db.collection('events');
    String docRef = docRefIn ?? data.eventID;
    if (user != null) {
      return ref
          .doc(docRef)
          .set(data.toMap(), SetOptions(merge: true))
          .then((value) => print('done'));
    }
    return Future.value(null);
  }

  Future<void> deleteEvent(String docID) {
    User user = _auth.currentUser;
    CollectionReference ref = _db.collection('events');
    if (user != null) {
      return ref.doc(docID).delete().then((value) => print('done delete'));
    }
    return Future.value(null);
  }

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

  Stream<List<ChatModel>> chatModelStream() {
    return _auth.authStateChanges().switchMap((user) {
      if (user != null) {
        return _db
            .collection('chats')
            .where('members.' + user.uid, isGreaterThan: {})
            .snapshots()
            .map((snap) {
              return snap.docs.map((e) => ChatModel.fromFirestore(e)).toList();
            });
      } else {
        return Stream<List<ChatModel>>.value(null);
      }
    });
  }

  Future<List<UserModel>> getUserByEmail(String email) {
    return _db.collection('users').where('email', isEqualTo: email).get().then(
        (value) => value.docs.map((e) => UserModel.fromMap(e.data())).toList());
  }

  void createChat(List<String> userEmails) async {
    User user = _auth.currentUser;
    Map<String, dynamic> members = {};
    for (String email in userEmails) {
      List<UserModel> tempUser = await getUserByEmail(email);
      print(tempUser[0].uid);
      members[tempUser[0].uid] = {
        'displayName': tempUser[0].displayName,
        'role': 'member',
      };
    }
    members[user.uid] = {
      'displayName': user.displayName,
      'role': 'admin',
    };

    if (user != null) {
      _db.collection('chats').add({
        'members': members,
        'latestMessage': ' ',
      }).then((value) => print('chat added'));
    }
  }

  void sendMessage(MessageModel message, String chatID) {
    User user = _auth.currentUser;
    if (user != null) {
      _db
          .collection('chats')
          .doc(chatID)
          .collection('messages')
          .add(message.toMap())
          .then((value) => print('messaged'));
    }
  }
}
