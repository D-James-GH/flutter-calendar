class MemberModel {
  final String uid;
  final String displayName;
  final String role;
  ChatMember({this.uid, this.displayName, this.role});

  factory ChatMember.fromMap({Map<String, dynamic> member, String uid = ''}) {
    return ChatMember(
      uid: uid,
      displayName: member['displayName'] ?? '',
      role: member['role'] ?? '',
    );
  }

  Map toMap() {
    return {
      "uid": {
        "displayName": displayName,
        "role": role,
      }
    };
  }
}
