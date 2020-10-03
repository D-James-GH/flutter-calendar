import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User> get getCurrentUser async {
    User currentUser = _auth.currentUser;
    return currentUser;
  }

  Stream<User> get user => _auth.authStateChanges();

  Future<User> googleSignIn() async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential result = await _auth.signInWithCredential(credential);
      User user = result.user;
      updateUserData(user);
      return user;

      // GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      // GoogleSignInAuthentication googleAuth =
      //     await googleSignInAccount.authentication;
      // final AuthCredential credential = GoogleAuthProvider.credential(
      //   accessToken: googleAuth.accessToken,
      //   idToken: googleAuth.accessToken,
      // );

      // UserCredential result = await _auth.signInWithCredential(credential);
      // User user = result.user;
      // updateUserData(user);
      // return user;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<User> anonLogin() async {
    UserCredential result = await _auth.signInAnonymously();
    User user = result.user;

    updateUserData(user);
    return user;
  }

  Future updateUserData(User user) {
    DocumentReference usersRef = _db.collection('users').doc(user.uid);
    return usersRef.set({
      'uid': user.uid,
    }, SetOptions(merge: true));
  }

  Future<void> signOut() {
    return _auth.signOut();
  }
}
