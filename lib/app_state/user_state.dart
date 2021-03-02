import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_calendar/models/contact_model.dart';
import 'package:flutter_calendar/services/services.dart';
import '../models/models.dart';

class UserState extends ChangeNotifier {
  UserDB _userDB = locator<UserDB>();
  // only fetch once, set the initial flags
  // the contacts list is all of the users contacts in full,
  // as in all public information on them in the db
  bool isContactsInitialized = false;
  // basic contact list is just a list of uid stored on the current logged in user
  bool isBasicContactsInitialized = false;
  UserModel currentUser = UserModel();
  Map<String, UserModel> contacts = {};
  Map<String, ContactModel> _basicContacts = {};
  List<ContactModel> pendingContacts = [];

  Map<String, ContactModel> get customContactData {
    if (isBasicContactsInitialized != true) {
      fetchBasicContactList();
      isBasicContactsInitialized = true;
    }
    return _basicContacts;
  }

  void changeNickname({String nickname, UserModel contact}) {
    // add nickname to state.
    contacts[contact.uid] = UserModel(
      uid: contact.uid,
      email: contact.email,
      displayName: nickname,
      profileImageUrl: contact.profileImageUrl,
    );

    // update the current users contacts collection with the new nickname
    ContactModel contactModel = ContactModel(
      uid: contact.uid,
      nickname: nickname,
      accepted: true,
    );
    _basicContacts[contact.uid] = contactModel;
    _userDB.updateContact(contactModel);
    notifyListeners();
  }

  void confirmContact(ContactModel contact, {@required bool confirm}) {
    // this function will only be run the user has been sent
    // update contact with the accepted of declined value
    contact = ContactModel(
      nickname: contact.nickname,
      uid: contact.uid,
      sent: contact.sent,
      accepted: confirm,
    );

    // if the user declines the contact then the contact should be deleted from the
    // current user and the contact's sub-collection
    if (confirm == false) {
      // delete contact from both ends
      _basicContacts.remove(contact.uid);
      // delete from current user
      _userDB.deleteContact(contact.uid, currentUser.uid);
      // delete from contact
      _userDB.deleteContact(currentUser.uid, contact.uid);
    } else {
      // this is run if the contact invitation is accepted
      // update the basic contact list(the one stored on the signed in user)
      // update in state
      _basicContacts[contact.uid] = contact;
      // update in the signed in user db
      _userDB.updateContact(contact);

      // update the contacts user profile
      _userDB.sendReply(contact);
    }

    // re-fetch contacts with the new details
    fetchContactsFromDB();
    notifyListeners();
  }

  Future<void> fetchUserFromDB() async {
    currentUser = await _userDB.currentUserFromDB;
  }

  Future<void> fetchBasicContactList() async {
    _basicContacts = await _userDB.getContacts();
    isBasicContactsInitialized = true;
  }

  Future<void> fetchContactsFromDB() async {
    // reset the pending contacts state as fetching contacts will re-add any pending contacts
    pendingContacts = [];
    /*
     - get the list of contacts from database.
     - Contacts are stored in a sub-collection under the user so that
       the list is never visible by anyone other than the logged in user
     - The Contacts list also stores any custom nicknames/display names
    */
    await fetchBasicContactList();
    // loop through the contacts list and fetch the corresponding user information
    if (_basicContacts.isNotEmpty) {
      await Future.forEach(
        _basicContacts.entries.map((e) => e.value).toList(),
        (ContactModel value) async {
          // check for unaccepted invites
          if (value.accepted == false && value.sent == false) {
            // this will run if the current user did not send the invite and has not yet accepted it
            pendingContacts.add(value);
          } else {
            UserModel contact = await _userDB.getUser(value.uid);
            // add the users custom nick name
            contact = UserModel(
              displayName: value.nickname,
              email: contact.email,
              uid: contact.uid,
              profileImageUrl: contact.profileImageUrl,
            );
            // add the contact to the app state
            contacts[contact.uid] = contact;
          }
        },
      );
    }
    isContactsInitialized = true;
    notifyListeners();
  }

  Future<bool> addContactFromEmail(String email) async {
    // fetch the user from the database using their email.
    List<UserModel> userContact = await _userDB.getUserByEmail(email);
    if (userContact != null) {
      UserModel contact = userContact[0];
      contacts[contact.uid] = contact;
      var contactModel = ContactModel(
          nickname: userContact[0].displayName,
          uid: userContact[0].uid,
          accepted: false,
          sent: true);
      _userDB.createContact(contactModel);

      // send contact a notification that someone added them
      _userDB.sendInvite(contactModel);
      notifyListeners();
      return true;
    }
    // tell the user there was no one registered with that email address.
    return false;
  }

  Future<bool> uploadProfileImage(File file) async {
    var storage = locator<Storage>();
    // upload the user's profile image
    String imageUrl = await storage.uploadProfile(file);
    if (imageUrl == null) {
      return false;
    }
    // update user in state
    currentUser = UserModel(
      displayName: currentUser.displayName,
      uid: currentUser.uid,
      email: currentUser.email,
      profileImageUrl: imageUrl,
    );
    _userDB.updateUserData(currentUser);
    notifyListeners();
    return true;
  }

  void editUserDisplayName(String name) {
    currentUser = UserModel(
      displayName: name,
      email: currentUser.email,
      uid: currentUser.uid,
      profileImageUrl: currentUser.profileImageUrl,
    );
    // update the user data in the database
    _userDB.updateUserData(currentUser);
    // update user data in auth
    locator<AuthService>().updateUserProfile(name);
    notifyListeners();
  }

  void reset() {
    isContactsInitialized = false;
    // basic contact list is just a list of uid stored on the current logged in user
    isBasicContactsInitialized = false;
    currentUser = UserModel();
    contacts = {};
    _basicContacts = {};
    pendingContacts = [];
  }
}
