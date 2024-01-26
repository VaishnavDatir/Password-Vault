import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:password_vault/model/password.model.dart';
import 'package:password_vault/model/prev_pass.model.dart';
import 'package:password_vault/ui/common/app_colors.dart';
import 'package:password_vault/ui/common/ui_helpers.dart';
import 'package:password_vault/ui/views/add_password/add_password_view.dart';
import 'package:stacked/stacked.dart';
import 'package:timeline_tile/timeline_tile.dart';

import 'password_detail_viewmodel.dart';

class PasswordDetailView extends StackedView<PasswordDetailViewModel> {
  final PasswordModel passwordModel;
  final bool isChildItem;

  const PasswordDetailView(
    this.passwordModel, {
    this.isChildItem = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    PasswordDetailViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                passwordModel.name!,
                style: Theme.of(context)
                    .primaryTextTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              verticalSpaceMedium,
              Expanded(child: _passwordDetails(context, viewModel)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: !isChildItem && viewModel.isAuthor
          ? _bottomNavbar(context, viewModel)
          : null,
    );
  }

  Widget _bottomNavbar(
      BuildContext context, PasswordDetailViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: kMediumSpace, vertical: kMediumSpace),
      width: screenWidth(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kcDarkGreyColor)),
              child: OpenContainer(
                clipBehavior: Clip.antiAlias,
                closedShape: const CircleBorder(),
                closedColor: kcWhite,
                closedElevation: 0,
                openColor: kcWhite,
                transitionType: ContainerTransitionType.fadeThrough,
                transitionDuration: const Duration(milliseconds: 500),
                middleColor: kcWhite,
                openShape: const RoundedRectangleBorder(),
                openBuilder: (context, action) =>
                    AddPasswordView(passwordModel: viewModel.passwordModel),
                closedBuilder: (context, action) => Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.edit,
                    size: kLargeIconSize,
                    color: kcDarkGreyColor,
                  ),
                ),
              )),
          horizontalSpaceSmall,
          Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kcPrimaryColorDark)),
              child: IconButton(
                onPressed: () => viewModel.deletePassword(),
                icon: const Icon(
                  Icons.delete_forever,
                  size: kLargeIconSize,
                ),
              ))
        ],
      ),
    );
  }

  Widget _passwordDetails(
      BuildContext context, PasswordDetailViewModel viewModel) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          TextFormField(
            canRequestFocus: false,
            readOnly: true,
            enableInteractiveSelection: true,
            initialValue: viewModel.passwordModel.username,
            obscureText: viewModel.obscureUsername,
            decoration: InputDecoration(
              border: InputBorder.none,
              labelText: "Username",
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!viewModel.obscureUsername)
                    IconButton(
                      icon: const Icon(Icons.copy_all_sharp),
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(
                            text: viewModel.passwordModel.username!));
                      },
                    ),
                  IconButton(
                    icon: Icon(viewModel.obscureUsername
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () => viewModel.updateObscureUsername(),
                  ),
                ],
              ),
            ),
          ),
          TextFormField(
            canRequestFocus: false,
            readOnly: true,
            enableInteractiveSelection: true,
            initialValue: viewModel.passwordModel.password,
            obscureText: viewModel.obscurePassword,
            decoration: InputDecoration(
              border: InputBorder.none,
              labelText: "Password",
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!viewModel.obscurePassword)
                    IconButton(
                      icon: const Icon(Icons.copy_all_sharp),
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(
                            text: viewModel.passwordModel.password!));
                      },
                    ),
                  IconButton(
                    icon: Icon(viewModel.obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () => viewModel.updateObscurePassword(),
                  ),
                ],
              ),
            ),
          ),
          TextFormField(
            canRequestFocus: false,
            readOnly: true,
            enableInteractiveSelection: true,
            initialValue: viewModel.passwordModel.note,
            decoration: const InputDecoration(
              border: InputBorder.none,
              labelText: "Notes",
            ),
          ),
          TextFormField(
            canRequestFocus: false,
            readOnly: true,
            enableInteractiveSelection: true,
            initialValue: viewModel.passwordModel.tags!.isNotEmpty
                ? viewModel.passwordModel.tags?.join(", ")
                : "No tags given",
            decoration: const InputDecoration(
              border: InputBorder.none,
              labelText: "Tags",
            ),
          ),
          if (!isChildItem)
            TextFormField(
              canRequestFocus: false,
              readOnly: true,
              enableInteractiveSelection: true,
              initialValue:
                  "${DateFormat.yMMMMd().format(viewModel.passwordModel.createDate!)} ${DateFormat.jms().format(viewModel.passwordModel.createDate!)} ",
              decoration: const InputDecoration(
                border: InputBorder.none,
                labelText: "Created on",
              ),
            ),
          TextFormField(
            canRequestFocus: false,
            readOnly: true,
            enableInteractiveSelection: true,
            initialValue:
                "${DateFormat.yMMMMd().format(viewModel.passwordModel.updateTime!)} ${DateFormat.jms().format(viewModel.passwordModel.updateTime!)}",
            decoration: const InputDecoration(
              border: InputBorder.none,
              labelText: "Last updated on",
            ),
          ),
          const Divider(),
          if (!isChildItem && viewModel.passwordModel.prevPass!.isNotEmpty)
            _historyWidget(context, viewModel),
        ],
      ),
    );
  }

  Widget _historyWidget(
      BuildContext context, PasswordDetailViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "History",
          style: Theme.of(context)
              .primaryTextTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        verticalSpaceSmall,
        for (int i = 0; i < viewModel.passwordModel.prevPass!.length; i++)
          _timelineTile(
              i == 0,
              i == viewModel.passwordModel.prevPass!.length - 1,
              viewModel.passwordModel.prevPass!.elementAt(i),
              context),
      ],
    );
  }

  TimelineTile _timelineTile(
    bool isFirst,
    bool isLast,
    PrevPassModel prevPassModel,
    BuildContext context,
  ) {
    return TimelineTile(
      alignment: TimelineAlign.start,
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: const IndicatorStyle(color: kcPrimaryColorDark),
      beforeLineStyle: const LineStyle(color: kcPrimaryColor),
      afterLineStyle: const LineStyle(color: kcPrimaryColor),
      endChild: OpenContainer(
        tappable: true,
        openShape: const BeveledRectangleBorder(),
        closedShape: const BeveledRectangleBorder(),
        closedColor: Colors.transparent,
        closedElevation: 0,
        middleColor: kcWhite,
        openColor: kcWhite,
        openBuilder: (context, action) {
          return PasswordDetailView(
            PasswordModel(
              authorId: passwordModel.authorId,
              id: passwordModel.id,
              name: prevPassModel.name,
              note: prevPassModel.note,
              username: prevPassModel.username,
              password: prevPassModel.password,
              updateTime: prevPassModel.updateTime,
              tags: prevPassModel.tags,
              sharedAccs: prevPassModel.sharedAccs,
            ),
            isChildItem: true,
          );
        },
        closedBuilder: (context, action) {
          return Card(
            child: ListTile(
              title: Text(
                "${DateFormat.yMMMMd().format(prevPassModel.updateTime!)} ${DateFormat.jms().format(prevPassModel.updateTime!)}",
                style: Theme.of(context).primaryTextTheme.titleMedium,
              ),
              subtitle: Text(prevPassModel.updateType ?? ""),
            ),
          );
        },
      ),
    );
  }

  @override
  PasswordDetailViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      PasswordDetailViewModel(passwordModel);

  @override
  void onViewModelReady(PasswordDetailViewModel viewModel) {
    viewModel.initilizeView();
    super.onViewModelReady(viewModel);
  }
}
