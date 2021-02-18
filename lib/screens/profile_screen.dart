import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File _profileImage;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Screen'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Center(
          child: Column(children: [
            Center(
              child: _profileImage == null
                  ? Text('No image selected.')
                  : ClipOval(
                      child: Image.file(
                        _profileImage,
                        isAntiAlias: true,
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            RaisedButton(
              child: Text('Pick Profile Image'),
              onPressed: _pickImage,
            ),
            RaisedButton(
              child: Text('Crop Image'),
              onPressed: _cropImage,
            ),
          ]),
        ),
      ),
    );
  }

  Future _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _profileImage.path,
        cropStyle: CropStyle.circle,
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

  Future _pickImage() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery, maxHeight: 600, maxWidth: 600);

    setState(() {
      if (pickedFile != null) {
        _profileImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
}
