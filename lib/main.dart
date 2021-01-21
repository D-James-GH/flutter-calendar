import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart';

// custom lib
import 'app_state/calendar_state.dart';
import 'app_state/user_state.dart';
import 'services/services.dart';
import 'screens/screens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(MyCalendarApp());
}
class MyCalendarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPaintSizeEnabled = false;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CalendarState>(
            create: (context) => CalendarState()),
        ChangeNotifierProvider<UserState>(create: (context) => UserState()),
        StreamProvider<User>.value(value: AuthService().user),
      ],
      child: MaterialApp(
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: FirebaseAnalytics())
        ],
        title: 'Calendar App',
        home: Login(),
      ),
    );
  }
}
