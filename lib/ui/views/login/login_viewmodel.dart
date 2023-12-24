import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:password_vault/app/app.bottomsheets.dart';
import 'package:password_vault/app/app.dialogs.dart';
import 'package:password_vault/app/app.logger.dart';
import 'package:password_vault/app/app.router.dart';
import 'package:password_vault/app/app.shared_prefs.dart';
import 'package:password_vault/core/constants/share_prefs.constants.dart';
import 'package:password_vault/services/firebase/authentication_service.dart';
import 'package:password_vault/services/firebase/user_firestore_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';

class LoginViewModel extends BaseViewModel {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final logger = getLogger('LoginViewModel');

  final _navigationService = locator<NavigationService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _authenticationService = locator<AuthenticationService>();
  final _userFirestoreService = locator<UserFirestoreService>();
  final _dialougeService = locator<DialogService>();
  final _sharedPrefsService = locator<SharedPreferencesService>();

  final TextEditingController _emailIdTC = TextEditingController();
  TextEditingController get emailIdTC => _emailIdTC;

  final FocusNode _emailIdFN = FocusNode();
  FocusNode get emailIdFN => _emailIdFN;

  final TextEditingController _passwordTC = TextEditingController();
  TextEditingController get passwordTC => _passwordTC;
  final FocusNode _passwordFN = FocusNode();
  FocusNode get passwordFN => _passwordFN;

  bool _isObscureText = true;
  bool get isObscureText => _isObscureText;

  void changeObsecureValue() {
    _isObscureText = !_isObscureText;
    notifyListeners();
  }

  void gotoSignUpScreen() {
    _navigationService.navigateToSignUpView();
  }

  void loginUser() async {
    try {
      _bottomSheetService.showCustomSheet(
          variant: BottomSheetType.loading,
          enableDrag: false,
          barrierDismissible: false,
          takesInput: false,
          description: "Please wait while we setup your account");
      UserCredential userCrendentail = await _authenticationService
          .signInWithEmailPassword(_emailIdTC.text, _passwordTC.text);
      if (null != userCrendentail.user) {
        _userFirestoreService.setCurrentUser(userCrendentail.user!.uid);
      } else {
        throw Exception("Error while signing in user!");
      }
      _sharedPrefsService.write(kSpIsLoggedIn, true);
      _navigationService.back();
      _navigationService.clearStackAndShow(Routes.homeView);
    } on FirebaseAuthException catch (e) {
      logger.e(e);
      _navigationService.back();
      await _dialougeService.showCustomDialog(
          variant: DialogType.error,
          title: "Sign in Error",
          description: e.message);
    } catch (ex) {
      logger.e(ex);
      _authenticationService.signOutUser();
      _navigationService.back();
      await _dialougeService.showCustomDialog(
          variant: DialogType.error,
          title: "Sign in Error",
          description: ex.toString());
    }
  }
}
