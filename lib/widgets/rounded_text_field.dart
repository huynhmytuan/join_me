import 'package:flutter/material.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/utilities/constant.dart';

class RoundedTextField extends StatelessWidget {
  ///A custom rounded text field with some optional parameter.
  const RoundedTextField({
    this.height,
    this.width,
    this.prefixIcon,
    this.obscureText,
    this.suffix,
    required this.screenSize,
    this.label,
    this.hintText,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.trailing,
    Key? key,
  }) : super(key: key);

  final Size screenSize;
  final double? height;
  final double? width;
  final Widget? prefixIcon;
  final Widget? suffix;
  final bool? obscureText;
  final String? label;
  final String? hintText;
  final String? errorText;
  final TextEditingController? controller;
  final Function(String value)? onSubmitted;
  final Function(String value)? onChanged;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: width,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? kTextFieldLightColor
                : kTextFieldDarkColor,
            borderRadius: BorderRadius.circular(kDefaultRadius),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  onSubmitted: (value) {
                    onSubmitted?.call(value);
                  },
                  onChanged: (value) {
                    onChanged?.call(value);
                  },
                  keyboardType: keyboardType,
                  cursorColor: Theme.of(context).primaryColor,
                  obscureText: obscureText ?? false,
                  textInputAction: textInputAction,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: label,
                    border: InputBorder.none,
                    floatingLabelStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    prefixIcon: prefixIcon ??
                        const SizedBox.square(
                          dimension: 20,
                        ),
                    prefixIconConstraints: (prefixIcon == null)
                        ? BoxConstraints.loose(const Size.square(20))
                        : null,
                    suffix: suffix,
                    hintText: hintText,
                    contentPadding: const EdgeInsets.only(top: 12),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: trailing != null
                        ? Material(
                            color: Colors.transparent,
                            clipBehavior: Clip.hardEdge,
                            borderRadius: BorderRadius.circular(30),
                            child: trailing,
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: kDefaultPadding),
            child: Text(
              errorText!,
              style: CustomTextStyle.bodySmall(context)
                  .copyWith(color: Theme.of(context).errorColor),
            ),
          ),
      ],
    );
  }
}
