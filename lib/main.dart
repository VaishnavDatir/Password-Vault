import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:password_vault/app/app.bottomsheets.dart';
import 'package:password_vault/app/app.dialogs.dart';
import 'package:password_vault/app/app.locator.dart';
import 'package:password_vault/app/app.router.dart';
import 'package:password_vault/app/app.theam_setup.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeManager.initialise();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setupLocator();
  setupDialogUi();
  setupBottomSheetUi();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
        defaultThemeMode: ThemeMode.light,
        lightTheme: getLightTheme(),
        darkTheme: getDarkTheme(),
        builder: (context, regularTheme, darkTheme, themeMode) => MaterialApp(
              theme: regularTheme,
              darkTheme: darkTheme,
              themeMode: themeMode,
              initialRoute: Routes.startupView,
              onGenerateRoute: StackedRouter().onGenerateRoute,
              navigatorKey: StackedService.navigatorKey,
              navigatorObservers: [
                StackedService.routeObserver,
              ],
            ));
  }
}
