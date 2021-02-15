import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar/components/user_avatar.dart';
import 'package:flutter_calendar/models/member_model.dart';
import 'package:provider/provider.dart';
import '../app_state/user_state.dart';

class ListMemberAvatars extends StatelessWidget {
  final List<MemberModel> members;
  final int maxNum;
  final bool showNames;
  final bool hasMargin;

  const ListMemberAvatars(
      {Key key,
      this.members,
      this.maxNum,
      this.hasMargin = false,
      this.showNames = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      // mainAxisAlignment: members.length <= 2
      //     ? MainAxisAlignment.center
      //     : MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: _buildMemberAvatars(context),
    );
  }

  List<Widget> _buildMemberAvatars(BuildContext context) {
    UserState userState = Provider.of<UserState>(context);
    List<Widget> memberAvatars = members.map((member) {
      if (member.uid != userState.currentUserModel.uid) {
        return Container(
          width: 36,
          margin: hasMargin
              ? EdgeInsets.symmetric(horizontal: 5)
              : EdgeInsets.all(0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserAvatar(userMember: member),
              showNames == true
                  ? Text(
                      member.displayName,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    )
                  : Container(),
            ],
          ),
        );
      }
      return Text('');
    }).toList();
    if (members == null) {
      return [Text('')];
    }
    return memberAvatars;
  }
}
