class UserModel {
  final String uid;
  final String email;
  final String displayName;

  UserModel({
    this.uid,
    this.email,
    this.displayName,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
    ); // list of user id's of all the contacts
  }
}
