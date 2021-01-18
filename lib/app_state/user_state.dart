import 'package:flutter/material.dart';
import 'package:flutter_calendar/services/db.dart';
import 'package:flutter_calendar/models/models.dart';
import 'package:flutter_calendar/services/service_locator.dart';

class UserState extends ChangeNotifier {
  UserData _userData = locator<UserData>();
  bool _doneInitFetch = false;
  UserModel _currentUser;
  List<UserModel> _contacts = [];

  List<UserModel> get contacts {
    if (_doneInitFetch != true) {
      fetchInitStateFromDB();
      _doneInitFetch = true;
    }
    return _contacts;
  }

  UserModel get currentUserModel {
    if (_doneInitFetch != true) {
      fetchInitStateFromDB();
      _doneInitFetch = true;
    }
    return _currentUser;
  }

  Future<void> fetchInitStateFromDB() async {
    _currentUser = await _userData.currentUserFromDB;
    List currentUserContactIDs = _currentUser.contacts;
    currentUserContactIDs.forEach((id) async {
      UserModel contact = await _userData.getUserFromDB(id);
      _contacts.add(contact);
    });
  }
}
