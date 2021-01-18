import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String text;
  final String sentBy;
  bool seen;
  DateTime sentTime;

  MessageModel({this.text, this.sentBy, this.seen, this.sentTime});

  factory MessageModel.fromMap(Map<String, dynamic> data) {
    Timestamp _timeFromDB = data['sentTime'];
    DateTime _time = _timeFromDB.toDate();
    return MessageModel(
      text: data['text'] ?? '',
      sentBy: data['sentBy'] ?? '',
      seen: data['seen'] ?? false,
      sentTime: _time ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'sentBy': sentBy,
      'seen': seen,
      'sentTime': sentTime,
    };
  }
}
