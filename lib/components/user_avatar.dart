import 'package:flutter/material.dart';
import '../models/models.dart';

class UserAvatar extends StatelessWidget {
  final MemberModel userMember;
  final UserModel userModel;

  const UserAvatar({Key key, this.userMember, this.userModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // should have user image in but for now it will hold the first letter
    return CircleAvatar(
      radius: 18,
      child: Text(
        userMember != null
            ? userMember.displayName[0]
            : userModel.displayName[0],
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
