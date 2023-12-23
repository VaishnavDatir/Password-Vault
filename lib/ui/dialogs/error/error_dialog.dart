import 'package:flutter/material.dart';
import 'package:password_vault/ui/common/app_colors.dart';
import 'package:password_vault/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'error_dialog_model.dart';

class ErrorDialog extends StackedView<ErrorDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const ErrorDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ErrorDialogModel viewModel,
    Widget? child,
  ) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: kcRed)),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              request.title ?? 'Error',
              style: const TextStyle(
                color: kcRed,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            if (request.description != null) ...[
              verticalSpaceTiny,
              Text(
                request.description!,
                style: const TextStyle(
                  fontSize: 14,
                  color: kcMediumGrey,
                ),
                maxLines: 3,
                softWrap: true,
              ),
            ],
            verticalSpaceMedium,
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
              ),
              onPressed: () => completer(DialogResponse(confirmed: true)),
              child: const Text(
                'Got it',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  ErrorDialogModel viewModelBuilder(BuildContext context) => ErrorDialogModel();
}
