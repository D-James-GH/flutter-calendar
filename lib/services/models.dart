  class Event {
  final String title;
  final String notes;
  final String dateID;
  final String time;
  final List members;
  final String eventID;

  Event({
    this.notes,
    this.dateID,
    this.time,
    this.title,
    this.eventID,
    this.members,
  });

  factory Event.fromMap(Map<String, dynamic> data) {
    return Event(
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

// class DayData {
//   final List<Event> events;
//   final String dateID;

//   DayData({
//     this.events,
//     this.dateID,
//   });

//   factory DayData.fromFirestore(DocumentSnapshot doc) {
//     Map data = doc.data();
//     return DayData(
//       dateID: doc.id,
//       events: data['events'],
//     );
//   }
//   factory DayData.fromMap(Map data) {
//     return DayData(
//       dateID: data['dateID'],
//       events: (data['events'] as List).map((e) => Event.fromMap(e)).toList(),
//       // .map((e) => Event.fromMap(e)).toList(),
//     );
//   }
// }
