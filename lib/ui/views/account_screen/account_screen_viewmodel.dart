import 'package:firebase_auth/firebase_auth.dart';
import 'package:password_vault/app/app.bottomsheets.dart';
import 'package:password_vault/app/app.dialogs.dart';
import 'package:password_vault/app/app.locator.dart';
import 'package:password_vault/app/app.logger.dart';
import 'package:password_vault/app/app.router.dart';
import 'package:password_vault/app/app.shared_prefs.dart';
import 'package:password_vault/core/constants/share_prefs.constants.dart';
import 'package:password_vault/model/user.model.dart';
import 'package:password_vault/services/firebase/authentication_service.dart';
import 'package:password_vault/services/firebase/password_firestore_service.dart';
import 'package:password_vault/services/firebase/user_firestore_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AccountScreenViewModel extends BaseViewModel {
  final logger = getLogger('AccountScreenViewModel');
  final _authenticationService = locator<AuthenticationService>();
  final _userFirestoreService = locator<UserFirestoreService>();
  final _passwordFirestoreService = locator<PasswordFirestoreService>();
  final _sharedPrefService = locator<SharedPreferencesService>();
  final _navigationService = locator<NavigationService>();
  final _dialougeService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();

  AccountScreenViewModel() {
    initializeScreen();
  }

  late UserModel _userModel;
  UserModel get userModel => _userModel;
  initializeScreen() async {
    _userModel = _userFirestoreService.currentUser!;
  }

  void signOutUser() async {
    _authenticationService.signOutUser();
    await _sharedPrefService.write(kSpIsLoggedIn, false);
    _navigationService.clearStackAndShow(Routes.loginView);
  }

  void handleDeleteAccount() async {
    try {
      DialogResponse<dynamic>? dialogResponse =
          await _dialougeService.showCustomDialog(
        variant: DialogType.inputStringDialog,
        barrierDismissible: true,
        takesInput: true,
        mainButtonTitle: "Delete",
        title: "Delete account?",
        description:
            "Are you sure you want to delete this account? Deleting account will result in:\n- Delete all your saved passwords.\n- Shared passwords won't be visible to the other users.\n- The action is not revertable.\n- Once delete all your data will be gone forever.",
      );
      if (dialogResponse != null && dialogResponse.confirmed) {
        logger.i("Deleting user account!");
        _bottomSheetService.showCustomSheet(
            variant: BottomSheetType.loading,
            enableDrag: false,
            barrierDismissible: false,
            takesInput: false,
            description: "Deleting account data");
        bool accountDeleted = false;
        if (await _passwordFirestoreService.deleteUsersAllPassword()) {
          if (await _userFirestoreService.deleteUserDetails()) {
            accountDeleted = await _authenticationService.deleteUserAccount();
            _sharedPrefService.clear();
          }
        }
        _navigationService.back();
        if (accountDeleted) {
          await _dialougeService.showCustomDialog(
            variant: DialogType.infoAlert,
            title: "Accound deleted.",
            description: "Your account has been deleted successfully.",
          );
          _navigationService.clearStackAndShow(Routes.loginView);
        } else {
          await _dialougeService.showCustomDialog(
              variant: DialogType.error,
              title: "Error",
              description: "Account could not be deleted. Try again later.");
        }
      }
    } on FirebaseAuthException catch (e) {
      logger.e(e);
      _navigationService.back();
      await _dialougeService.showCustomDialog(
        variant: DialogType.error,
        title: " Error",
        description: e.message,
      );
    } catch (ex) {
      logger.e(ex);
      _navigationService.back();
      await _dialougeService.showCustomDialog(
        variant: DialogType.error,
        title: "Error",
        description: ex.toString(),
      );
    }
  }
}
