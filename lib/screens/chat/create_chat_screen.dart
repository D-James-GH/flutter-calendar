import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// custom lib
import '../../services/services.dart';
import '../../app_state/user_state.dart';
import '../../models/models.dart';

class CreateChatScreen extends StatefulWidget {
  @override
  _CreateChatScreenState createState() => _CreateChatScreenState();
}

class _CreateChatScreenState extends State<CreateChatScreen> {
  var emailController = TextEditingController();
  MessageData messageData = locator<MessageData>();
  List<String> _memberEmails = [];
  bool _emailNotFound = false;

  UserState _userState;
  List<UserModel> _contacts;

  @override
  void initState() {
    super.initState();
    _userState = Provider.of<UserState>(context, listen: false);
    _contacts = _userState.contacts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Contact'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: 'Enter Email',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  RaisedButton(
                    color: Colors.green,
                    onPressed: _createChat,
                    child: Text('Invite'),
                  ),
                ],
              ),
              _emailNotFound
                  ? Text(
                      'Email not found in our database, please check the spelling...')
                  : Text(''),
              ..._buildAllContacts(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAllContacts() {
    return _contacts.map((contact) {
      return InkWell(
        child: Text('Contact: ${contact.displayName}'),
        onTap: () => _createChat([contact]),
      );
    }).toList();
  }

  void _createChat([List<UserModel> contacts]) async {
    // temp until you can add multiple people to chat
    bool result;
    if (contacts != null) {
      result = await messageData.createChat(contacts: contacts);
    } else {
      _memberEmails.add(emailController.text);
      result = await messageData.createChat(userEmails: _memberEmails);
    }

    /* result will come back false if the _memberEmails do not exist in the db */

    if (result == true) {
      Navigator.of(context, rootNavigator: true).pop();
    } else {
      setState(() {
        _emailNotFound = true;
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
