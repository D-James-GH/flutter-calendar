import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_calendar/components/contact_list_tile.dart';
import 'package:flutter_calendar/navigation/navigation_keys.dart';
import 'package:provider/provider.dart';

// custom lib
import '../services/services.dart';
import '../components/add_contact_form.dart';
import '../app_state/user_state.dart';
import '../models/models.dart';
import 'contact_screen.dart';

// screen arguments to pass to the named route contact_screen
class ContactsScreenArguments {
  final UserModel contact;
  ContactsScreenArguments(this.contact);
}

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
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            currentFocus.focusedChild.unfocus();
          }
        },
        behavior: HitTestBehavior.translucent,
        child: Column(
          children: [
            AddContactForm(),
            ..._buildAllContacts(contacts),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAllContacts(List<UserModel> contacts) {
    // Todo: clicking on the contact needs to go to the contact screen
    GlobalKey<NavigatorState> contactsNavState = NavigationKeys.contactNavState;
    return contacts.map((contact) {
      return ContactListTile(
        contact: contact,
        onTapFunc: () => contactsNavState.currentState.pushNamed(
          ContactScreen.routeName,
          arguments: ContactsScreenArguments(contact),
        ),
      );
    }).toList();
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
