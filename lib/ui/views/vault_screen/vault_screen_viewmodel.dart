import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:password_vault/app/app.locator.dart';
import 'package:password_vault/services/firebase/password_firestore_service.dart';
import 'package:stacked/stacked.dart';

import '../../../model/password.model.dart';

class VaultScreenViewModel extends BaseViewModel {
  final PasswordFirestoreService _passwordFirestoreService =
      locator<PasswordFirestoreService>();

  final TextEditingController _serchTc = TextEditingController();
  TextEditingController get serchTx => _serchTc;

  ScrollController scrollController = ScrollController();

  final FocusNode _searchFn = FocusNode();
  FocusNode get searchFn => _searchFn;

  bool _showFullSearchBox = true;
  bool get showFullSearchBox => _showFullSearchBox;

  late List<PasswordModel> _combinePasswords;
  List<PasswordModel> get combinePasswords => _combinePasswords;

  void initializePage() async {
    setBusy(true);
    await fetchPasswordList();
    setBusy(false);
    notifyListeners();
  }

  Future fetchPasswordList() async {
    _combinePasswords = await _passwordFirestoreService.fetchMyPasswords();
    notifyListeners();
  }

  void scrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        _showFullSearchBox = true;
      } else {
        _showFullSearchBox = false;
      }
      notifyListeners();
    });
  }
}
