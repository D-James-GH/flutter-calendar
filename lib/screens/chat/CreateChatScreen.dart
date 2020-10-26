import 'package:flutter/material.dart';
import 'package:flutter_calendar/services/db.dart';

class CreateChatScreen extends StatefulWidget {
  @override
  _CreateChatScreenState createState() => _CreateChatScreenState();
}

class _CreateChatScreenState extends State<CreateChatScreen> {
  var emailController = TextEditingController();
  List<String> _memberEmails = [];
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
            ],
          ),
        ),
      ),
    );
  }

  void _createChat() {
    // temp until you can add multiple people to chat
    _memberEmails.add(emailController.text);
    UserData userData = UserData();
    userData.createChat(_memberEmails);
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
