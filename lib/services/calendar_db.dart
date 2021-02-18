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

  Future<List<EventModel>> getEventsWithContact(String contactUID) async {
    User user = _auth.currentUser;
    if (user != null) {
      CollectionReference ref = _db.collection('events');
      var result = await ref
          .where('memberUIDs.' + user.uid, isEqualTo: true)
          .where('memberUIDs.' + contactUID, isEqualTo: true)
          .where('isPast', isEqualTo: false)
          .get();
      if (result.docs.length != null) {
        WriteBatch batch = _db.batch();
        var eventModels = result.docs.map((event) {
          print(event.data());
          EventModel eventModel = EventModel.fromMap(event.data());
          // below prevents the event coming up in future queries.
          // It is not a frequently used feature as this query is only used once on a contacts page
          if (DateTime.now().isAfter(eventModel.endTimestamp)) {
            print('in the past');
            DocumentReference docRef = ref.doc(event.id);
            batch.set(docRef, {'isPast': true}, SetOptions(merge: true));
          }
          return eventModel;
        }).toList();
        batch.commit().then((_) => print('changed isPast'));
        return eventModels;
      }
      return [];
    }
    return [];
  }

  Future<List<EventModel>> getEvents(String dateID) async {
    User user = _auth.currentUser;
    if (user != null) {
      var result = await _db
          .collection('events')
          .where('memberUIDs.' + user.uid, isEqualTo: true)
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
