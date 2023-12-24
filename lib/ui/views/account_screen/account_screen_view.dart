import 'package:flutter/material.dart';
import 'package:password_vault/ui/common/ui_helpers.dart';
import 'package:random_avatar/random_avatar.dart';
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
          padding: const EdgeInsets.symmetric(
              vertical: kLargeSpace, horizontal: kLargeSpace),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  child: ListTile(
                    leading: RandomAvatar(viewModel.userModel.id!,
                        width: 50, height: 50),
                    title: Text(
                      viewModel.userModel.name!,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(viewModel.userModel.emailId!),
                  ),
                ),
                ListTile(
                    leading: const Icon(Icons.logout_rounded),
                    onTap: () => viewModel.signOutUser(),
                    title: const Text("Sign out")),
              ],
            ),
          ),
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
