import 'package:flutter/material.dart';
import 'package:flutter_calendar/components/labeled_row.dart';
import 'package:flutter_calendar/components/user_avatar.dart';
import 'package:flutter_calendar/models/models.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactScreen extends StatefulWidget {
  static const routeName = '/contactScreen';
  final UserModel contact;

  // Todo: make the notification switch useful

  const ContactScreen({Key key, this.contact}) : super(key: key);

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  bool _notificationOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact name'),
      ),
      body: Column(
        children: [
          UserAvatar(
            userModel: widget.contact,
          ),
          Text(widget.contact.displayName),
          Divider(color: Theme.of(context).primaryColor.withOpacity(0.5)),
          LabeledRow(
            label: 'Email:',
            body: Text(widget.contact.email),
          ),
          LabeledRow(
            label: 'Display Name:',
            body: Row(
              children: [
                Text(widget.contact.displayName),
                IconButton(icon: Icon(FontAwesomeIcons.pen), onPressed: null)
              ],
            ),
          ),
          LabeledRow(
            label: 'Notifications:',
            body: Row(
              children: [
                Switch(
                  value: _notificationOn,
                  onChanged: (val) => setState(() {
                    _notificationOn = val;
                  }),
                  activeColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, -2),
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 6,
                    spreadRadius: 2,
                  )
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Events with ${widget.contact.displayName}',
                    style: TextStyle(color: Colors.white),
                  ),
                  Divider(
                    indent: 40,
                    endIndent: 40,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
