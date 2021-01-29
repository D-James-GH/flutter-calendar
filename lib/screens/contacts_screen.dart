import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

// custom lib
import '../services/services.dart';
import '../components/add_contact_form.dart';
import '../app_state/user_state.dart';
import '../models/models.dart';

enum OptionsMenu { logout }

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  final AuthService auth = AuthService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    UserState userState = Provider.of<UserState>(context);
    List<UserModel> contacts = userState.contacts;
    if (user != null) {
      return Scaffold(
        appBar: AppBar(
          leading: Container(
            padding: EdgeInsets.all(10),
            child: CircleAvatar(
              child: Text('D'),
              backgroundColor: Colors.pink,
            ),
          ),
          title: Text("${user.displayName}'s Contacts"),
          actions: <Widget>[
            PopupMenuButton<OptionsMenu>(
              onSelected: (option) => handlePopupMenu(option, context),
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<OptionsMenu>>[
                PopupMenuItem(
                  value: OptionsMenu.logout,
                  child: Text('Logout'),
                ),
              ],
            )
          ],
        ),
        body: Column(
          children: [
            AddContactForm(),
            ..._buildAllContacts(contacts),
          ],
        ),
      );
    } else {
      return Center(
        child: Text('not logged in...'),
      );
    }
  }

  List<Widget> _buildAllContacts(List<UserModel> contacts) {
    return contacts
        .map((contact) => Text('Contact: ${contact.displayName}'))
        .toList();
  }

  void handlePopupMenu(OptionsMenu option, BuildContext context) {
    switch (option) {
      case OptionsMenu.logout:
        logout(context);
        break;
      default:
        return null;
    }
  }

  void logout(BuildContext context) async {
    await auth.signOut();
    Navigator.of(context, rootNavigator: true)
        .pushNamedAndRemoveUntil('/', (route) => false);
  }
}
