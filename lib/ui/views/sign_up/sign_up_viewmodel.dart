import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:password_vault/app/app.bottomsheets.dart';
import 'package:password_vault/app/app.dialogs.dart';
import 'package:password_vault/app/app.router.dart';
import 'package:password_vault/model/user.model.dart';
import 'package:password_vault/services/firebase/authentication_service.dart';
import 'package:password_vault/services/firebase/user_firestore_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';

class SignUpViewModel extends BaseViewModel {
  final logger = getLogger('SignUpViewModel');
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final _navigationService = locator<NavigationService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _authenticationService = locator<AuthenticationService>();
  final _userFirestoreService = locator<UserFirestoreService>();
  final _dialougeService = locator<DialogService>();

  final TextEditingController _nameTC = TextEditingController();
  TextEditingController get nameTC => _nameTC;

  final FocusNode _nameFN = FocusNode();
  FocusNode get nameFN => _nameFN;

  final TextEditingController _mobileNoTC = TextEditingController();
  TextEditingController get mobileNoTC => _mobileNoTC;

  final FocusNode _mobileNoFN = FocusNode();
  FocusNode get mobileNoFN => _mobileNoFN;

  final TextEditingController _emailIdTC = TextEditingController();
  TextEditingController get emailIdTC => _emailIdTC;

  final FocusNode _emailIdFN = FocusNode();
  FocusNode get emailIdFN => _emailIdFN;

  final TextEditingController _passwordTC = TextEditingController();
  TextEditingController get passwordTC => _passwordTC;

  final FocusNode _passwordFN = FocusNode();
  FocusNode get passwordFN => _passwordFN;

  final TextEditingController _confirmPasswordTC = TextEditingController();
  TextEditingController get confirmPasswordTC => _confirmPasswordTC;

  final FocusNode _confirmPasswordFN = FocusNode();
  FocusNode get confirmPasswordFN => _confirmPasswordFN;

  bool _isObscureText = true;
  bool get isObscureText => _isObscureText;

  bool _isObscureTextCP = true;
  bool get isObscureTextCP => _isObscureTextCP;

  changeObsecureValue() {
    _isObscureText = !_isObscureText;
    notifyListeners();
  }

  changeObsecureCPValue() {
    _isObscureTextCP = !_isObscureTextCP;
    notifyListeners();
  }

  goBack() {
    _navigationService.back();
  }

  doSignUp() async {
    try {
      _bottomSheetService.showCustomSheet(
          variant: BottomSheetType.loading,
          enableDrag: false,
          barrierDismissible: false,
          takesInput: false,
          description: "Please wait while we setup your account");
      UserCredential userCrendentail =
          await _authenticationService.signUpUserWithEmailPassword(
              _emailIdTC.text.toString(), _confirmPasswordTC.text.toString());
      if (null != userCrendentail.user) {
        UserModel userModel = UserModel(
          id: userCrendentail.user?.uid,
          isActive: true,
          mobileNo: _mobileNoTC.text.toString(),
          emailId: _emailIdTC.text.toString(),
          signUpDate: DateTime.now(),
          name: _nameTC.text.toString(),
          deleteDate: null,
        );
        await userCrendentail.user?.updateDisplayName(userModel.name);
        await _userFirestoreService.addUser(userModel);
      } else {
        throw Exception("Error while creating user!");
      }
      _navigationService.back();
      await _dialougeService.showCustomDialog(
          variant: DialogType.error,
          title: "Welcome",
          description:
              "Account creation completed. Please sign in to access vault");
      _navigationService.clearStackAndShow(Routes.loginView);
    } on FirebaseAuthException catch (e) {
      logger.e(e);
      _navigationService.back();
      await _dialougeService.showCustomDialog(
          variant: DialogType.error,
          title: "Sign up Error",
          description: e.message);
    } catch (ex) {
      logger.e(ex);
      _navigationService.back();
      await _dialougeService.showCustomDialog(
          variant: DialogType.error,
          title: "Sign up Error",
          description: ex.toString());
    }
  }
}
