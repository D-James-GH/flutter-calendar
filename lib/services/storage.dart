import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> getProfileImageUrl(String uid) {
    return storage.ref().child("user/profile_image_$uid").getDownloadURL();
  }

  Future<String> uploadProfile(File file) async {
    User user = _auth.currentUser;
    var storageRef = storage.ref().child("user/profile_image_${user.uid}");
    var uploadTask = storageRef.putFile(file);
    try {
      var downloadUrl = await (await uploadTask).ref.getDownloadURL();
      return downloadUrl;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }
}
