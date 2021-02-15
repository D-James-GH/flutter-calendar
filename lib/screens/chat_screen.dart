import 'package:flutter/material.dart';
import 'package:flutter_calendar/components/chat_title.dart';
import 'package:flutter_calendar/navigation/navigation_keys.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

// custom lib
import '../app_state/user_state.dart';
import '../components/chat_message.dart';
import '../services/services.dart';
import '../models/models.dart';

enum ChatOptions { deleteChat, changeGroupName }

class ChatScreen extends StatefulWidget {
  final ChatModel chat;

  ChatScreen({this.chat});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  ChatDB _chatDB = locator<ChatDB>();
  UserModel user;
  final _messageController = TextEditingController();
  TextEditingController _groupNameController = TextEditingController();
  String _groupName;
  final FocusNode _focusNode = FocusNode();
  bool _isComposingMessage = false;
  bool _isChangingGroupName = false;

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserState>(context, listen: false).currentUserModel;
    _groupNameController.text = widget.chat.groupName;
    _groupName = widget.chat.groupName;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // * needs doing properly
        title: _buildPageTitle(),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (option) => handlePopupMenu(option, context),
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<ChatOptions>>[
              PopupMenuItem(
                value: ChatOptions.deleteChat,
                child: Text('Delete Chat'),
              ),
              PopupMenuItem(
                value: ChatOptions.changeGroupName,
                child: Text('Change group name'),
              ),
            ],
          )
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            currentFocus.focusedChild.unfocus();
            setState(() {
              _isChangingGroupName = false;
            });
            _groupNameController.text = widget.chat.groupName;
          }
        },
        behavior: HitTestBehavior.translucent,
        child: Column(
          children: [
            _listMessages(),
            Divider(height: 1.0),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildInput(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageTitle() {
    if (_isChangingGroupName) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
              style: TextStyle(color: Colors.white, fontSize: 20),
              controller: _groupNameController,
            ),
          ),
          GestureDetector(
            onTap: _changeGroupName,
            child: FaIcon(FontAwesomeIcons.checkCircle),
          ),
        ],
      );
    } else if (_groupName == '' || _groupName == null) {
      return ChatTitle(members: widget.chat.memberRoles);
    } else {
      return Text(_groupName);
    }
  }

  void _changeGroupName() {
    setState(() {
      _groupName = _groupNameController.text;
      _isChangingGroupName = false;
    });
    _chatDB.updateGroupName(
      groupName: _groupNameController.text,
      chatID: widget.chat.chatID,
    );
  }

  Widget _listMessages() {
    return StreamBuilder(
      stream: _chatDB.messageStream(widget.chat.chatID),
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
            _messages.add(
              ChatMessage(
                text: _fromDB[i].text,
                isSentByUser: _isSentByUser,
                isFirstMessageFromUser: isFirstMessageFromUser,
              ),
            );
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
      },
    );
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
                controller: _messageController,
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
                    ? () => _handleSubmitted(_messageController.text)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handlePopupMenu(ChatOptions option, BuildContext context) {
    switch (option) {
      case ChatOptions.deleteChat:
        _chatDB.removeUserFromChat(widget.chat);
        Navigator.of(context, rootNavigator: true).pop();
        break;
      case ChatOptions.changeGroupName:
        setState(() {
          _isChangingGroupName = true;
        });
        break;
      default:
        return null;
    }
  }

  void _handleSubmitted(String text) {
    _messageController.clear();
    MessageModel message = MessageModel(
      text: text.trim(),
      sentBy: user.uid,
      sentTime: DateTime.now(),
      seen: false,
    );
    _chatDB.sendMessage(message, widget.chat.chatID);
    setState(() {
      _isComposingMessage = false;
      // _messages.insert(0, message);
    });
    _focusNode.requestFocus();

    // message.animationController.forward();
  }

  void dispose() {
    _focusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }
}
