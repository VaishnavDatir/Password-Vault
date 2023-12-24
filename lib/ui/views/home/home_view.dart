import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:password_vault/ui/common/app_colors.dart';
import 'package:password_vault/ui/common/ui_helpers.dart';
import 'package:password_vault/ui/views/account_screen/account_screen_view.dart';
import 'package:password_vault/ui/views/add_password/add_password_view.dart';
import 'package:password_vault/ui/views/home/home_viewmodel.dart';
import 'package:password_vault/ui/views/vault_screen/vault_screen_view.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: _pages.length, vsync: this);
    super.initState();
  }

  final _pages = const [
    // MainScreenView(key: PageStorageKey("mainScreenView")),
    VaultScreenView(key: PageStorageKey("vaultScreenView")),
    AccountScreenView(key: PageStorageKey("accountScreenView"))
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(_tabController),
      onViewModelReady: (viewModel) => viewModel.initializeModel(),
      builder: (context, viewModel, child) {
        return Scaffold(
            extendBody: true,
            body: TabBarView(
                controller: viewModel.tabController, children: _pages),
            bottomNavigationBar: Container(
              width: screenWidth(context),
              margin: const EdgeInsets.symmetric(
                  horizontal: kLargeSpace, vertical: kSmallSpace),
              padding: const EdgeInsets.symmetric(
                  horizontal: kLargeSpace, vertical: kSmallSpace),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withAlpha(80)),
                borderRadius: BorderRadius.circular(200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300.withAlpha(150),
                    blurRadius: 5.0,
                    spreadRadius: 0.0,
                  ),
                ],
                color: Theme.of(context).cardColor.withOpacity(0.7),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // customBottomBarItem(
                  //         () {}, Icons.home_filled, "Home", viewModel, 0)
                  //     .animate()
                  //     .fadeIn(delay: const Duration(milliseconds: 500)),
                  customBottomBarItem(
                          () {}, Icons.security, "Vault", viewModel, 0)
                      .animate()
                      .fadeIn(delay: const Duration(milliseconds: 500)),
                  customBottomBarItem(() {}, Icons.account_circle_outlined,
                          "Account", viewModel, 1)
                      .animate()
                      .fadeIn(delay: const Duration(milliseconds: 500)),
                  OpenContainer(
                    clipBehavior: Clip.antiAlias,
                    closedShape: const CircleBorder(),
                    closedColor: kcWhite,
                    closedElevation: 0,
                    openColor: kcWhite,
                    transitionType: ContainerTransitionType.fadeThrough,
                    transitionDuration: const Duration(milliseconds: 500),
                    middleColor: kcWhite,
                    openShape: const RoundedRectangleBorder(),
                    closedBuilder: (context, action) {
                      return Tooltip(
                        message: "Add new password",
                        child: FloatingActionButton.small(
                          backgroundColor: kcPrimaryColorDark,
                          shape: const CircleBorder(),
                          onPressed: action,
                          child:
                              const Icon(Icons.add_moderator, color: kcWhite),
                        ),
                      );
                    },
                    openBuilder: (context, action) {
                      return const AddPasswordView();
                    },
                  ).animate().fadeIn(delay: const Duration(milliseconds: 500)),
                ],
              ),
            ).animate().scale().slideY());
      },
    );
  }

  InkWell customBottomBarItem(Function onTap, IconData iconData, String title,
      HomeViewModel viewModel, int index) {
    return InkWell(
      onTap: () => viewModel.tabController.animateTo(index),
      child: Tooltip(
        message: title,
        child: Icon(
          iconData,
          color:
              viewModel.selectedIndex == index ? kcPrimaryColorDark : kcBlack,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
