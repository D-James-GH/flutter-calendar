import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// custom lib
import '../services/services.dart';
import '../app_state/user_state.dart';
import '../models/models.dart';
import '../components/contact_list_tile.dart';

class PickContactScreen extends StatefulWidget {
  final Function onTapContactFunction;

  PickContactScreen({Key key, this.onTapContactFunction}) : super(key: key);
  @override
  _PickContactScreenState createState() => _PickContactScreenState();
}

class _PickContactScreenState extends State<PickContactScreen> {
  MessageData messageData = locator<MessageData>();
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ..._buildAllContacts(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAllContacts() {
    return _contacts.map((contact) {
      return ContactListTile(
        contact: contact,
        onTapFunc: () {
          widget.onTapContactFunction(contact);
          Navigator.of(context).pop();
        },
      );
    }).toList();
  }
}
