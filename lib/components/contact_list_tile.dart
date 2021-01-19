import 'package:flutter/material.dart';
import 'package:flutter_calendar/models/models.dart';

class ContactListTile extends StatelessWidget {
  final UserModel contact;
  final Function onTapFunc;
  const ContactListTile({Key key, this.contact, this.onTapFunc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(contact.displayName[0]),
        backgroundColor: Colors.teal,
      ),
      title: Text(contact.displayName),
      onTap: onTapFunc,
    );
  }
}
