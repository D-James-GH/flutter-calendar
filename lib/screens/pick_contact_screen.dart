import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

// custom lib
import '../services/services.dart';
import '../app_state/user_state.dart';
import '../models/models.dart';
import '../components/contact_list_tile.dart';

class PickContactScreen extends StatefulWidget {
  final Function onTapContactFunction;
  final bool isPickGroupNameVisible;
  PickContactScreen(
      {Key key, this.onTapContactFunction, this.isPickGroupNameVisible = false})
      : super(key: key);
  @override
  _PickContactScreenState createState() => _PickContactScreenState();
}

class _PickContactScreenState extends State<PickContactScreen> {
  Map<String, UserModel> _selectedContacts = {};
  TextEditingController _groupNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Contact'),
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // display selected contacts and a submit button
              _buildSelectedContactsContainer(),
              // optional group naming
              widget.isPickGroupNameVisible
                  ? Container(
                      // padding: EdgeInsets.symmetric(horizontal: 60),
                      child: TextField(
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                        controller: _groupNameController,
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(5),
                          hintText: 'Group name (Optional)...',
                        ),
                      ),
                    )
                  : Container(),
              ..._buildAllContacts(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAllContacts() {
    Map<String, UserModel> contacts = Provider.of<UserState>(context).contacts;
    return contacts.values.map((contact) {
      return ContactListTile(
        contact: contact,
        onTapFunc: () {
          // on tapping a contact it should add them to the list of selected contacts.
          setState(() {
            if (_selectedContacts[contact.uid] == null) {
              _selectedContacts[contact.uid] = contact;
            }
          });
        },
      );
    }).toList();
  }

  Row _buildSelectedContactsContainer() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            margin: EdgeInsets.all(5),
            constraints: BoxConstraints(minHeight: 40),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(15),
            ),
            child: _selectedContacts.length != 0
                ? Wrap(
                    children: _selectedContacts.entries
                        .map(
                          (entry) => Container(
                            height: 30,
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  entry.value.displayName,
                                  style: TextStyle(color: Colors.white),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  child: GestureDetector(
                                      child: FaIcon(
                                        FontAwesomeIcons.times,
                                        size: 15,
                                        color: Colors.white,
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _selectedContacts.remove(entry.key);
                                        });
                                      }),
                                )
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  )
                : Text(
                    'Select a contact...',
                    style: TextStyle(color: Colors.black12),
                  ),
          ),
        ),
        GestureDetector(
          child: FaIcon(
            FontAwesomeIcons.checkSquare,
            size: 40,
            color: Theme.of(context).primaryColor,
          ),
          onTap: _onSubmit,
        ),
      ],
    );
  }

  void _onSubmit() {
    List<MemberModel> contactsList = _selectedContacts.entries
        .map((e) => MemberModel(
              uid: e.value.uid,
              nickname: e.value.displayName,
              role: Role.member,
            ))
        .toList();

    if (widget.isPickGroupNameVisible && _groupNameController.text != '') {
      widget.onTapContactFunction(contactsList, _groupNameController.text);
    } else {
      widget.onTapContactFunction(contactsList);
    }
    Navigator.of(context).pop();
  }
}
