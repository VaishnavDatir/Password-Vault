import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:password_vault/ui/common/custom_text_input_field.dart';
import 'package:password_vault/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';

import '../../common/app_colors.dart';
import 'login_viewmodel.dart';

class LoginView extends StackedView<LoginViewModel> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    LoginViewModel viewModel,
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
              spacedDivider,
              Center(
                child: RichText(
                    text: TextSpan(
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: kcBlack),
                        children: <TextSpan>[
                      const TextSpan(
                        text: "Don't have an account ? ",
                      ),
                      TextSpan(
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: kcPrimaryColorDark,
                                  fontWeight: FontWeight.bold),
                          text: "Sign up",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => viewModel.gotoSignUpScreen())
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
              padding: EdgeInsets.only(
                  left: 25,
                  right: 25,
                  top: screenHeight(context) * 0.15,
                  bottom: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "LOG IN",
                    style: TextStyle(
                        fontSize: kMediumIconSize,
                        fontWeight: FontWeight.bold,
                        color: kcPrimaryColorDark),
                  ),
                  const Text("Please sign in to continue"),
                  spacedDivider,
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
                  CustomTextInputField(
                      controller: viewModel.passwordTC,
                      focusNode: viewModel.passwordFN,
                      hintText: "Password",
                      labelText: "Password",
                      obscureText: viewModel.isObscureText,
                      suffixIcon: IconButton(
                        icon: Icon(viewModel.isObscureText
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () => viewModel.changeObsecureValue(),
                      )),
                  verticalSpaceMedium,
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () => viewModel.loginUser(),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(40),
                      ),
                      child: const Text('Login'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  @override
  LoginViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      LoginViewModel();
}
