import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'main_screen_viewmodel.dart';

class MainScreenView extends StackedView<MainScreenViewModel> {
  const MainScreenView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    MainScreenViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      ),
    );
  }

  @override
  MainScreenViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      MainScreenViewModel();
}
