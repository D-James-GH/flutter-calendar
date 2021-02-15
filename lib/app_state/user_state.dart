import 'package:flutter/material.dart';
import 'package:flutter_calendar/services/services.dart';
import '../models/models.dart';

class UserState extends ChangeNotifier {
  UserDB _userData = locator<UserDB>();
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

  Future<bool> addContactFromEmail(String email) async {
    print("$email from state");
    UserModel newContact = await _userData.createContact(email);
    if (newContact != null) {
      _contacts.add(newContact);
      notifyListeners();
      return true;
    }
    return false;
  }
}
