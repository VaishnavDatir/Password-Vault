import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:password_vault/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';

import '../../common/app_colors.dart';
import '../../common/custom_text_input_field.dart';
import 'sign_up_viewmodel.dart';

class SignUpView extends StackedView<SignUpViewModel> {
  const SignUpView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    SignUpViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        key: viewModel.scaffoldKey,
        backgroundColor: kcWhite,
        bottomNavigationBar: Container(
          padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "* By signing up means you agree our teams & conditions",
                style: Theme.of(context)
                    .primaryTextTheme
                    .bodySmall!
                    .copyWith(color: kcLightGrey, fontSize: 10),
              ),
              const Divider(),
              Center(
                child: RichText(
                    text: TextSpan(
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: kcBlack),
                        children: <TextSpan>[
                      const TextSpan(
                        text: "Already have an account ? ",
                      ),
                      TextSpan(
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: kcPrimaryColorDark,
                                  fontWeight: FontWeight.bold),
                          text: "Sign in",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => viewModel.goBack())
                    ])),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: GestureDetector(
            onTap: () =>
                FocusScope.of(viewModel.scaffoldKey.currentContext!).unfocus(),
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    verticalSpace(screenHeight(context) * 0.05),
                    const Text(
                      "SIGN UP",
                      style: TextStyle(
                          fontSize: kMediumIconSize,
                          fontWeight: FontWeight.bold,
                          color: kcPrimaryColorDark),
                    ),
                    const Text("Please sign up to use the vault"),
                    spacedDivider,
                    CustomTextInputField(
                      controller: viewModel.nameTC,
                      focusNode: viewModel.nameFN,
                      hintText: "Name",
                      labelText: "Name",
                      onSubmit: (value) =>
                          FocusScope.of(viewModel.scaffoldKey.currentContext!)
                              .requestFocus(viewModel.mobileNoFN),
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                    ),
                    verticalSpaceMedium,
                    CustomTextInputField(
                      controller: viewModel.mobileNoTC,
                      focusNode: viewModel.mobileNoFN,
                      hintText: "Mobile No.",
                      labelText: "Mobile No.",
                      onSubmit: (value) =>
                          FocusScope.of(viewModel.scaffoldKey.currentContext!)
                              .requestFocus(viewModel.emailIdFN),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                    verticalSpaceMedium,
                    CustomTextInputField(
                      controller: viewModel.emailIdTC,
                      focusNode: viewModel.emailIdFN,
                      hintText: "Email Id",
                      labelText: "Email Id",
                      onSubmit: (value) =>
                          FocusScope.of(viewModel.scaffoldKey.currentContext!)
                              .requestFocus(viewModel.passwordFN),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    verticalSpaceMedium,
                    Focus(
                      child: CustomTextInputField(
                        controller: viewModel.passwordTC,
                        focusNode: viewModel.passwordFN,
                        hintText: "Password",
                        labelText: "Password",
                        obscureText: viewModel.isObscureText,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        suffixIcon: IconButton(
                          icon: Icon(viewModel.isObscureText
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () => viewModel.changeObsecureValue(),
                        ),
                        onSubmit: (value) =>
                            FocusScope.of(viewModel.scaffoldKey.currentContext!)
                                .requestFocus(viewModel.confirmPasswordFN),
                      ),
                      onFocusChange: (value) {
                        if (!viewModel.isObscureText) {
                          viewModel.changeObsecureValue();
                        }
                      },
                    ),
                    verticalSpaceMedium,
                    Focus(
                      child: CustomTextInputField(
                          controller: viewModel.confirmPasswordTC,
                          focusNode: viewModel.confirmPasswordFN,
                          hintText: "Confirm Password",
                          labelText: "Confirm Password",
                          obscureText: viewModel.isObscureTextCP,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                          suffixIcon: IconButton(
                            icon: Icon(viewModel.isObscureTextCP
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () => viewModel.changeObsecureCPValue(),
                          )),
                      onFocusChange: (value) {
                        if (!value && !viewModel.isObscureTextCP) {
                          viewModel.changeObsecureCPValue();
                        }
                      },
                    ),
                    verticalSpaceMedium,
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(40),
                      ),
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        viewModel.doSignUp();
                      },
                      child: const Text('Sign up'),
                    ),
                    verticalSpaceSmall,
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  @override
  SignUpViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SignUpViewModel();
}
