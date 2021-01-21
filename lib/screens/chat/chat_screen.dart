import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// custom lib
import '../../app_state/user_state.dart';
import 'chat_message.dart';
import '../../services/services.dart';
import '../../models/models.dart';

class Chat extends StatefulWidget {
  final String chatID;
  final List<MemberModel> members;
  Chat({this.chatID, this.members});
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> with TickerProviderStateMixin {
  MessageData messageData = locator<MessageData>();
  UserModel user;
  final _textController = TextEditingController();

  final FocusNode _focusNode = FocusNode();
  bool _isComposingMessage = false;

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserState>(context, listen: false).currentUserModel;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // * needs doing properly
        title: widget.members.length > 1
            ? Text(widget.members[0].displayName)
            : Text(user.displayName),
      ),
      body: Column(
        children: [
          _listMessages(),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildInput(),
          ),
        ],
      ),
    );
  }

  Widget _listMessages() {
    return StreamBuilder(
        stream: messageData.messageStream(widget.chatID),
        builder: (context, snapshot) {
          List<ChatMessage> _messages = [];
          if (snapshot.hasData) {
            List<MessageModel> _fromDB = snapshot.data;
            for (int i = 0; i < _fromDB.length; i++) {
              bool _isSentByUser = _fromDB[i].sentBy == user.uid;
              bool isFirstMessageFromUser;
              if (i + 1 < _fromDB.length) {
                if (_fromDB[i + 1].sentBy != user.uid) {
                  isFirstMessageFromUser = true;
                } else {
                  isFirstMessageFromUser = false;
                }
              } else {
                isFirstMessageFromUser = true;
              }
              _messages.add(ChatMessage(
                text: _fromDB[i].text,
                isSentByUser: _isSentByUser,
                isFirstMessageFromUser: isFirstMessageFromUser,
              ));
            }
          }

          return Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, int i) => _messages[i],
            ),
          );
        });
  }

  Widget _buildInput() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                maxLines: null,
                controller: _textController,
                onSubmitted: _isComposingMessage ? _handleSubmitted : null,
                onChanged: (String text) {
                  setState(() {
                    _isComposingMessage = text.length > 0;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Send a message',
                ),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: _isComposingMessage
                    ? () => _handleSubmitted(_textController.text)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    MessageModel message = MessageModel(
      text: text.trim(),
      sentBy: user.uid,
      sentTime: DateTime.now(),
      seen: false,
    );
    messageData.sendMessage(message, widget.chatID);
    setState(() {
      _isComposingMessage = false;
      // _messages.insert(0, message);
    });
    _focusNode.requestFocus();

    // message.animationController.forward();
  }

  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }
}
