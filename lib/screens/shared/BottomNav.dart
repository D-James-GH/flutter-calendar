import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// enum TabItem { calendar, chat, profile }

// Map<int, String> tab = {
//   TabItem.calendar: 'Calendar',
//   TabItem.chat: 'Chat',
//   TabItem.profile: 'Profile',
// };

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function setCurrentTabIndex;
  BottomNav({this.currentIndex = 0, this.setCurrentTabIndex});
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
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            FontAwesomeIcons.comments,
            size: 20,
          ),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            FontAwesomeIcons.user,
            size: 20,
          ),
          label: 'Profile',
        ),
      ],
      onTap: (int idx) {
        switch (idx) {
          case 0:
            if (currentIndex != 0) {
              setCurrentTabIndex(idx);
            }
            break;
          case 1:
            if (currentIndex != 1) {
              setCurrentTabIndex(idx);
            }
            break;
          case 2:
            if (currentIndex != 2) {
              setCurrentTabIndex(idx);
            }
            break;
        }
      },
    );
  }
}
