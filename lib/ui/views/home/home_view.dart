import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:password_vault/ui/common/app_colors.dart';
import 'package:password_vault/ui/common/ui_helpers.dart';
import 'package:password_vault/ui/views/account_screen/account_screen_view.dart';
import 'package:password_vault/ui/views/add_password/add_password_view.dart';
import 'package:password_vault/ui/views/home/home_viewmodel.dart';
import 'package:password_vault/ui/views/main_screen/main_screen_view.dart';
import 'package:password_vault/ui/views/vault_screen/vault_screen_view.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(_tabController),
      onViewModelReady: (viewModel) => viewModel.initializeModel(),
      builder: (context, viewModel, child) {
        return Scaffold(
            extendBody: true,
            body: TabBarView(
              controller: viewModel.tabController,
              children: const [
                MainScreenView(),
                VaultScreenView(),
                AccountScreenView()
              ],
            ),
            bottomNavigationBar: Container(
              width: screenWidth(context),
              margin: const EdgeInsets.symmetric(
                  horizontal: kLargeSpace, vertical: kLargeSpace),
              padding: const EdgeInsets.symmetric(
                  horizontal: kLargeSpace, vertical: kMediumSpace),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withAlpha(80)),
                borderRadius: BorderRadius.circular(200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400.withAlpha(150),
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                  ),
                ],
                color: Theme.of(context).cardColor.withOpacity(0.7),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  customBottomBarItem(
                      () {}, Icons.home_filled, "Home", viewModel, 0),
                  customBottomBarItem(
                      () {}, Icons.security, "Vault", viewModel, 1),
                  customBottomBarItem(() {}, Icons.account_circle_outlined,
                      "Account", viewModel, 2),
                  OpenContainer(
                    clipBehavior: Clip.antiAlias,
                    closedShape: const CircleBorder(),
                    closedColor: kcPrimaryColorDark,
                    closedElevation: 0,
                    transitionType: ContainerTransitionType.fadeThrough,
                    transitionDuration: const Duration(milliseconds: 700),
                    onClosed: (data) {
                      print("$data");
                    },
                    closedBuilder: (context, action) {
                      return FloatingActionButton(
                        backgroundColor: kcPrimaryColorDark,
                        shape: const CircleBorder(),
                        onPressed: action,
                        child: const Icon(Icons.add_moderator, color: kcWhite),
                      );
                    },
                    openBuilder: (context, action) {
                      return const AddPasswordView();
                    },
                  ),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconData,
            color:
                viewModel.selectedIndex == index ? kcPrimaryColorDark : kcBlack,
          ),
          Text(
            title,
            style: TextStyle(
              color: viewModel.selectedIndex == index
                  ? kcPrimaryColorDark
                  : kcBlack,
            ),
          )
        ],
      ),
    );
  }
}
