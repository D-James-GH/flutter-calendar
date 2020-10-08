import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String _name = 'Your Name';
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
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isSentByUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // Container(
          //   margin: const EdgeInsets.only(right: 16.0),
          //   child: CircleAvatar(
          //     child: Text(_name[0]),
          //   ),
          // ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isFirstMessageFromUser
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(_name,
                          style: TextStyle(fontSize: 12, height: 0.9)),
                    )
                  : Container(
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
                      colors: [
                        Colors.cyan,
                        Colors.blue,
                      ]),
                ),
                child: Text(
                  text,
                  style: TextStyle(fontSize: 17, color: Colors.white),
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
// Widget build(BuildContext context) {
//     return SizeTransition(
//       sizeFactor:
//           CurvedAnimation(parent: animationController, curve: Curves.easeOut),
//       axisAlignment: 0,
//       child: Container(
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               margin: const EdgeInsets.only(right: 16.0),
//               child: CircleAvatar(
//                 child: Text(_name[0]),
//               ),
//             ),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(_name, style: TextStyle(fontSize: 12, height: 0.9)),
//                   Container(
//                     margin: EdgeInsets.only(top: 5.0),
//                     child: Text(text, style: TextStyle(fontSize: 17)),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
