import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_calendar/app_state/user_state.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final picker = ImagePicker();
  File _profileImage;
  UserState userState;
  bool _hasSavedImg = false;
  bool _fullOptions = false;
  bool _isEditingDisplayName = false;

  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userState = Provider.of<UserState>(context, listen: false);
    _nameController.text = userState.currentUser.displayName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Screen'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              currentFocus.focusedChild.unfocus();
              setState(() {
                _isEditingDisplayName = false;
              });
              _nameController.text = userState.currentUser.displayName;
            }
          },
          behavior: HitTestBehavior.translucent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 38, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      child: ClipOval(
                        child: _buildProfileImage(),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(2, 2),
                              blurRadius: 6,
                            )
                          ],
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            center: Alignment(-0.1, -0.2),
                            radius: 0.8,
                            // begin: Alignment.topCenter,
                            // end: Alignment.bottomRight,
                            stops: [
                              0.4,
                              1,
                            ],
                            colors: [
                              Theme.of(context).primaryColor,
                              Theme.of(context).accentColor
                            ],
                          ),
                        ),
                        child: IconButton(
                          icon: FaIcon(
                            FontAwesomeIcons.camera,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () => _imageOptionsPopup(_fullOptions),
                        ),
                      ),
                    ),
                    if (_hasSavedImg == false && _profileImage != null)
                      Positioned(
                        left: 0,
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(2, 2),
                                blurRadius: 6,
                              )
                            ],
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              center: Alignment(-0.1, -0.2),
                              radius: 0.8,
                              // begin: Alignment.topCenter,
                              // end: Alignment.bottomRight,
                              stops: [0.4, 1],
                              colors: [
                                Theme.of(context).primaryColor,
                                Theme.of(context).accentColor
                              ],
                            ),
                          ),
                          child: IconButton(
                            icon: FaIcon(
                              FontAwesomeIcons.check,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () => _uploadProfileImage(),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 20),
                      child: FaIcon(
                        FontAwesomeIcons.userAlt,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Display Name'),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: _isEditingDisplayName
                                ? TextField(
                                    autofocus: true,
                                    style: TextStyle(fontSize: 18),
                                    controller: _nameController,
                                  )
                                : Text(
                                    userState.currentUser.displayName,
                                    style: TextStyle(fontSize: 20),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: FaIcon(
                          _isEditingDisplayName
                              ? FontAwesomeIcons.save
                              : FontAwesomeIcons.edit,
                          color: Theme.of(context).primaryColor),
                      onPressed: _isEditingDisplayName
                          ? _saveDisplayName
                          : () => setState(() {
                                _isEditingDisplayName = true;
                              }),
                    ),
                    if (_isEditingDisplayName)
                      IconButton(
                        icon: FaIcon(
                          FontAwesomeIcons.times,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () => setState(() {
                          _isEditingDisplayName = false;
                        }),
                      ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 20),
                      child: FaIcon(
                        FontAwesomeIcons.solidEnvelope,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email'),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Text(userState.currentUser.email,
                                style: TextStyle(fontSize: 20)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    if (_profileImage == null) {
      String url = userState.currentUser.profileImageUrl;
      if (url == null || url == '') {
        // if there is no picked image and the user has not uploaded any profile
        // image then show a colored circle

        return Container(
          width: 150,
          height: 150,
          color: Theme.of(context).primaryColor,
          child: Center(
            child: Text(
              userState.currentUser.displayName[0],
              style: TextStyle(color: Colors.white, fontSize: 40),
            ),
          ),
        );
      } else {
        // there is no picked image so display the images from firebase
        return Image.network(
          userState.currentUser.profileImageUrl,
          width: 150,
          height: 150,
          fit: BoxFit.cover,
        );
      }
    } else {
      // there is a picked image in state, show this
      return Image.file(
        _profileImage,
        width: 150,
        height: 150,
        fit: BoxFit.cover,
      );
    }
  }

  _saveDisplayName() {
    userState.editUserDisplayName(_nameController.text);
    setState(() {
      _isEditingDisplayName = false;
    });
  }

  _uploadProfileImage() async {
    UserState userState = Provider.of<UserState>(context, listen: false);

    bool result = await userState.uploadProfileImage(_profileImage);
    if (result == true) {
      setState(() {
        _hasSavedImg = true;
      });
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Profile picture uploaded')));
    }
    // if false the upload failed
    if (result == false)
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading, please try again')));
  }

  Future _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _profileImage.path,
        cropStyle: CropStyle.circle,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    setState(() {
      _profileImage = croppedFile ?? _profileImage;
    });
  }

  Future<void> _pickImage({ImageSource source}) async {
    final pickedFile =
        await picker.getImage(source: source, maxHeight: 600, maxWidth: 600);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
        _fullOptions = true;
        _hasSavedImg = false;
      });
      Navigator.of(context).pop();
      _imageOptionsPopup(_fullOptions);
      print('done');
    } else {
      print('No image selected.');
    }
  }

  void _imageOptionsPopup(bool fullOptions) {
    showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: fullOptions ? 240 : 140,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Center(
            child: Column(
              children: [
                OptionsRow(
                  icon: FontAwesomeIcons.cameraRetro,
                  label: 'Take new profile picture',
                  onTap: () => _pickImage(
                    source: ImageSource.camera,
                  ),
                ),
                Divider(
                  indent: 40,
                  endIndent: 40,
                ),
                OptionsRow(
                  icon: FontAwesomeIcons.image,
                  label: 'Pick picture from gallery',
                  onTap: () => _pickImage(
                    source: ImageSource.gallery,
                  ),
                ),
                if (fullOptions)
                  Divider(
                    indent: 40,
                    endIndent: 40,
                  ),
                if (fullOptions)
                  OptionsRow(
                    icon: FontAwesomeIcons.crop,
                    label: 'Crop and position image',
                    onTap: _cropImage,
                  ),
                if (fullOptions)
                  Divider(
                    indent: 40,
                    endIndent: 40,
                  ),
                if (fullOptions)
                  OptionsRow(
                    icon: FontAwesomeIcons.save,
                    label: 'Save picture',
                    onTap: () {
                      _uploadProfileImage();
                      Navigator.pop(context);
                    },
                    emphasise: true,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class OptionsRow extends StatelessWidget {
  final IconData icon;
  final dynamic onTap;
  final String label;
  final bool emphasise;
  OptionsRow(
      {@required this.icon,
      this.onTap,
      @required this.label,
      this.emphasise = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Container(
                child: FaIcon(icon),
              ),
            ),
          ),
          // SizedBox(width: 20),
          Expanded(
            flex: 4,
            child: Container(
                // padding: EdgeInsets.only(left: emphasise ? 50 : 0),
                child: Text(
              label,
              style: TextStyle(
                  fontSize: 20,
                  color: emphasise
                      ? Theme.of(context).primaryColor
                      : Colors.black54,
                  fontWeight: emphasise ? FontWeight.bold : FontWeight.normal),
            )),
          ),
        ],
      ),
    );
  }
}
