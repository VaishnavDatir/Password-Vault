import 'package:flutter/material.dart';
import 'package:password_vault/ui/common/app_colors.dart';
import 'package:password_vault/ui/common/custom_text_input_field.dart';
import 'package:password_vault/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'input_string_dialog_dialog_model.dart';

class InputStringDialogDialog
    extends StackedView<InputStringDialogDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const InputStringDialogDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    InputStringDialogDialogModel viewModel,
    Widget? child,
  ) {
    List<String> listOfRecentTags = request.data ?? List.empty(growable: true);
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
            const Text(
              "Add Tag",
              style: TextStyle(
                color: kcRed,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            verticalSpaceMedium,
            CustomTextInputField(
                controller: viewModel.inputTC,
                hintText: "Tag name",
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.done),
            if (listOfRecentTags.isNotEmpty) ...[
              verticalSpaceMedium,
              const Text("Recent"),
              Wrap(alignment: WrapAlignment.start, spacing: 4, children: [
                for (String i in listOfRecentTags)
                  InkWell(
                    onTap: () =>
                        completer(DialogResponse(confirmed: true, data: i)),
                    child: Chip(
                      label: Text(i),
                      deleteIcon: const Icon(Icons.cancel),
                    ),
                  )
              ]),
            ],
            verticalSpaceMedium,
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                  backgroundColor: kcPrimaryColorDark),
              onPressed: () => completer(DialogResponse(
                  confirmed: true, data: viewModel.inputTC.text)),
              child: const Text(
                'Add',
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
  InputStringDialogDialogModel viewModelBuilder(BuildContext context) =>
      InputStringDialogDialogModel();
}
