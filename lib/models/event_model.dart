import 'package:cloud_firestore/cloud_firestore.dart';
import 'member_model.dart';

class EventModel {
  final String title;
  final String notes;
  final String dateID;
  final DateTime startTimestamp;
  final DateTime endTimestamp;
  final List<MemberModel> memberRoles;
  final String eventID;
  final bool isPast;
  // below is only used to get the event from the database
  final Map<String, dynamic> memberUIDs;

  EventModel({
    this.isPast = false,
    this.notes,
    this.dateID,
    this.title,
    this.eventID,
    this.memberRoles,
    this.startTimestamp,
    this.endTimestamp,
  }) : memberUIDs = memberRoles != null
            ? {for (MemberModel member in memberRoles) member.uid: true}
            : null;

  @override
  String toString() =>
      'EventModel { notes: $notes, dateID: $dateID, memberUIDs: $memberUIDs,title: $title, eventID: $eventID, members: $memberRoles, startTimestamp: $startTimestamp, endTimestamp: $endTimestamp }';

  factory EventModel.fromMap(Map<String, dynamic> data) {
    Timestamp _startTimestampFromDB = data['startTimeStamp'] ?? Timestamp.now();
    Timestamp _endTimestampFromDB = data['endTimeStamp'] ?? Timestamp.now();
    // convert the timestamp to datetime to make it easier to work with
    DateTime _startTimestamp = _startTimestampFromDB.toDate();
    DateTime _endTimestamp = _endTimestampFromDB.toDate();
    // make sure there is a default member roles map to prevent 'called on null error'
    Map<String, dynamic> _tempMemberRoles = data['memberRoles'] ??
        {
          '': {'': ''}
        };
    // convert member roles map to a list of memberModel's
    // we gain auto completion from this now
    List<MemberModel> _memberRoles = _tempMemberRoles.keys.map((key) {
      // check if the user has created a nickname for this member

      return MemberModel.fromMap(
        member: _tempMemberRoles[key],
        uid: key,
      );
    }).toList();
    return EventModel(
      title: data['title'] ?? '',
      notes: data['notes'] ?? '',
      dateID: data['dateID'] ?? '',
      isPast: data['isPast'] ?? false,
      memberRoles: _memberRoles,
      startTimestamp: _startTimestamp,
      endTimestamp: _endTimestamp,
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
      'memberUIDs': memberUIDs,
      'dateID': dateID,
      'eventID': eventID,
      'isPast': isPast,
      'notes': notes,
      'memberRoles': mapMemberRoles,
      'startTimeStamp': startTimestamp,
      'endTimeStamp': endTimestamp,
    };
  }
}
