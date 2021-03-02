import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_calendar/models/models.dart';
import 'package:flutter_calendar/services/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final UserDB _userDB = locator<UserDB>();

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

      if (result.additionalUserInfo.isNewUser) {
        _userDB.updateUserData(UserModel(
          email: user.email,
          uid: user.uid,
          displayName: user.displayName,
        ));
      }
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
        if (userCredential.additionalUserInfo.isNewUser) {
          UserModel userModel = UserModel(
            email: firebaseUser.email,
            uid: firebaseUser.uid,
            displayName: firebaseUser.displayName,
          );
          _userDB.updateUserData(userModel);
        }
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

  void updateUserProfile(String name) async {
    if (_auth.currentUser != null) {
      await _auth.currentUser.updateProfile(
        displayName: name,
      );
    }
  }

  // Future<User> anonLogin() async {
  //   UserCredential result = await _auth.signInAnonymously();
  //   User user = result.user;
  //
  //   updateUserData(user);
  //   return user;
  // }

  Future<void> resetPassword(String email) {
    return _auth
        .sendPasswordResetEmail(email: email)
        .then((value) => print('reset password'));
  }

  Future<void> signOut() {
    _googleSignIn.signOut();
    return _auth.signOut();
  }
}
