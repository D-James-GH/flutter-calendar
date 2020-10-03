import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'models.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream<DayData> streamDayData(String id) {
  //   return _db
  //       .collection('calendarData')
  //       .doc(id)
  //       .snapshots()
  //       .map((document) => DayData.fromMap(document.data()));
  // }
}

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
        .then(
            (value) => value.docs.map((e) => Event.fromMap(e.data())).toList());

    return docs;
  }

  Stream<List<Event>> eventStream(date) {
    return _auth.authStateChanges().switchMap((user) {
      if (user != null) {
        return _db
            .collection('events')
            .where('members', arrayContains: user.uid)
            .where('date', isEqualTo: date)
            .snapshots()
            .map((snap) =>
                snap.docs.map((e) => Event.fromMap(e.data())).toList());
      } else {
        return Stream<List<Event>>.value(null);
      }
    });
  }

  void createEvent(Event data, String docRefIn) {
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
}
