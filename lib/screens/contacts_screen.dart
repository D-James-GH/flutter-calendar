import 'package:flutter/material.dart';
import 'package:flutter_calendar/app_state/calendar_state.dart';
import 'package:flutter_calendar/app_state/chat_state.dart';
import 'package:flutter_calendar/components/contact_list_tile.dart';
import 'package:flutter_calendar/navigation/navigation_keys.dart';
import 'package:flutter_calendar/screens/profile_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

enum OptionsMenu { logout, profile }

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final AuthService auth = AuthService();
  UserState userState;
  UserModel currentUser;

  @override
  void initState() {
    super.initState();
    userState = Provider.of<UserState>(context, listen: false);
    currentUser = userState.currentUser;
    if (!userState.isContactsInitialized) {
      userState.fetchContactsFromDB();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          padding: EdgeInsets.all(10),
          child: GestureDetector(
            onTap: _gotoProfile,
            child: currentUser.profileImageUrl != '' &&
                    currentUser.profileImageUrl != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(currentUser.profileImageUrl),
                  )
                : CircleAvatar(
                    child: Text(
                      currentUser.displayName[0],
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).accentColor,
                  ),
          ),
        ),
        title: Text("${currentUser.displayName}'s Contacts"),
        actions: <Widget>[
          InkWell(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  FaIcon(FontAwesomeIcons.users),
                  if (userState.pendingContacts.length != 0)
                    Positioned(
                      right: 0,
                      top: 2,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: Text(
                          userState.pendingContacts.length.toString(),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              onTap: _showPendingContacts),
          PopupMenuButton<OptionsMenu>(
            onSelected: (option) => handlePopupMenu(option, context),
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<OptionsMenu>>[
              PopupMenuItem(
                value: OptionsMenu.logout,
                child: Text('Logout'),
              ),
              PopupMenuItem(
                value: OptionsMenu.profile,
                child: Text('My Profile'),
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
      case OptionsMenu.profile:
        _gotoProfile();
        break;
      default:
        return null;
    }
  }

  void _gotoProfile() {
    NavigationKeys.contactNavState.currentState.push(MaterialPageRoute(
      builder: (BuildContext context) => ProfileScreen(),
    ));
  }

  void logout(BuildContext context) async {
    // reset state
    Provider.of<CalendarState>(context, listen: false).reset();
    Provider.of<ChatState>(context, listen: false).reset();
    userState.reset();
    await auth.signOut();

    Navigator.of(context, rootNavigator: true)
        .pushNamedAndRemoveUntil('/', (route) => false);
  }

  void _showPendingContacts() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 200,
            child: userState.pendingContacts.length == 0
                ? Text('No pending contacts')
                : ListView.builder(
                    itemCount: userState.pendingContacts.length,
                    itemBuilder: (BuildContext context, i) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                            ),
                          ),
                        ),
                        height: 60,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                child: Center(
                                    child: Text(
                                  userState.pendingContacts[i].nickname,
                                  style: TextStyle(fontSize: 30),
                                )),
                              ),
                            ),
                            AcceptDeclineButton(
                              onTap: () => userState.confirmContact(
                                  userState.pendingContacts[i],
                                  confirm: true),
                              color: Colors.green,
                              icon: FaIcon(
                                FontAwesomeIcons.check,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                            AcceptDeclineButton(
                              onTap: () => userState.confirmContact(
                                  userState.pendingContacts[i],
                                  confirm: false),
                              color: Colors.red,
                              icon: FaIcon(
                                FontAwesomeIcons.times,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}

class AcceptDeclineButton extends StatelessWidget {
  final Color color;
  final Widget icon;
  final Function onTap;
  const AcceptDeclineButton({Key key, this.color, this.icon, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
        Navigator.of(context).pop();
      },
      child: Container(
        height: double.infinity,
        width: 60,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: color,
        ),
        child: Center(
          child: icon,
        ),
      ),
    );
  }
}
