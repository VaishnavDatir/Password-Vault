import 'package:password_vault/app/app.locator.dart';
import 'package:password_vault/app/app.logger.dart';
import 'package:password_vault/app/app.router.dart';
import 'package:password_vault/app/app.shared_prefs.dart';
import 'package:password_vault/core/constants/share_prefs.constants.dart';
import 'package:password_vault/services/firebase/authentication_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AccountScreenViewModel extends BaseViewModel {
  final logger = getLogger('AccountScreenViewModel');
  final _authenticationService = locator<AuthenticationService>();
  final _sharedPrefService = locator<SharedPreferencesService>();
  final _navigationService = locator<NavigationService>();

  void signOutUser() async {
    _authenticationService.signOutUser();
    await _sharedPrefService.write(kSpIsLoggedIn, false);
    _navigationService.clearStackAndShow(Routes.loginView);
  }
}
