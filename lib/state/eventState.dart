import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar/services/models.dart';
import 'package:flutter_calendar/services/service_locator.dart';
import 'package:get_it/get_it.dart';
import '../services/db.dart';

class EventState extends ChangeNotifier {
  UserData _userData = locator<UserData>();

  Map<String, List<EventModel>> events = {};

  List<EventModel> getDayEvents(dateID) => events[dateID];

  addEvents(dateID) async {
    // if (_userData.eventStream(dateID) != null) {
    events[dateID] = await _userData.getEvents(dateID) ?? [];
    notifyListeners();
    // }
  }
}
