import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

import '../models/models.dart';

class CalendarDB {
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

  Future<void> createEvent(EventModel data) {
    User user = _auth.currentUser;
    CollectionReference ref = _db.collection('events');
    if (user != null) {
      return ref
          .doc(data.eventID)
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
