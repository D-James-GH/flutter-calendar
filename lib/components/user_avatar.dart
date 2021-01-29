import 'package:flutter/material.dart';
import '../models/member_model.dart';

class UserAvatar extends StatelessWidget {
  final MemberModel user;

  const UserAvatar({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // should have user image in but for now it will hold the first letter
    return CircleAvatar(
      radius: 18,
      child: Text(
        user.displayName[0],
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Theme.of(context).accentColor,
    );
  }
}
