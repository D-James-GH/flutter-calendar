// Contact model is the information on a user stored in the user > contacts sub collection
// it allows us to store custom names for contacts without effecting other users
// it also allows us to send invites and accept/decline invites
class ContactModel {
  final String uid;
  final String nickname;
  final bool accepted;
  final bool sent;

  ContactModel({this.sent, this.uid, this.nickname = '', this.accepted});

  factory ContactModel.fromMap({Map<String, dynamic> data, String uid = ''}) {
    return ContactModel(
      nickname: data['nickname'] ?? '',
      uid: uid,
      sent: data['sent'] ?? false,
      accepted: data['accepted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      uid: {
        'nickname': nickname,
        'accepted': accepted,
        'sent': sent,
      }
    };
  }
}
