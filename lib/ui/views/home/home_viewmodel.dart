import 'package:flutter/material.dart';
import 'package:password_vault/app/app.locator.dart';
import 'package:password_vault/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  late final TabController _tabController;
  TabController get tabController => _tabController;

  HomeViewModel(TabController tabController) {
    _tabController = tabController;
  }

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void initializeModel() {
    tabController.addListener(() {
      _selectedIndex = tabController.index;
      notifyListeners();
    });
  }

  void navigateToAddPasswordScreen() async {
    await _navigationService.navigateTo(Routes.addPasswordView);
  }
}
