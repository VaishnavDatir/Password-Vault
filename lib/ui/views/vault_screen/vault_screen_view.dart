import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:password_vault/app/app.router.dart';
import 'package:password_vault/ui/common/app_colors.dart';
import 'package:password_vault/ui/common/ui_helpers.dart';
import 'package:password_vault/ui/views/password_detail/password_detail_view.dart';
import 'package:shimmer/shimmer.dart';
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
    return Expanded(
      child: viewModel.isBusy
          ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 1.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const SizedBox(height: 80),
                  );
                },
              ),
            )
          : viewModel.combinePasswords.isEmpty
              ? Center(
                  child: Text(
                    "No data in vault!",
                    style: Theme.of(context).primaryTextTheme.headlineMedium,
                  ).animate().fadeIn(delay: const Duration(milliseconds: 500)),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    viewModel.initializePage();
                  },
                  child: ListView.separated(
                    itemCount: viewModel.combinePasswords.length,
                    itemBuilder: (context, index) {
                      return OpenContainer<int>(
                        useRootNavigator: true,
                        routeSettings: const RouteSettings(
                          name: Routes.addPasswordView,
                        ),
                        openBuilder: (context, action) => PasswordDetailView(
                            viewModel.combinePasswords.elementAt(index)),
                        openColor: Theme.of(context).scaffoldBackgroundColor,
                        closedColor: Theme.of(context).scaffoldBackgroundColor,
                        onClosed: (data) {
                          if (data == 0) {
                            viewModel.initializePage();
                          }
                        },
                        middleColor: Theme.of(context).scaffoldBackgroundColor,
                        closedBuilder: (context, action) => Container(
                          decoration: BoxDecoration(
                              border: Border.all(style: BorderStyle.none)),
                          child: ListTile(
                            leading: Container(
                              width: kRadius * 2,
                              padding: const EdgeInsets.all(kMediumSpace),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: kcPrimaryColorLight,
                                border: Border.all(color: kcPrimaryColorDark),
                              ),
                              child: Text(
                                viewModel.combinePasswords
                                            .elementAt(index)
                                            .name!
                                            .split(' ')
                                            .length >=
                                        2
                                    ? "${viewModel.combinePasswords.elementAt(index).name!.substring(0, 1)} ${viewModel.combinePasswords.elementAt(index).name!.split(' ').last.substring(0, 1)}"
                                    : viewModel.combinePasswords[index].name!
                                        .substring(0, 1),
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            title:
                                Text(viewModel.combinePasswords[index].name!),
                            subtitle: Text(viewModel
                                    .combinePasswords[index].tags
                                    ?.join(", ") ??
                                ""),
                            trailing:
                                const Icon(Icons.arrow_forward_ios_rounded),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: kSmallSpace,
                      );
                    },
                  ),
                ),
    );
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
        const Divider()
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
