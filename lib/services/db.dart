import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'models.dart';

class UserData {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> getDocs(String date) {
    User user = _auth.currentUser;

    var docs = _db
        .collection('events')
        .where('members', arrayContains: user.uid)
        .where('date', isEqualTo: date)
        .get()
        .then((value) =>
            value.docs.map((e) => EventModel.fromMap(e.data())).toList());

    return docs;
  }

  Stream<List<EventModel>> eventStream(date) {
    return _auth.authStateChanges().switchMap((user) {
      if (user != null) {
        return _db
            .collection('events')
            .where('members', arrayContains: user.uid)
            .where('date', isEqualTo: date)
            .snapshots()
            .map((snap) =>
                snap.docs.map((e) => EventModel.fromMap(e.data())).toList());
      } else {
        return Stream<List<EventModel>>.value(null);
      }
    });
  }

  void createEvent(EventModel data, String docRefIn) {
    User user = _auth.currentUser;
    CollectionReference ref = _db.collection('events');
    String docRef = docRefIn ?? data.eventID;
    if (user != null) {
      ref
          .doc(docRef)
          .set(data.toMap(), SetOptions(merge: true))
          .then((value) => print('done'));
    }
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
            .where('members.' + user.uid, isGreaterThan: '')
            .snapshots()
            .map((snap) =>
                snap.docs.map((e) => ChatModel.fromFirestore(e)).toList());
      } else {
        return Stream<List<ChatModel>>.value(null);
      }
    });
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
