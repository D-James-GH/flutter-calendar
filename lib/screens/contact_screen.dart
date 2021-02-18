import 'package:flutter/material.dart';
import 'package:flutter_calendar/app_state/calendar_state.dart';
import 'package:flutter_calendar/app_state/user_state.dart';
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
  bool _editDisplayName = false;

  TextEditingController _displayNameController = TextEditingController();
  List<EventModel> _events = [];
  @override
  void initState() {
    super.initState();
    CalendarState calendarState =
        Provider.of<CalendarState>(context, listen: false);
    UserState userState = Provider.of<UserState>(context, listen: false);
    calendarState
        .fetchEventsWithContact(widget.contact.uid)
        .then((List<EventModel> value) {
      setState(() {
        _events = value;
      });
    });
    _displayNameController.text =
        userState.customContactData[widget.contact.uid].nickname;
  }

  @override
  Widget build(BuildContext context) {
    UserState userState = Provider.of<UserState>(context);
    String nickname = userState.customContactData[widget.contact.uid].nickname;
    return Scaffold(
      appBar: AppBar(
        title: Text(nickname),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height -
                Scaffold.of(context).appBarMaxHeight -
                MediaQuery.of(context).padding.bottom,
            child: Column(
              children: [
                // upper part of the contact screen
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Column(
                      children: [
                        UserAvatar(
                          userModel: userState
                              .contacts[widget.contact.uid], //widget.contact,
                          size: 34,
                        ),
                        SizedBox(height: 10),
                        Text(nickname),
                        Divider(
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(0.5)),
                        LabeledRow(
                            label: 'Email:',
                            body: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(widget.contact.email),
                            )),
                        LabeledRow(
                          label: 'Display Name:',
                          body: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _editDisplayName
                                        ? Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: TextField(
                                                autofocus: true,
                                                controller:
                                                    _displayNameController,
                                                decoration: InputDecoration(
                                                    isCollapsed: true),
                                              ),
                                            ),
                                          )
                                        : Expanded(child: Text(nickname)),
                                    Container(
                                      width: 40,
                                      child: _editDisplayName
                                          ? GestureDetector(
                                              child: FaIcon(
                                                  FontAwesomeIcons.times,
                                                  size: 18,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              onTap: () => setState(() {
                                                _editDisplayName = false;
                                              }),
                                            )
                                          : null,
                                    ),
                                    _editDisplayName
                                        ? GestureDetector(
                                            child: FaIcon(FontAwesomeIcons.save,
                                                size: 18,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                            onTap: _saveNickname,
                                          )
                                        : GestureDetector(
                                            child: FaIcon(FontAwesomeIcons.pen,
                                                size: 18,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                            onTap: () => setState(() {
                                              _editDisplayName = true;
                                            }),
                                          ),
                                    SizedBox(width: 40),
                                  ],
                                ),
                                _editDisplayName
                                    ? Text(
                                        'This will only change the Display Name on your device.',
                                        style: TextStyle(
                                            color: Colors.red[300],
                                            fontSize: 12))
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                        LabeledRow(
                          // TODO: do something with this switch
                          label: 'Notifications:',
                          body: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(0),
                                height: 25,
                                child: Switch(
                                  value: _notificationOn,
                                  onChanged: (val) => setState(() {
                                    _notificationOn = val;
                                  }),
                                  activeColor: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Lower events list of the contact page
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 10),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Events with $nickname',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                          Divider(color: Colors.white, thickness: 2),
                          _events.isNotEmpty
                              ? Expanded(
                                  child: ListView.builder(
                                    itemCount: _events.length,
                                    itemBuilder: (BuildContext context, int i) {
                                      return _events[i] != null
                                          ? EventTile(
                                              event: _events[i],
                                              showDate: true,
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
          ),
        );
      }),
    );
  }

  void _saveNickname() {
    UserState userState = Provider.of<UserState>(context, listen: false);
    userState.changeNickname(
        nickname: _displayNameController.text, contact: widget.contact);
    setState(() {
      _editDisplayName = false;
    });
  }
}
