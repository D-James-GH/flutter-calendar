class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final List contacts;

  UserModel({this.uid, this.email, this.displayName, this.contacts});

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
        uid: data['uid'] ?? '',
        email: data['email'] ?? '',
        displayName: data['displayName'] ?? '',
        contacts:
            data['contacts'] ?? ['']); // list of user id's of all the contacts
  }
}
