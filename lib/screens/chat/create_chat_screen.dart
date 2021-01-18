import 'package:flutter/material.dart';
import 'package:flutter_calendar/services/db.dart';
import 'package:flutter_calendar/services/service_locator.dart';

class CreateChatScreen extends StatefulWidget {
  @override
  _CreateChatScreenState createState() => _CreateChatScreenState();
}

class _CreateChatScreenState extends State<CreateChatScreen> {
  var emailController = TextEditingController();
  MessageData messageData = locator<MessageData>();
  List<String> _memberEmails = [];
  bool _emailNotFound = false;
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
            ],
          ),
        ),
      ),
    );
  }

  void _createChat() async {
    // temp until you can add multiple people to chat
    _memberEmails.add(emailController.text);

    /* result will come back false if the _memberEmails do not exist in the db */
    bool result = await messageData.createChat(_memberEmails);
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
