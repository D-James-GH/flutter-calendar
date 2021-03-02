// UserModel is the full  public user data, private userdata like contacts is
// stored in a separate sub-collection

class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String profileImageUrl;

  UserModel({
    this.profileImageUrl,
    this.uid,
    this.email,
    this.displayName,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
    ); // list of user id's of all the contacts
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'profileImageUrl': profileImageUrl,
    };
  }
}
