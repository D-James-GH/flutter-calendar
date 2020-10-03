import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function setCurrentViewIndex;
  BottomNav({this.currentIndex = 0, this.setCurrentViewIndex});
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            FontAwesomeIcons.calendarAlt,
            size: 20,
          ),
          title: Text('Calendar'),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            FontAwesomeIcons.comments,
            size: 20,
          ),
          title: Text('Chats'),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            FontAwesomeIcons.user,
            size: 20,
          ),
          title: Text('Profile'),
        ),
      ],
      onTap: (int idx) {
        switch (idx) {
          case 0:
            if (currentIndex != 0) {
              setCurrentViewIndex(idx);
            }
            break;
          case 1:
            if (currentIndex != 1) {
              setCurrentViewIndex(idx);
            }
            break;
          case 2:
            if (currentIndex != 2) {
              setCurrentViewIndex(idx);
            }
            break;
        }
      },
    );
  }
}
