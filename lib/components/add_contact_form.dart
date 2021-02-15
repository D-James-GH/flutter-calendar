import 'package:flutter/material.dart';
import 'package:flutter_calendar/app_state/user_state.dart';
import 'package:provider/provider.dart';

// custom lib

class AddContactForm extends StatefulWidget {
  AddContactForm({Key key}) : super(key: key);

  @override
  _AddContactFormState createState() => _AddContactFormState();
}

class _AddContactFormState extends State<AddContactForm> {
  TextEditingController _emailController = TextEditingController();
  bool _contactNotFound = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  child: TextField(
                    onChanged: (value) => setState(() {
                      if (_emailController.text.isEmpty) {
                        _contactNotFound = false;
                      }
                    }),
                    controller: _emailController,
                    decoration: InputDecoration(hintText: "Add a Contact"),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => addContact(context),
                ),
              ),
            ],
          ),
        ),
        _contactNotFound == true
            ? Text(
                'Contact not found... Please check the email',
                style: TextStyle(color: Colors.red),
              )
            : Text(''),
      ],
    );
  }

  void addContact(BuildContext context) async {
    UserState userState = Provider.of<UserState>(context, listen: false);
    bool result = await userState.addContactFromEmail(_emailController.text);
    if (result == true) {
      _emailController.clear();
    } else {
      setState(() {
        _contactNotFound = true;
      });
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _emailController.dispose();
    super.dispose();
  }
}
