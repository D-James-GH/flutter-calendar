import 'package:flutter/material.dart';
import 'package:flutter_calendar/appState/calendar_state.dart';
import 'package:flutter_calendar/helpers/navService.dart';
import 'package:flutter_calendar/screens/profile/profileNavigator.dart';
import 'package:provider/provider.dart';
import '../screens/screens.dart';
import 'shared/BottomNav.dart';

// GlobalKey<NavigatorState> _calendarNavKey = GlobalKey<NavigatorState>();
class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  int _currentTabIndex = 0;

  Map<int, GlobalKey<NavigatorState>> _navigatorKeys = {
    0: NavService.calendarNavState,
    1: NavService.chatNavState,
    2: NavService.profileNavState,
  };

  void _setCurrentTab(int index) {
    setState(() {
      _currentTabIndex = index;
    });
  }

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
        body: ChangeNotifierProvider(
          create: (context) => CalendarStateFromProvider(),
          child: IndexedStack(
            index: _currentTabIndex,
            children: _buildTabs(),
          ),
        ),
        bottomNavigationBar: BottomNav(
          setCurrentTabIndex: _setCurrentTab,
          currentIndex: _currentTabIndex,
        ),
      ),
    );
  }

  List<Widget> _buildTabs() {
    return [
      CalendarNavigator(),
      ChatNavigator(),
      ProfileNavigator(),
    ];
  }
}
