import 'package:flutter/material.dart';

class SomethingWentWrong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calendar App')),
      body: Center(
        child: Text('Something went wrong with firebase'),
      ),
    );
  }
}
