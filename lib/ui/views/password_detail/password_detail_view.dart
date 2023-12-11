import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'password_detail_viewmodel.dart';

class PasswordDetailView extends StackedView<PasswordDetailViewModel> {
  const PasswordDetailView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    PasswordDetailViewModel viewModel,
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
  PasswordDetailViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      PasswordDetailViewModel();
}
