import 'package:flutter/material.dart';
import 'package:flutter_calendar/app_state/user_state.dart';
import 'package:flutter_calendar/models/member_model.dart';
import 'package:provider/provider.dart';

class ChatTitle extends StatelessWidget {
  final List<MemberModel> members;

  const ChatTitle({Key key, this.members}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserState _userState = Provider.of<UserState>(context);
    List membersToDisplay = [];
    members.forEach((member) {
      if (members.length > 1 &&
          _userState.currentUser.displayName != member.nickname) {
        // if the chat is with other people then do not show the current user
        membersToDisplay.add(member.nickname);
      } else if (members.length == 1) {
        // show the current user if the chat is with them self
        membersToDisplay.add(member.nickname);
      }
    });
    return Row(
      children: membersToDisplay
          .map((displayName) => Container(
                margin: EdgeInsets.only(right: 5),
                child: Text(displayName),
              ))
          .toList(),
    );
  }
}
