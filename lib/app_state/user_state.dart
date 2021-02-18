import 'package:flutter/material.dart';
import 'package:flutter_calendar/models/contact_model.dart';
import 'package:flutter_calendar/services/services.dart';
import '../models/models.dart';

class UserState extends ChangeNotifier {
  UserDB _userDB = locator<UserDB>();
  // only fetch once, set the initial flags
  bool _doneInitBasicContactsFetch = false;
  UserModel currentUser = UserModel();
  Map<String, UserModel> contacts = {};
  Map<String, ContactModel> _customContactData = {};

  // List<UserModel> get contacts {
  //   return _contacts.entries.map((e) => e.value).toList();
  // }

  Map<String, ContactModel> get customContactData {
    if (_doneInitBasicContactsFetch != true) {
      fetchBasicContactList();
      _doneInitBasicContactsFetch = true;
    }
    return _customContactData;
  }

  void changeNickname({String nickname, UserModel contact}) {
    // add nickname to state.
    contacts[contact.uid] = UserModel(
      uid: contact.uid,
      email: contact.email,
      displayName: nickname,
    );

    // update the current users contacts collection with the new nickname
    ContactModel contactModel =
        ContactModel(userID: contact.uid, nickname: nickname);
    _customContactData[contact.uid] = contactModel;
    _userDB.updateNickname(contactModel);
    notifyListeners();
  }

  Future<void> fetchUserFromDB() async {
    currentUser = await _userDB.currentUserFromDB;
  }

  Future<void> fetchBasicContactList() async {
    _customContactData = await _userDB.getContacts();
  }

  Future<void> fetchContactsFromDB() async {
    /*
     - get the list of contacts from database.
     - Contacts are stored in a sub-collection under the user so that
       the list is never visible by anyone other than the logged in user
     - The Contacts list also stores any custom nicknames/display names
    */
    await fetchBasicContactList();
    // loop through the contacts list and fetch the corresponding user information
    await Future.forEach(
        _customContactData.entries.map((e) => e.value).toList(), (value) async {
      UserModel contact = await _userDB.getUser(value.userID);
      // check if the logged in user has created a nickname for this contact
      if (value.nickname != '' && value.nickname != null) {
        contact = UserModel(
          displayName: value.nickname,
          email: contact.email,
          uid: contact.uid,
        );
      }
      // add the contact to the app state
      contacts[contact.uid] = contact;
    });
    notifyListeners();
  }

  Future<bool> addContactFromEmail(String email) async {
    // fetch the user from the database using their email.
    List<UserModel> userContact = await _userDB.getUserByEmail(email);
    if (userContact != null) {
      UserModel contact = userContact[0];
      contacts[contact.uid] = contact;
      var model = ContactModel(nickname: '', userID: userContact[0].uid);
      _userDB.createContact(model);
      notifyListeners();
      return true;
    }
    // tell the user there was no one registered with that email address.
    return false;
  }
}
