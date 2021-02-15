import 'package:cloud_firestore/cloud_firestore.dart';
import 'member_model.dart';

class ChatModel {
  final String latestMessage;
  final DateTime latestMessageTime;
  final List<MemberModel> memberRoles;
  final String chatID;
  final String groupName;
  // below is only used to get the event from the database
  final Map<String, dynamic> memberUIDs;
  final Map<String, dynamic> isVisibleTo;
  final int groupSize;

  ChatModel({
    this.groupName,
    this.latestMessageTime,
    this.memberUIDs,
    this.groupSize,
    this.isVisibleTo,
    this.latestMessage,
    this.memberRoles,
    this.chatID,
  });

  factory ChatModel.fromFirestore(DocumentSnapshot snap) {
    Map<String, dynamic> data = snap.data();
    Timestamp _latestMessageTimestamp =
        data['latestMessageTime'] ?? Timestamp.now();
    Map<String, dynamic> _tempMemberRoles = data['memberRoles'] ??
        {
          '': {'': ''}
        };
    List<MemberModel> _memberRoles = _tempMemberRoles.keys.map((k) {
      return MemberModel.fromMap(member: _tempMemberRoles[k], uid: k);
    }).toList();
    return ChatModel(
      groupName: data['groupName'] ?? '',
      groupSize: data['groupSize'] ?? 0,
      isVisibleTo: data['isVisibleTo'] ?? {'': true},
      memberUIDs: data['memberUIDs'] ?? {'': true},
      chatID: snap.id,
      latestMessageTime: _latestMessageTimestamp.toDate(),
      latestMessage: data['latestMessage'] ?? '',
      memberRoles: _memberRoles,
    );
  }

  Map<String, dynamic> toMap() {
    Map mapMemberRoles = {};
    memberRoles.forEach((member) {
      Map mapMember = member.toMap();
      mapMemberRoles = {
        ...mapMemberRoles,
        ...mapMember,
      };
    });
    return {
      'groupName': groupName,
      'groupSize': groupSize,
      'memberUIDs': memberUIDs,
      'memberRoles': mapMemberRoles,
      'latestMessage': latestMessage,
      'latestMessageTime': latestMessageTime,
      'isVisibleTo': isVisibleTo,
    };
  }
}
