import 'package:firebase_auth/firebase_auth.dart';
import 'package:password_vault/app/app.dialogs.dart';
import 'package:password_vault/app/app.locator.dart';
import 'package:password_vault/app/app.router.dart';
import 'package:password_vault/app/app.shared_prefs.dart';
import 'package:password_vault/services/firebase/authentication_service.dart';
import 'package:password_vault/services/firebase/user_firestore_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.logger.dart';
import '../../../core/constants/share_prefs.constants.dart';

class StartupViewModel extends BaseViewModel {
  final logger = getLogger('StartupViewModel');

  final _navigationService = locator<NavigationService>();
  final _authenticationService = locator<AuthenticationService>();
  final _sharedPrefsService = locator<SharedPreferencesService>();
  final _userFirestoreService = locator<UserFirestoreService>();
  final _dialougeService = locator<DialogService>();

  Future runStartupLogic() async {
    try {
      bool isLoggedIn = await _sharedPrefsService.read(kSpIsLoggedIn) ?? false;
      if (isLoggedIn) {
        User? user = _authenticationService.getCurrentUser();
        await _userFirestoreService.setCurrentUser(user.uid);
      }
      await Future.delayed(const Duration(seconds: 3));
      _navigationService
          .clearStackAndShow(isLoggedIn ? Routes.homeView : Routes.loginView);
    } catch (e) {
      _authenticationService.signOutUser();
      _sharedPrefsService.clear();
      await _dialougeService.showCustomDialog(
          variant: DialogType.error,
          title: "Sign in Error",
          description: "Error while getting data. Please login!");
      _navigationService.clearStackAndShow(Routes.loginView);
    }
  }
}
