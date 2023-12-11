import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'vault_screen_viewmodel.dart';

class VaultScreenView extends StackedView<VaultScreenViewModel> {
  const VaultScreenView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    VaultScreenViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      ),
    );
  }

  @override
  VaultScreenViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      VaultScreenViewModel();
}
