import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:password_vault/app/app.bottomsheets.dart';
import 'package:password_vault/app/app.dialogs.dart';
import 'package:password_vault/app/app.locator.dart';
import 'package:password_vault/app/app.logger.dart';
import 'package:password_vault/app/app.router.dart';
import 'package:password_vault/app/app.shared_prefs.dart';
import 'package:password_vault/core/constants/share_prefs.constants.dart';
import 'package:password_vault/core/util/common_utils.dart';
import 'package:password_vault/core/util/string_handler.dart';
import 'package:password_vault/model/password.model.dart';
import 'package:password_vault/model/prev_pass.model.dart';
import 'package:password_vault/services/firebase/password_firestore_service.dart';
import 'package:password_vault/services/firebase/user_firestore_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AddPasswordViewModel extends BaseViewModel {
  late PasswordModel? _passwordModel;
  PasswordModel? get passwordModel => _passwordModel;

  AddPasswordViewModel(PasswordModel? passwordModel) {
    _passwordModel = passwordModel;
  }

  final logger = getLogger('AddPasswordViewModel');
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  //

  final _navigationService = locator<NavigationService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _userFirestoreService = locator<UserFirestoreService>();
  final _passwordFirestoreService = locator<PasswordFirestoreService>();
  final _dialougeService = locator<DialogService>();
  final _stringHandler = locator<StringHandler>();
  final _sharedPrefsService = locator<SharedPreferencesService>();

  //

  final TextEditingController _titleTC = TextEditingController();
  TextEditingController get titleTC => _titleTC;

  final FocusNode _titleFN = FocusNode();
  FocusNode get titleFN => _titleFN;

  //

  final TextEditingController _usernameTC = TextEditingController();
  TextEditingController get usernameTC => _usernameTC;

  final FocusNode _usernameFN = FocusNode();
  FocusNode get usernameFN => _usernameFN;

  //

  final TextEditingController _passwordTC = TextEditingController();
  TextEditingController get passwordTC => _passwordTC;

  final FocusNode _passwordFN = FocusNode();
  FocusNode get passwordFN => _passwordFN;

  //

  final TextEditingController _tagTC = TextEditingController();
  TextEditingController get tagTC => _tagTC;

  final FocusNode _tagFN = FocusNode();
  FocusNode get tagFN => _tagFN;

  //

  final TextEditingController _notesTC = TextEditingController();
  TextEditingController get notesTC => _notesTC;

  final FocusNode _notesFN = FocusNode();
  FocusNode get notesFN => _notesFN;

  //

  final TextEditingController _sharedUsersTC = TextEditingController();
  TextEditingController get sharedUsersTC => _sharedUsersTC;

  final FocusNode _sharedUsersFN = FocusNode();
  FocusNode get sharedUsersFN => _sharedUsersFN;

  //

  List<String> _tagList = List.empty(growable: true);
  List<String> get tagList => _tagList;

  final List<String> _sharedUsersList = [];
  List<String> get sharedUsersList => _sharedUsersList;

  //

  bool _isObscureText = true;
  bool get isObscureText => _isObscureText;

  void changeObsecureValue() {
    _isObscureText = !_isObscureText;
    notifyListeners();
  }

  void addInTagList() async {
    List<Object?> spRecentTagList =
        await _sharedPrefsService.read(kSpRecentTagList) ??
            List.empty(growable: true);
    List<String> recentTags = (spRecentTagList.isNotEmpty)
        ? spRecentTagList.map((e) => e.toString()).toList()
        : List.empty(growable: true);
    DialogResponse? dialogResponse = await _dialougeService.showCustomDialog(
        variant: DialogType.inputStringDialog,
        barrierDismissible: true,
        data: recentTags);
    if (null != dialogResponse && null != dialogResponse.data) {
      String tagName = dialogResponse.data.toString().capitalize();
      if (tagName.isNotEmpty) {
        if (!_tagList.contains(tagName)) {
          _tagList.add(tagName);
          _updateRecentTagList(tagName, recentTags);
        } else {
          await _dialougeService.showCustomDialog(
            variant: DialogType.error,
            title: "Ohh!",
            description: "Tag is already present",
          );
        }
      } else {
        await _dialougeService.showCustomDialog(
          variant: DialogType.error,
          title: "Oops!",
          description: "Empty tag cannot be added",
        );
      }
    }
    notifyListeners();
  }

  void _updateRecentTagList(String tagName, List<String> recentTags) async {
    recentTags = recentTags.reversed.take(5).toList();
    if (!recentTags.contains(tagName)) {
      recentTags.add(tagName);
      await _sharedPrefsService.write(kSpRecentTagList, recentTags);
    }
  }

  void removeFromTagList(String tagName) {
    _tagList.remove(tagName);
    notifyListeners();
  }

  void addInSharedUsersList(String usedId) {
    _sharedUsersList.add(usedId);
    notifyListeners();
  }

  void emptyFromSharedUsersList(String usedId) {
    _sharedUsersList.remove(usedId);
    notifyListeners();
  }

  //

  void handleButtonClick() async {
    try {
      _bottomSheetService.showCustomSheet(
          variant: BottomSheetType.loading,
          enableDrag: false,
          barrierDismissible: false,
          takesInput: false,
          description: "Please wait while we setup your account");
      if (_passwordModel != null) {
        await handleUpdate();
      } else {
        await handleCreate();
      }
    } on FirebaseException catch (e) {
      logger.e(e);
      _navigationService.back();
      await _dialougeService.showCustomDialog(
          variant: DialogType.error, title: "Oops", description: e.message);
    } catch (ex) {
      logger.e(ex);
      _navigationService.back();
      await _dialougeService.showCustomDialog(
          variant: DialogType.error,
          title: "Error",
          description: ex.toString());
    }
  }

  Future<void> handleUpdate() async {
    List<String> updatedItems = _getListOfUpdatedItems();

    if (updatedItems.isNotEmpty) {
      List<PrevPassModel> prevPassList =
          _passwordModel?.prevPass ?? List.empty(growable: true);

      prevPassList.add(PrevPassModel(
          name: _passwordModel?.name,
          note: _passwordModel?.note,
          password: _stringHandler.encryptAuthPass(
              _passwordModel!.password!, _passwordModel!.id!),
          username: _stringHandler.encryptAuthPass(
              _passwordModel!.username!, _passwordModel!.id!),
          tags: _passwordModel?.tags,
          updateTime: DateTime.now(),
          updateType: "Updated ${updatedItems.join(", ")}"));

      PasswordModel passwordModel = PasswordModel(
          authorId: _userFirestoreService.currentUser!.id,
          name: _titleTC.text.trim(),
          tags: tagList,
          note: _notesTC.text.trim(),
          createDate: _passwordModel!.createDate,
          updateTime: DateTime.now(),
          id: _passwordModel?.id,
          username: _stringHandler.encryptAuthPass(
              _usernameTC.text.trim(), _passwordModel!.id!),
          password: _stringHandler.encryptAuthPass(
              _passwordTC.text.trim(), _passwordModel!.id!),
          prevPass: prevPassList);

      await _passwordFirestoreService.updatePassword(passwordModel);
      _navigationService.clearStackAndShow(Routes.homeView);

      await _dialougeService.showCustomDialog(
          variant: DialogType.error,
          title: "Done",
          description: "Details updated in vault");
    } else {
      await _dialougeService.showCustomDialog(
          variant: DialogType.infoAlert,
          title: "Sure",
          description: "Nothing is here to update!");
    }
    _navigationService.back();
  }

  List<String> _getListOfUpdatedItems() {
    List<String> updatedItems = List.empty(growable: true);
    if (_passwordModel?.name != _titleTC.text.trim()) {
      updatedItems.add("Title");
    }
    if (!listEquals(_passwordModel?.tags, _tagList)) {
      updatedItems.add("Tags");
    }
    if (_passwordModel?.note != _notesTC.text.trim()) {
      updatedItems.add("Notes");
    }
    if (_passwordModel?.password != _passwordTC.text.trim()) {
      updatedItems.add("Password");
    }
    if (_passwordModel?.username != _usernameTC.text.trim()) {
      updatedItems.add("Username");
    }
    return updatedItems;
  }

  Future<void> handleCreate() async {
    await savePassword();
    _navigationService.clearStackAndShow(Routes.homeView);
    await _dialougeService.showCustomDialog(
        variant: DialogType.error,
        title: "Done",
        description: "Password added to vault");
    _navigationService.back();
  }

  Future<void> savePassword() async {
    PasswordModel passwordModel = PasswordModel(
      authorId: _userFirestoreService.currentUser!.id,
      name: _titleTC.text.trim(),
      tags: tagList,
      note: _notesTC.text.trim(),
      createDate: DateTime.now(),
      updateTime: DateTime.now(),
    );
    DocumentReference documentReference =
        await _passwordFirestoreService.addNewPassword(passwordModel);
    passwordModel = PasswordModel(
        authorId: _userFirestoreService.currentUser!.id,
        name: _titleTC.text.trim(),
        tags: tagList,
        note: _notesTC.text.trim(),
        createDate: DateTime.now(),
        updateTime: DateTime.now(),
        id: documentReference.id,
        isFav: false,
        username: _usernameTC.text.trim().isEmpty
            ? null
            : _stringHandler.encryptAuthPass(
                _usernameTC.text.trim(), documentReference.id),
        password: _stringHandler.encryptAuthPass(
            _passwordTC.text.trim(), documentReference.id));
    await _passwordFirestoreService.updatePassword(passwordModel);
  }

  void initializeScreen() {
    if (_passwordModel != null) {
      _titleTC.text = _passwordModel!.name ?? "";
      _usernameTC.text = _passwordModel!.username ?? "";
      _passwordTC.text = _passwordModel!.password ?? "";
      _notesTC.text = _passwordModel!.note ?? "";
      // _tagList =  _passwordModel?.tags ?? List.empty(growable: true);
      _tagList = _passwordModel?.tags?.map((e) => e.toString()).toList() ??
          List.empty(growable: true);
    }
    notifyListeners();
  }
}
