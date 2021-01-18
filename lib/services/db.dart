import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

import '../models/models.dart';

class CalendarData {
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
}

class MessageData {
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
    return _db
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        return value.docs.map((e) => UserModel.fromMap(e.data())).toList();
      } else {
        // return null if user does not exist in the db
        return null;
      }
    }).catchError((error) => print(error));
  }

  Future<bool> createChat({
    List<String> userEmails = const [],
    List<UserModel> contacts = const [],
  }) async {
    User loggedInUser = _auth.currentUser;
    Map<String, dynamic> members = {};

    if (userEmails == []) {
      // need to convert emails to uid
      for (String email in userEmails) {
        List<UserModel> tempUser = await getUserByEmail(email);
        if (tempUser != null) {
          members[tempUser[0].uid] = {
            'displayName': tempUser[0].displayName,
            'role': 'member',
          };
        }
      }
    } else {
      // uids were given rather than emails
      for (UserModel contact in contacts) {
        members[contact.uid] = {
          'displayName': contact.displayName,
          'role': 'member',
        };
      }
    }
    // if at least one of the members needed to create the chat exist
    if (members.length != 0) {
      if (loggedInUser != null) {
        // add the logged in user to the chat
        members[loggedInUser.uid] = {
          'displayName': loggedInUser.displayName,
          'role': 'admin',
        };

        _db.collection('chats').add({
          'members': members,
          'latestMessage': ' ',
        }).then((value) => print('chat added'));
      }
      /* returning true signifies the invited users are in the db */
      return true;
    } else {
      /* this will run if the email of the invited user does
       not exist when creating a chat */
      return false;
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

class UserData {
  final CollectionReference userRef =
      FirebaseFirestore.instance.collection('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<UserModel>> getUserByEmail(String email) {
    return userRef.where('email', isEqualTo: email).get().then((value) {
      if (value.docs.isNotEmpty) {
        return value.docs.map((e) => UserModel.fromMap(e.data())).toList();
      } else {
        // return null if user does not exist in the db
        return null;
      }
    }).catchError((error) => print(error));
  }

  Future<UserModel> get currentUserFromDB {
    return getUserFromDB(_auth.currentUser.uid);
  }

  Future<UserModel> getUserFromDB(String uid) {
    return userRef.doc(uid).get().then((doc) => UserModel.fromMap(doc.data()));
  }

  Future<bool> createContact(String email) async {
    List<UserModel> userContact = await getUserByEmail(email);
    User loggedInUser = _auth.currentUser;
    if (userContact != null && loggedInUser != null) {
      userRef.doc(loggedInUser.uid).set({
        'contacts': FieldValue.arrayUnion([userContact[0].uid])
      }, SetOptions(merge: true));
      return true;
    } else {
      return false;
    }
  }
}
