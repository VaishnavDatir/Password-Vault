import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'account_screen_viewmodel.dart';

class AccountScreenView extends StackedView<AccountScreenViewModel> {
  const AccountScreenView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AccountScreenViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 25.0, right: 25.0),
          child: ElevatedButton(
              onPressed: () => viewModel.signOutUser(),
              child: const Text("sign out")),
        ),
      ),
    );
  }

  @override
  AccountScreenViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AccountScreenViewModel();
}
