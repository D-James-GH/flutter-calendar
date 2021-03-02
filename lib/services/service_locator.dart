import 'package:get_it/get_it.dart';
import '../app_state/user_state.dart';
import 'services.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<CalendarDB>(() => CalendarDB());
  locator.registerLazySingleton<ChatDB>(() => ChatDB());
  locator.registerLazySingleton<UserDB>(() => UserDB());
  locator.registerLazySingleton<Storage>(() => Storage());
  locator.registerLazySingleton<AuthService>(() => AuthService());
  locator.registerLazySingleton<UserState>(() => UserState());
}
