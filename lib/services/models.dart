import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String title;
  final String notes;
  final String dateID;
  final String time;
  final List members;
  final String eventID;

  EventModel({
    this.notes,
    this.dateID,
    this.time,
    this.title,
    this.eventID,
    this.members,
  });

  factory EventModel.fromMap(Map<String, dynamic> data) {
    return EventModel(
      title: data['title'],
      notes: data['notes'] ?? '',
      dateID: data['date'] ?? '',
      members: data['members'] ?? [''],
      time: data['time'] ?? '',
      eventID: data['eventID'] ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': dateID,
      'time': time,
      'eventID': eventID,
      'notes': notes,
      'members': members
    };
  }
}

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

class ChatModel {
  final String latestMessage;
  final Map members;
  final String chatID;

  ChatModel({this.latestMessage, this.members, this.chatID});

  factory ChatModel.fromFirestore(DocumentSnapshot snap) {
    Map<String, dynamic> data = snap.data();
    return ChatModel(
      chatID: snap.id,
      latestMessage: data['latestMessage'] ?? '',
      members: data['members'] ?? {'': ''},
    );
  }
}
