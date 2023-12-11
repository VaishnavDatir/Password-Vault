import 'package:password_vault/app/app.shared_prefs.dart';
import 'package:password_vault/services/firebase/authentication_service.dart';
import 'package:password_vault/services/firebase/password_firestore_service.dart';
import 'package:password_vault/services/firebase/remote_config_service.dart';
import 'package:password_vault/services/firebase/user_firestore_service.dart';
import 'package:password_vault/ui/bottom_sheets/loading/loading_sheet.dart';
import 'package:password_vault/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:password_vault/ui/dialogs/error/error_dialog.dart';
import 'package:password_vault/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:password_vault/ui/views/account_screen/account_screen_view.dart';
import 'package:password_vault/ui/views/add_password/add_password_view.dart';
import 'package:password_vault/ui/views/home/home_view.dart';
import 'package:password_vault/ui/views/login/login_view.dart';
import 'package:password_vault/ui/views/main_screen/main_screen_view.dart';
import 'package:password_vault/ui/views/password_detail/password_detail_view.dart';
import 'package:password_vault/ui/views/sign_up/sign_up_view.dart';
import 'package:password_vault/ui/views/startup/startup_view.dart';
import 'package:password_vault/ui/views/vault_screen/vault_screen_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';

import '../core/util/string_handler.dart';
import 'package:password_vault/ui/dialogs/input_string_dialog/input_string_dialog_dialog.dart';
// @stacked-import

@StackedApp(
  logger: StackedLogger(),
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: SignUpView),
    MaterialRoute(page: AddPasswordView),
    MaterialRoute(page: PasswordDetailView),
    MaterialRoute(page: MainScreenView),
    MaterialRoute(page: VaultScreenView),
    MaterialRoute(page: AccountScreenView),
// @stacked-route
  ],
  dependencies: [
    Singleton(classType: ThemeService, resolveUsing: ThemeService.getInstance),
    InitializableSingleton(classType: SharedPreferencesService),
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    InitializableSingleton(classType: RemoteConfigService),
    InitializableSingleton(classType: StringHandler),
    InitializableSingleton(classType: UserFirestoreService),
    InitializableSingleton(classType: AuthenticationService),
    InitializableSingleton(classType: PasswordFirestoreService),

    // @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    StackedBottomsheet(classType: LoadingSheet),
// @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    StackedDialog(classType: ErrorDialog),
    StackedDialog(classType: InputStringDialogDialog),
// @stacked-dialog
  ],
)
class App {}
