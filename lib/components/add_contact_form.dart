import 'package:flutter/material.dart';

// custom lib
import '../../../services/services.dart';

class AddContactForm extends StatefulWidget {
  AddContactForm({Key key}) : super(key: key);

  @override
  _AddContactFormState createState() => _AddContactFormState();
}

class _AddContactFormState extends State<AddContactForm> {
  String _email;
  bool _contactNotFound = false;
  UserData userData = locator<UserData>();

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
                      if (value == '') {
                        _contactNotFound = false;
                      }
                      _email = value;
                    }),
                    decoration: InputDecoration(hintText: "Add a Contact"),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: addContact,
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

  void addContact() async {
    bool result = await userData.createContact(_email);
    if (result == true) {
      setState(() {
        _email = '';
      });
    } else {
      setState(() {
        _contactNotFound = true;
      });
    }
  }
}
