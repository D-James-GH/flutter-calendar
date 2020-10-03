import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens.dart';
import '../shared/BottomNav.dart';

GlobalKey<NavigatorState> _calendarNavKey = GlobalKey<NavigatorState>();

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  int _currentViewIndex = 0;
  void _setCurrentViewIndex(int index) {
    setState(() => _currentViewIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _calendarNavKey.currentState.maybePop();
        if (isFirstRouteInCurrentTab) {
          if (_currentViewIndex != 0) {
            setState(() => _currentViewIndex = 0);
            return false;
          }
        }
        return isFirstRouteInCurrentTab;
      },
      child: Provider(
        create: (context) => _calendarNavKey,
        child: Scaffold(
          body: IndexedStack(
            index: _currentViewIndex,
            children: [
              CalendarHome(),
              ChatHome(),
              Profile(),
            ],
          ),
          bottomNavigationBar: BottomNav(
            setCurrentViewIndex: _setCurrentViewIndex,
            currentIndex: _currentViewIndex,
          ),
        ),
      ),
    );
  }
}
