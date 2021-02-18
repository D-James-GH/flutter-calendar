import 'package:flutter/material.dart';
import '../models/models.dart';

class UserAvatar extends StatelessWidget {
  final MemberModel userMember;
  final UserModel userModel;
  final double size;
  final bool isLight;

  const UserAvatar(
      {Key key,
      this.size = 18,
      this.userMember,
      this.isLight = false,
      this.userModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // should have user image in but for now it will hold the first letter
    return CircleAvatar(
      radius: size,
      child: Text(
        userMember != null ? userMember.nickname[0] : userModel.displayName[0],
        style: TextStyle(
            color: isLight ? Theme.of(context).primaryColor : Colors.white),
      ),
      backgroundColor: isLight ? Colors.white : Theme.of(context).primaryColor,
    );
  }
}
