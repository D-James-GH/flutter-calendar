import 'package:flutter/material.dart';
import 'package:flutter_calendar/services/services.dart';

class UserAvatar extends StatefulWidget {
  final String name;
  final double size;
  final bool isLight;
  final Function onTap;
  final String uid;
  final String imageUrl;
  // final String imageUrl;

  const UserAvatar({
    Key key,
    this.size = 18,
    this.name,
    this.isLight = false,
    this.onTap,
    this.uid,
    this.imageUrl,
  }) : super(key: key);

  @override
  _UserAvatarState createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  Future<String> _imageUrl;
  @override
  void initState() {
    super.initState();
    _imageUrl = locator<Storage>().getProfileImageUrl(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: widget.imageUrl == null
          ? FutureBuilder(
              future: _imageUrl,
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasData) {
                  return _buildAvatarWithImage(snapshot.data);
                } else {
                  return _buildAvatarNoImage();
                }
              },
            )
          : _buildFromUrl(widget.imageUrl),
      onTap: this.widget.onTap,
    );
  }

  Widget _buildFromUrl(String url) {
    if (url == '') {
      return _buildAvatarNoImage();
    } else {
      return _buildAvatarWithImage(url);
    }
  }

  Widget _buildAvatarWithImage(String url) {
    return CircleAvatar(
      backgroundImage: NetworkImage(url),
      radius: widget.size,
    );
  }

  Widget _buildAvatarNoImage() {
    return CircleAvatar(
      radius: widget.size,
      child: Text(
        widget.name[0],
        style: TextStyle(
            color:
                widget.isLight ? Theme.of(context).primaryColor : Colors.white),
      ),
      backgroundColor:
          widget.isLight ? Colors.white : Theme.of(context).primaryColor,
    );
  }
}
