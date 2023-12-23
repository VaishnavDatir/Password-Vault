import 'package:flutter/material.dart';
import 'package:password_vault/ui/common/ui_helpers.dart';
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
    super.build(context);
    return Scaffold(
        extendBody: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
            bottom: false,
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: kMediumSpace,
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: kMediumSpace, vertical: kMediumSpace),
              child: Column(
                children: [
                  verticalSpaceSmall,
                  _topBar(context, viewModel),
                  _passwordList(viewModel, context)
                ],
              ),
            )));
  }

  Widget _passwordList(VaultScreenViewModel viewModel, BuildContext context) {
    return viewModel.isBusy
        ? const CircularProgressIndicator()
        : Expanded(
            child: ListView.builder(
            itemCount: viewModel.combinePasswords.length * 100,
            itemBuilder: (context, index) {
              return Card(
                child: Text(viewModel.combinePasswords[0].name!),
              );
            },
          ));
  }

  Widget _topBar(BuildContext context, VaultScreenViewModel viewModel) {
    return Wrap(
      children: [
        Text(
          "Vault",
          style: Theme.of(context)
              .primaryTextTheme
              .headlineMedium!
              .copyWith(fontWeight: FontWeight.w700),
        ),
        Container(
          margin:
              const EdgeInsets.only(top: kMediumSpace, bottom: kMediumSpace),
          padding: const EdgeInsets.symmetric(horizontal: kLargeSpace),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              borderRadius: const BorderRadius.all(Radius.circular(kRadius))),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: "Search"),
                ),
              ),
              Icon(
                Icons.search,
              )
            ],
          ),
        ),
        ElevatedButton(
            onPressed: () => viewModel.fetchPasswordList(),
            child: const Text("fetchPass"))
      ],
    );
  }

  @override
  VaultScreenViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      VaultScreenViewModel();

  @override
  void onViewModelReady(VaultScreenViewModel viewModel) {
    viewModel.initializePage();
  }
}
