import 'package:flutter/material.dart';
import 'package:password_vault/ui/common/app_colors.dart';
import 'package:password_vault/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'loading_sheet_model.dart';

class LoadingSheet extends StackedView<LoadingSheetModel> {
  final Function(SheetResponse response)? completer;
  final SheetRequest request;
  const LoadingSheet({
    Key? key,
    required this.completer,
    required this.request,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    LoadingSheetModel viewModel,
    Widget? child,
  ) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        false;
      },
      child: Container(
        margin: const EdgeInsets.all(kSmallSpace),
        width: screenWidth(context),
        padding: const EdgeInsets.all(kLargeSpace),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(kRadius / 4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              color: kcPrimaryColorDark,
            ),
            if (request.description != null) ...[
              verticalSpaceSmall,
              Text(
                request.description!,
                style: const TextStyle(fontSize: 14, color: kcMediumGrey),
                maxLines: 3,
                softWrap: true,
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  LoadingSheetModel viewModelBuilder(BuildContext context) =>
      LoadingSheetModel();
}
