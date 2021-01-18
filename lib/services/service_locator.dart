import 'package:get_it/get_it.dart';
import 'db.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<CalendarData>(() => CalendarData());
  locator.registerLazySingleton<MessageData>(() => MessageData());
  locator.registerLazySingleton<UserData>(() => UserData());
}
