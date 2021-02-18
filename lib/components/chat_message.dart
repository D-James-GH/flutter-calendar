import 'package:flutter/material.dart';
import 'package:flutter_calendar/app_state/user_state.dart';
import 'package:flutter_calendar/models/models.dart';
import 'package:provider/provider.dart';

class ChatMessage extends StatelessWidget {
  // final String _name = 'Your Name';
  final String text;
  final AnimationController animationController;
  final bool isSentByUser;
  final bool isFirstMessageFromUser;
  ChatMessage(
      {this.text,
      this.animationController,
      this.isSentByUser,
      this.isFirstMessageFromUser});

  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserState>(context).currentUser;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isSentByUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isFirstMessageFromUser
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(user.displayName,
                          style: TextStyle(fontSize: 12, height: 0.9)),
                    )
                  : Container(
                      // Todo: check user id with the chats to see if any nick names have been created
                      child: null,
                    ),
              Container(
                constraints: BoxConstraints(
                    minWidth: 50,
                    maxWidth: MediaQuery.of(context).size.width * 0.7),
                margin: EdgeInsets.only(top: 5.0),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topLeft: isSentByUser ? Radius.circular(20) : Radius.zero,
                    topRight: isSentByUser ? Radius.zero : Radius.circular(20),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isSentByUser
                        ? [
                            Theme.of(context).primaryColor.withOpacity(0.8),
                            Theme.of(context).primaryColor,
                          ]
                        : [
                            Theme.of(context).accentColor.withOpacity(0.8),
                            Theme.of(context).accentColor,
                          ],
                  ),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                      fontSize: 17,
                      color: isSentByUser ? Colors.white : Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
