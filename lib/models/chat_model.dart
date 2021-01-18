import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String latestMessage;
  final Map<String, dynamic> members;
  final String chatID;

  ChatModel({this.latestMessage, this.members, this.chatID});

  factory ChatModel.fromFirestore(DocumentSnapshot snap) {
    Map<String, dynamic> data = snap.data();
    return ChatModel(
      chatID: snap.id,
      latestMessage: data['latestMessage'] ?? '',
      members: data['members'] ??
          {
            '': {'': ''}
          },
    );
  }
}
