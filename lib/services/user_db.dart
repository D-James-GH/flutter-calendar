import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_calendar/models/contact_model.dart';
import 'package:flutter_calendar/models/models.dart';

class UserDB {
  final CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<UserModel>> getUserByEmail(String email) {
    email = email.toLowerCase();
    return collectionRef.where('email', isEqualTo: email).get().then((value) {
      if (value.docs.isNotEmpty) {
        return value.docs.map((e) => UserModel.fromMap(e.data())).toList();
      } else {
        // return null if user does not exist in the db
        return null;
      }
    }).catchError((error) => print(error));
  }

  Future<UserModel> get currentUserFromDB {
    return getUser(_auth.currentUser.uid);
  }

  Future<UserModel> getUser(String uid) {
    return collectionRef
        .doc(uid)
        .get()
        .then((doc) => UserModel.fromMap(doc.data()));
  }

  void updateContact(ContactModel contact) {
    collectionRef
        .doc(_auth.currentUser.uid)
        .collection('contacts')
        .doc('contacts')
        .set(contact.toMap(), SetOptions(merge: true));
  }

  void deleteContact(String contactUid, String uid) {
    // should delete "contact" from the user with the specified uid
    collectionRef
        .doc(uid)
        .collection('contacts')
        .doc('contacts')
        .update({contactUid: FieldValue.delete()});
  }

  Future<Map<String, ContactModel>> getContacts() {
    return collectionRef
        .doc(_auth.currentUser.uid)
        .collection('contacts')
        .doc('contacts')
        .get()
        .then((contacts) {
      Map<String, ContactModel> output = {};
      contacts.data().forEach((String key, value) {
        output[key] = ContactModel.fromMap(data: value, uid: key);
      });
      return output;
    });
  }

  void createContact(ContactModel contact) {
    // contacts are stored in a sub collection so that they are not sent when others are
    // receiving user information

    User loggedInUser = _auth.currentUser;
    collectionRef
        .doc(loggedInUser.uid)
        .collection('contacts')
        .doc('contacts')
        .set(contact.toMap(), SetOptions(merge: true));

    // List<UserModel> userContact = await getUserByEmail(email);
    // if (userContact != null && loggedInUser != null) {
    //   userRef.doc(loggedInUser.uid).set({
    //     'contacts': FieldValue.arrayUnion([userContact[0].uid])
    //   }, SetOptions(merge: true));
    //   return userContact[0];
    // } else {
    //   return null;
    // }
  }

  void sendReply(ContactModel contact) {
    ContactModel user = ContactModel(
      accepted: contact.accepted,
      sent: contact.sent,
      uid: _auth.currentUser.uid,
      nickname: _auth.currentUser.displayName,
    );
    collectionRef
        .doc(contact.uid)
        .collection('contacts')
        .doc('contacts')
        .set(user.toMap(), SetOptions(merge: true))
        .then((value) => print('rspv'));
  }

  void sendInvite(ContactModel contact) {
    // create current user as a contact
    // but set the sent to false and the accepted to false
    ContactModel user = ContactModel(
      accepted: false,
      sent: false,
      uid: _auth.currentUser.uid,
      nickname: _auth.currentUser.displayName,
    );
    collectionRef
        .doc(contact.uid)
        .collection('contacts')
        .doc('contacts')
        .set(user.toMap(), SetOptions(merge: true));
  }

  Future updateUserData(UserModel user) {
    DocumentReference doc = collectionRef.doc(user.uid);
    return doc.set(user.toMap(), SetOptions(merge: true));
  }
}
