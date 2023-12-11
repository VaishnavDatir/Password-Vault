import 'package:flutter/material.dart';
import 'package:password_vault/app/app.locator.dart';
import 'package:password_vault/app/app.shared_prefs.dart';
import 'package:password_vault/core/constants/share_prefs.constants.dart';
import 'package:stacked/stacked.dart';

class InputStringDialogDialogModel extends BaseViewModel {
  final _sharedPrefsService = locator<SharedPreferencesService>();

  final TextEditingController _inputTC = TextEditingController();
  TextEditingController get inputTC => _inputTC;

  Future<List<String>> getTagList() async {
    List<String> tagList = await _sharedPrefsService.read(kSpRecentTagList);
    return tagList ?? List.empty();
  }
}
