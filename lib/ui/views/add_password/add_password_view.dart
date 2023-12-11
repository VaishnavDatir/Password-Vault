import 'package:flutter/material.dart';
import 'package:password_vault/ui/common/app_colors.dart';
import 'package:password_vault/ui/common/custom_text_input_field.dart';
import 'package:password_vault/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';

import 'add_password_viewmodel.dart';

class AddPasswordView extends StackedView<AddPasswordViewModel> {
  const AddPasswordView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AddPasswordViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: _appBar(),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: _bodyContent(viewModel, context),
          ),
        ),
        bottomNavigationBar: _createButton(viewModel));
  }

  Container _createButton(AddPasswordViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: kMediumSpace,
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: kMediumSpace, vertical: kMediumSpace),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(40),
            backgroundColor: kcPrimaryColorDark),
        onPressed: () => viewModel.handleCreate(),
        child: const Text(
          'Create',
        ),
      ),
    );
  }

  SingleChildScrollView _bodyContent(
      AddPasswordViewModel viewModel, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
              child: Text("Fill the below details and save the password")),
          const Divider(),
          verticalSpaceSmall,
          CustomTextInputField(
            controller: viewModel.titleTC,
            focusNode: viewModel.titleFN,
            hintText: "",
            labelText: "Title",
            onSubmit: (value) =>
                FocusScope.of(viewModel.scaffoldKey.currentContext!)
                    .requestFocus(viewModel.usernameFN),
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
          ),
          verticalSpaceMedium,
          CustomTextInputField(
            controller: viewModel.usernameTC,
            focusNode: viewModel.usernameFN,
            hintText: "",
            labelText: "Username / Email Id",
            onSubmit: (value) =>
                FocusScope.of(viewModel.scaffoldKey.currentContext!)
                    .requestFocus(viewModel.passwordFN),
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
          ),
          verticalSpaceMedium,
          CustomTextInputField(
            controller: viewModel.passwordTC,
            focusNode: viewModel.passwordFN,
            hintText: "",
            labelText: "Password",
            obscureText: viewModel.isObscureText,
            onSubmit: (value) =>
                FocusScope.of(viewModel.scaffoldKey.currentContext!)
                    .requestFocus(viewModel.notesFN),
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
          ),
          verticalSpaceMedium,
          CustomTextInputField(
            controller: viewModel.notesTC,
            focusNode: viewModel.notesFN,
            hintText: "",
            labelText: "Notes",
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
          ),
          const Divider(),
          Text(
            "Tags",
            style: Theme.of(context).textTheme.labelLarge,
          ),
          verticalSpaceSmall,
          Wrap(alignment: WrapAlignment.start, spacing: 4, children: [
            for (var i in viewModel.tagList) _tagChip(i, viewModel),
            IconButton(
                onPressed: () => viewModel.addInTagList(),
                icon: const Icon(Icons.add_circle_outline_rounded))
          ]),
          const Divider(),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      centerTitle: true,
      title: const Text(
        "Add password",
        style: TextStyle(
            fontSize: kMediumIconSize,
            fontWeight: FontWeight.bold,
            color: kcPrimaryColorDark),
      ),
    );
  }

  Chip _tagChip(String text, AddPasswordViewModel viewModel) {
    return Chip(
        label: Text(text),
        deleteIcon: const Icon(Icons.cancel),
        onDeleted: () => viewModel.removeFromTagList(text));
  }

  @override
  AddPasswordViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AddPasswordViewModel();
}
