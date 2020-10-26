import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../../services/Auth.dart';

class Profile extends StatelessWidget {
  final AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    if (user != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(user.displayName),
            Text(user.email),
            Center(
              child: FlatButton(
                child: Text('Logout'),
                onPressed: () async {
                  await auth.signOut();
                  Navigator.of(context, rootNavigator: true)
                      .pushNamedAndRemoveUntil('/', (route) => false);
                },
              ),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Text('not logged in...'),
      );
    }
  }
}
