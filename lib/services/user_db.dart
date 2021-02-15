import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_calendar/models/models.dart';

class UserDB {
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

  Future<UserModel> createContact(String email) async {
    List<UserModel> userContact = await getUserByEmail(email);
    User loggedInUser = _auth.currentUser;
    if (userContact != null && loggedInUser != null) {
      userRef.doc(loggedInUser.uid).set({
        'contacts': FieldValue.arrayUnion([userContact[0].uid])
      }, SetOptions(merge: true));
      return userContact[0];
    } else {
      return null;
    }
  }
}
