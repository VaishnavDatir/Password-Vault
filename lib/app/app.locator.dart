// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, implementation_imports, depend_on_referenced_packages

import 'package:stacked_services/src/bottom_sheet/bottom_sheet_service.dart';
import 'package:stacked_services/src/dialog/dialog_service.dart';
import 'package:stacked_services/src/navigation/navigation_service.dart';
import 'package:stacked_shared/stacked_shared.dart';
import 'package:stacked_themes/src/theme_service.dart';

import '../core/util/string_handler.dart';
import '../services/firebase/authentication_service.dart';
import '../services/firebase/password_firestore_service.dart';
import '../services/firebase/remote_config_service.dart';
import '../services/firebase/user_firestore_service.dart';
import 'app.shared_prefs.dart';

final locator = StackedLocator.instance;

Future<void> setupLocator({
  String? environment,
  EnvironmentFilter? environmentFilter,
}) async {
// Register environments
  locator.registerEnvironment(
      environment: environment, environmentFilter: environmentFilter);

// Register dependencies
  locator.registerSingleton(ThemeService.getInstance());
  final sharedPreferencesService = SharedPreferencesService();
  await sharedPreferencesService.init();
  locator.registerSingleton(sharedPreferencesService);

  locator.registerLazySingleton(() => BottomSheetService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => NavigationService());
  final remoteConfigService = RemoteConfigService();
  await remoteConfigService.init();
  locator.registerSingleton(remoteConfigService);

  final stringHandler = StringHandler();
  await stringHandler.init();
  locator.registerSingleton(stringHandler);

  final userFirestoreService = UserFirestoreService();
  await userFirestoreService.init();
  locator.registerSingleton(userFirestoreService);

  final authenticationService = AuthenticationService();
  await authenticationService.init();
  locator.registerSingleton(authenticationService);

  final passwordFirestoreService = PasswordFirestoreService();
  await passwordFirestoreService.init();
  locator.registerSingleton(passwordFirestoreService);
}
