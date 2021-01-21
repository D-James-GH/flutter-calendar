import 'package:cloud_firestore/cloud_firestore.dart';
import 'member_model.dart';

class EventModel {
  final String title;
  final String notes;
  final String dateID;
  final DateTime timestamp;
  final List<MemberModel> members;
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
  String toString() =>
      'EventModel { notes: $notes, dateID: $dateID, title: $title, eventID: $eventID, members: $members, timestamp: $timestamp }';

  factory EventModel.fromMap(Map<String, dynamic> data) {
    Timestamp _timestampFromDB = data['timeStamp'] ?? Timestamp.now();
    DateTime _timestamp = _timestampFromDB.toDate();
    Map<String, dynamic> _tempMembers = data['members'] ??
        {
          '': {'': ''}
        };
    List<MemberModel> _members = _tempMembers.keys.map((k) {
      return MemberModel.fromMap(member: _tempMembers[k], uid: k);
    }).toList();

    return EventModel(
      title: data['title'] ?? '',
      notes: data['notes'] ?? '',
      dateID: data['dateID'] ?? '',
      members: _members,
      // time: data['time'] ?? '',
      timestamp: _timestamp,
      eventID: data['eventID'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    Map mapMembers = {};
    members.forEach((member) {
      Map mapMember = member.toMap();
      mapMembers = {
        ...mapMembers,
        ...mapMember,
      };
    });
    return {
      'title': title,
      'dateID': dateID,
      // 'time': time,
      'eventID': eventID,
      'notes': notes,
      'members': mapMembers,
      'timeStamp': timestamp,
    };
  }
}
