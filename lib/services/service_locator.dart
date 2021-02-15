import 'package:get_it/get_it.dart';
import 'calendar_db.dart';
import 'chat_db.dart';
import 'user_db.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<CalendarDB>(() => CalendarDB());
  locator.registerLazySingleton<ChatDB>(() => ChatDB());
  locator.registerLazySingleton<UserDB>(() => UserDB());
}
