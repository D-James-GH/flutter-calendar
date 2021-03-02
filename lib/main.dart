import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart';

// custom lib
import 'app_state/calendar_state.dart';
import 'app_state/chat_state.dart';
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
        ChangeNotifierProvider<UserState>(
            create: (context) => locator<UserState>()),
        ChangeNotifierProvider<ChatState>(create: (context) => ChatState()),
      ],
      child: MaterialApp(
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: FirebaseAnalytics())
        ],
        title: 'Calendar App',
        home: Login(),
        // move to separate file when is gets big
        theme: ThemeData(
          primaryColor: const Color(0xff3AAAB7),
          accentColor: const Color(0xff984DB8),
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: const Color(0xff3AAAB7),
                displayColor: const Color(0xff3AAAB7),
              ),
        ),
      ),
    );
  }
}
