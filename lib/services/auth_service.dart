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
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

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
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<User> userRegister(email, password, displayName) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User user = userCredential.user;

      await user.updateProfile(displayName: displayName);
      await user.reload();

      if (_auth.currentUser != null) {
        User firebaseUser = _auth.currentUser;
        updateUserData(firebaseUser);
      }
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('the password provided is too weak.');
        return null;
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email');
        return null;
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User> userSignIn(email, password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = userCredential.user;
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return null;
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return null;
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Future<User> anonLogin() async {
  //   UserCredential result = await _auth.signInAnonymously();
  //   User user = result.user;
  //
  //   updateUserData(user);
  //   return user;
  // }

  Future updateUserData(User user) {
    DocumentReference usersRef = _db.collection('users').doc(user.uid);
    return usersRef.set({
      'uid': user.uid,
      'displayName': user.displayName,
      'email': user.email,
    }, SetOptions(merge: true));
  }

  Future<void> signOut() {
    _googleSignIn.signOut();
    return _auth.signOut();
  }
}
