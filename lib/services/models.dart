import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class EventModel extends Equatable {
  final String title;
  final String notes;
  final String dateID;
  final DateTime timestamp;
  // final String time;
  final List members;
  final String eventID;

  EventModel({
    this.notes,
    this.dateID,
    // this.time,
    this.title,
    this.eventID,
    this.members,
    this.timestamp,
  });

  @override
  List<Object> get props => [notes, dateID, title, eventID, members, timestamp];

  @override
  String toString() =>
      'EventModel { notes: $notes, dateID: $dateID, title: $title, eventID: $eventID, members: $members, timestamp: $timestamp }';

  factory EventModel.fromMap(Map<String, dynamic> data) {
    Timestamp _timestampFromDB = data['timeStamp'] ?? Timestamp.now();
    DateTime _timestamp = _timestampFromDB.toDate();
    return EventModel(
      title: data['title'],
      notes: data['notes'] ?? '',
      dateID: data['dateID'] ?? '',
      members: data['members'] ?? [''],
      // time: data['time'] ?? '',
      timestamp: _timestamp,
      eventID: data['eventID'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'dateID': dateID,
      // 'time': time,
      'eventID': eventID,
      'notes': notes,
      'members': members,
      'timeStamp': timestamp,
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

class UserModel {
  final String uid;
  final String email;
  final String displayName;

  UserModel({this.uid, this.email, this.displayName});

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      displayName: data['displayName'],
    );
  }
}
