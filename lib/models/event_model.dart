import 'package:cloud_firestore/cloud_firestore.dart';
import 'member_model.dart';

class EventModel {
  final String title;
  final String notes;
  final String dateID;
  final DateTime timestamp;
  final List<MemberModel> memberRoles;
  final String eventID;
  // below is only used to get the event from the database
  final List<String> members;

  EventModel({
    this.notes,
    this.dateID,
    // this.time,
    this.title,
    this.eventID,
    this.memberRoles,
    this.timestamp,
  }) : members = memberRoles != null
            ? memberRoles.map((member) => member.uid).toList()
            : null;

  @override
  String toString() =>
      'EventModel { notes: $notes, dateID: $dateID, title: $title, eventID: $eventID, members: $memberRoles, timestamp: $timestamp }';

  factory EventModel.fromMap(Map<String, dynamic> data) {
    Timestamp _timestampFromDB = data['timeStamp'] ?? Timestamp.now();
    DateTime _timestamp = _timestampFromDB.toDate();
    Map<String, dynamic> _tempMemberRoles = data['memberRoles'] ??
        {
          '': {'': ''}
        };
    List<MemberModel> _memberRoles = _tempMemberRoles.keys.map((k) {
      return MemberModel.fromMap(member: _tempMemberRoles[k], uid: k);
    }).toList();

    return EventModel(
      title: data['title'] ?? '',
      notes: data['notes'] ?? '',
      dateID: data['dateID'] ?? '',
      memberRoles: _memberRoles,
      // time: data['time'] ?? '',
      timestamp: _timestamp,
      eventID: data['eventID'] ?? '',
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
      'title': title,
      'members': members,
      'dateID': dateID,
      // 'time': time,
      'eventID': eventID,
      'notes': notes,
      'memberRoles': mapMemberRoles,
      'timeStamp': timestamp,
    };
  }
}
