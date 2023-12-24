import 'dart:convert';

import 'package:password_vault/app/app.dialogs.dart';
import 'package:password_vault/app/app.locator.dart';
import 'package:password_vault/core/util/string_handler.dart';
import 'package:password_vault/model/password.model.dart';
import 'package:password_vault/services/firebase/password_firestore_service.dart';
import 'package:password_vault/services/firebase/user_firestore_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PasswordDetailViewModel extends BaseViewModel {
  final _stringHandler = locator<StringHandler>();
  final _userFirestoreService = locator<UserFirestoreService>();
  final _passwordFirestoreService = locator<PasswordFirestoreService>();
  final _navigationService = locator<NavigationService>();

  final _dialogService = locator<DialogService>();

  late PasswordModel _passwordModel;
  PasswordModel get passwordModel => _passwordModel;

  PasswordDetailViewModel(PasswordModel passwordModel) {
    String json = jsonEncode(passwordModel.toJson());
    _passwordModel = PasswordModel.fromJson(jsonDecode(json));
    _passwordModel.setUsername(_stringHandler.decryptAuthPass(
        passwordModel.username!, passwordModel.id!));
    _passwordModel.setPassword(_stringHandler.decryptAuthPass(
        passwordModel.password!, passwordModel.id!));
  }

  bool _obscureUsername = true;
  bool get obscureUsername => _obscureUsername;

  void updateObscureUsername() {
    _obscureUsername = !_obscureUsername;
    notifyListeners();
  }

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  void updateObscurePassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  bool _isAuthor = false;
  bool get isAuthor => _isAuthor;

  void checkIsAuthor() {
    if (_userFirestoreService.currentUser!.id! == passwordModel.authorId!) {
      _isAuthor = true;
    } else {
      _isAuthor = false;
    }
  }

  void initilizeView() {
    _passwordModel.prevPass
        ?.sort((b, a) => a.updateTime!.compareTo(b.updateTime!));
    _passwordModel.setPrevPassModel(_passwordModel.prevPass);
    checkIsAuthor();
    notifyListeners();
  }

  void deletePassword() async {
    DialogResponse<dynamic>? dialogResponse =
        await _dialogService.showConfirmationDialog(
            title: "Are you sure?",
            description:
                "By deleting the vault:\n- All the data related to this vault will be deleted.\n- The shared members won't be able to see it.\n- The action is not revertable.",
            confirmationTitle: "Delete");
    if (dialogResponse != null && dialogResponse.confirmed) {
      try {
        await _passwordFirestoreService.deletePassword(passwordModel.id!);
        await _dialogService.showCustomDialog(
            variant: DialogType.infoAlert,
            title: "Deleted",
            description:
                "Vault named ${passwordModel.name} successfully deleted!");
        _navigationService.back(result: 0);
      } catch (e) {
        await _dialogService.showCustomDialog(
            variant: DialogType.error,
            title: "Error!",
            description:
                "Vault named ${passwordModel.name} could not be deleted because $e");
        _navigationService.back(result: 1);
      }
    }
  }
}
