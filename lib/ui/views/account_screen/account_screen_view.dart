import 'package:flutter/material.dart';
import 'package:password_vault/ui/common/app_colors.dart';
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
          margin: const EdgeInsets.symmetric(
              vertical: kLargeSpace, horizontal: kLargeSpace),
          padding: const EdgeInsets.only(top: kMediumSpace),
          child: SingleChildScrollView(
            child: Column(
              children: [
                RandomAvatar(
                  viewModel.userModel.id!,
                  width: screenWidthFraction(context, dividedBy: 3),
                ),
                Text(
                  viewModel.userModel.name!,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(viewModel.userModel.emailId!),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.dark_mode_outlined),
                  onTap: () {},
                  title: const Text("Dark mode"),
                  trailing: Switch(
                    value: false,
                    onChanged: (value) {},
                  ),
                ),
                ListTile(
                    leading: const Icon(Icons.logout_rounded),
                    onTap: () => viewModel.signOutUser(),
                    title: const Text("Sign out")),
                ListTile(
                    leading: const Icon(Icons.lock_outline_rounded),
                    onTap: () => viewModel.signOutUser(),
                    title: const Text("Change password")),
                ListTile(
                    textColor: kcRed,
                    iconColor: kcRed,
                    leading: const Icon(Icons.delete_outline),
                    onTap: () => viewModel.handleDeleteAccount(),
                    title: const Text("Delete account")),
                const Divider(),
                ListTile(
                    leading: const Icon(Icons.text_snippet_outlined),
                    onTap: () => viewModel.signOutUser(),
                    title: const Text("Term & Conditions")),
                ListTile(
                    leading: const Icon(Icons.feedback_outlined),
                    onTap: () => viewModel.signOutUser(),
                    title: const Text("Feedback")),
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
