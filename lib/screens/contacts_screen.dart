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

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final AuthService auth = AuthService();
  UserState userState;
  Map<String, UserModel> _contacts;
  UserModel currentUser;

  @override
  void initState() {
    super.initState();
    userState = Provider.of<UserState>(context, listen: false);
    currentUser = userState.currentUser;
    userState.fetchContactsFromDB();
  }

  @override
  Widget build(BuildContext context) {
    _contacts = Provider.of<UserState>(context).contacts;
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          padding: EdgeInsets.all(10),
          child: CircleAvatar(
            child: Text('D'),
            backgroundColor: Colors.pink,
          ),
        ),
        title: Text("${currentUser.displayName}'s Contacts"),
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
        child: Consumer<UserState>(
          builder: (BuildContext context, state, child) {
            return Column(
              children: [
                child,
                ...state.contacts.values.map((contact) {
                  return ContactListTile(
                    contact: contact,
                    onTapFunc: () => _gotoContactPage(contact),

                    //     () => contactsNavState.currentState.pushNamed(
                    // ContactScreen.routeName,
                    // arguments: ContactsScreenArguments(contact),
                  );
                }).toList(),
              ],
            );
          },
          child: AddContactForm(),
        ),
      ),
    );
  }

  void _gotoContactPage(contact) {
    GlobalKey<NavigatorState> contactsNavState = NavigationKeys.contactNavState;
    contactsNavState.currentState.push(
      MaterialPageRoute(
        builder: (context) => ContactScreen(
          contact: contact,
        ),
      ),
    );
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
