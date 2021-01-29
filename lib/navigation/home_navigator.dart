import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// custom lib

import 'chat_navigator.dart';
import 'calendar_navigator.dart';
import 'contacts_navigator.dart';
import 'navigation_keys.dart';

// GlobalKey<NavigatorState> _calendarNavKey = GlobalKey<NavigatorState>();
class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  int _currentTabIndex = 0;

  Map<int, GlobalKey<NavigatorState>> _navigatorKeys = {
    0: NavigationKeys.calendarNavState,
    1: NavigationKeys.chatNavState,
    2: NavigationKeys.profileNavState,
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_currentTabIndex].currentState.maybePop();
        if (isFirstRouteInCurrentTab) {
          if (_currentTabIndex != 0) {
            setState(() {
              _currentTabIndex = 0;
            });
            return false;
          }
        }
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentTabIndex,
          children: _buildTabs(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentTabIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          items: _buildBottomNav(),
          onTap: (index) => _setCurrentTab(index),
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _buildBottomNav() {
    return [
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
    ];
  }

  List<Widget> _buildTabs() {
    return [
      CalendarNavigator(),
      ChatNavigator(),
      ContactNavigator(),
    ];
  }

  void _setCurrentTab(int index) {
    if (_currentTabIndex != index) {
      setState(() {
        _currentTabIndex = index;
      });
    }
  }
}
