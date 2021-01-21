import 'package:cloud_firestore/cloud_firestore.dart';
import 'member_model.dart';

class ChatModel {
  final String latestMessage;
  final List<MemberModel> members;
  final String chatID;

  ChatModel({this.latestMessage, this.members, this.chatID});

  factory ChatModel.fromFirestore(DocumentSnapshot snap) {
    Map<String, dynamic> data = snap.data();
    Map<String, dynamic> _tempMembers = data['members'] ??
        {
          '': {'': ''}
        };
    List<MemberModel> _members = _tempMembers.keys.map((k) {
      return MemberModel.fromMap(member: _tempMembers[k], uid: k);
    }).toList();

    return ChatModel(
      chatID: snap.id,
      latestMessage: data['latestMessage'] ?? '',
      members:
          _members ?? MemberModel(uid: '', displayName: '', role: Role.noRole),
    );
  }
}
