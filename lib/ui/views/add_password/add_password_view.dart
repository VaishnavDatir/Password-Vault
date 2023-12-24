import 'package:flutter/material.dart';
import 'package:password_vault/model/password.model.dart';
import 'package:password_vault/ui/common/app_colors.dart';
import 'package:password_vault/ui/common/custom_text_input_field.dart';
import 'package:password_vault/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';

import 'add_password_viewmodel.dart';

class AddPasswordView extends StackedView<AddPasswordViewModel> {
  final PasswordModel? passwordModel;
  const AddPasswordView({this.passwordModel, Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AddPasswordViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: _appBar(context),
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
        onPressed: () => viewModel.handleButtonClick(),
        child: Text(
          passwordModel != null ? "Update" : 'Create',
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
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
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
            keyboardType: TextInputType.emailAddress,
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
            suffixIcon: IconButton(
              icon: Icon(viewModel.isObscureText
                  ? Icons.visibility_off
                  : Icons.visibility),
              onPressed: () => viewModel.changeObsecureValue(),
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
          ),
          verticalSpaceMedium,
          CustomTextInputField(
            controller: viewModel.notesTC,
            focusNode: viewModel.notesFN,
            hintText: "",
            labelText: "Notes",
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.sentences,
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

  AppBar _appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        passwordModel != null ? "Update password" : "Add password",
        style: Theme.of(context).primaryTextTheme.titleLarge,
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
      AddPasswordViewModel(passwordModel);
  @override
  void onViewModelReady(AddPasswordViewModel viewModel) {
    viewModel.initializeScreen();
    super.onViewModelReady(viewModel);
  }
}
