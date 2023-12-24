import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:password_vault/app/app.locator.dart';
import 'package:password_vault/app/app.shared_prefs.dart';
import 'package:password_vault/core/constants/share_prefs.constants.dart';
import 'package:password_vault/ui/common/app_colors.dart';

import '../ui/common/ui_helpers.dart';

final _sharedPrefsService = locator<SharedPreferencesService>();

ThemeData getLightTheme() {
  return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      primaryColor: kcPrimaryColor,
      primaryColorDark: kcPrimaryColorDark,
      primaryColorLight: kcPrimaryColorLight,
      canvasColor: kcWhite,
      cardTheme: const CardTheme(color: kcWhite, surfaceTintColor: kcWhite),
      cardColor: kcWhite,
      inputDecorationTheme: const InputDecorationTheme(
        focusColor: kcPrimaryColorDark,
      ),
      scaffoldBackgroundColor: kcWhite,
      primaryTextTheme: GoogleFonts.poppinsTextTheme(),
      textTheme: GoogleFonts.latoTextTheme(),
      chipTheme: const ChipThemeData(
        side: BorderSide(color: kcPrimaryColorDark),
        deleteIconColor: kcPrimaryColorDark,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(kRadius / 4))),
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kRadius / 5)),
        buttonColor: kcPrimaryColor,
      ),
      iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
              iconColor: MaterialStateProperty.all<Color>(kcPrimaryColorDark))),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            overlayColor: MaterialStateProperty.all<Color>(kcPrimaryColorDark),
            textStyle: MaterialStateProperty.all<TextStyle?>(
                GoogleFonts.promptTextTheme()
                    .labelLarge!
                    .copyWith(color: kcWhite)),
            shape: MaterialStateProperty.all<OutlinedBorder>(
                const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)))),
            iconColor: MaterialStateProperty.all<Color>(kcWhite),
            backgroundColor:
                MaterialStateProperty.all<Color>(kcPrimaryColorDark),
            foregroundColor: MaterialStateProperty.all<Color>(kcWhite)),
      ),
      appBarTheme: ThemeData.light().appBarTheme.copyWith(
            elevation: 0,
            iconTheme: const IconThemeData(color: kcBlack),
            backgroundColor: kcWhite,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            toolbarTextStyle: GoogleFonts.promptTextTheme().displayLarge,
            titleTextStyle: GoogleFonts.promptTextTheme().displayLarge,
          ),
      colorScheme: const ColorScheme.light().copyWith(background: kcWhite));
}

ThemeData getDarkTheme() {
  return ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
  );
}

setSystemTheme() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: _sharedPrefsService.read(kSpCurrentTheme) == 1
        ? Brightness.light
        : Brightness.dark,
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
}
