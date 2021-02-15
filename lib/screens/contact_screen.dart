import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_calendar/app_state/calendar_state.dart';
import 'package:flutter_calendar/components/event_tile.dart';
import 'package:flutter_calendar/components/labeled_row.dart';
import 'package:flutter_calendar/components/user_avatar.dart';
import 'package:flutter_calendar/models/models.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

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
  List<EventModel> _events = [];
  @override
  void initState() {
    super.initState();
    CalendarState calendarState =
        Provider.of<CalendarState>(context, listen: false);
    calendarState
        .fetchEventsWithContact(widget.contact.uid)
        .then((List<EventModel> value) {
      setState(() {
        _events = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact.displayName),
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
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Events with ${widget.contact.displayName}',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                    _events.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              itemCount: _events.length,
                              itemBuilder: (BuildContext context, int i) {
                                return _events[i] != null
                                    ? EventTile(
                                        event: _events[i],
                                        isLight: true,
                                        gotoEvent: null,
                                      )
                                    : Container();
                              },
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
