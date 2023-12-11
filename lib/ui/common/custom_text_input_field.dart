import 'package:flutter/material.dart';
import 'package:password_vault/ui/common/app_colors.dart';
import 'package:password_vault/ui/common/ui_helpers.dart';

class CustomTextInputField extends StatelessWidget {
  final String? hint;
  final String hintText;
  final TextEditingController controller;
  final IconButton? iconButton;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextCapitalization textCapitalization;
  final Function? onSubmit;
  final Function? onChanged;
  final Function? onTap;
  final int? maxLength;
  final int? maxLines;
  final bool disabled;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final bool addContentPadding;
  final String labelText;

  const CustomTextInputField({
    Key? key,
    this.hint,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.iconButton,
    this.prefixIcon,
    this.suffixIcon,
    this.onSubmit,
    this.onTap,
    this.onChanged,
    this.maxLength,
    this.maxLines,
    this.textCapitalization = TextCapitalization.none,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.disabled = false,
    this.focusNode,
    this.addContentPadding = false,
    this.labelText = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      onSubmitted: onSubmit as void Function(String)?,
      onChanged: onChanged as void Function(String)?,
      maxLines: obscureText ? 1 : maxLines,
      maxLength: maxLength,
      readOnly: disabled,
      cursorColor: kcPrimaryColor,
      style: Theme.of(context).textTheme.bodySmall,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      onTap: onTap as void Function()?,
      decoration: InputDecoration(
        contentPadding: addContentPadding
            ? const EdgeInsets.symmetric(
                vertical: kSmallSpace, horizontal: kSmallSpace * 3)
            : null,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintText: hintText,
        labelText: labelText.isEmpty ? null : labelText,
        border: const OutlineInputBorder(
            borderSide: BorderSide(color: kcMediumGrey)),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: kcMediumGrey),
        ),
        focusedBorder: disabled
            ? const OutlineInputBorder(
                borderSide: BorderSide(color: kcMediumGrey))
            : const OutlineInputBorder(
                borderSide: BorderSide(color: kcPrimaryColorDark)),
      ),
    );
  }
}
