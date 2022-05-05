import 'package:flutter/material.dart';
import 'package:join_me/utilities/constant.dart';

class RoundedTextField extends StatelessWidget {
  ///A custom rounded text field with some optional parameter.
  const RoundedTextField({
    this.height,
    this.width,
    this.prefixIcon,
    this.obscureText,
    this.suffix,
    Key? key,
    required this.screenSize,
    required this.label,
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.keyboardType,
    this.textInputAction,
  }) : super(key: key);

  final Size screenSize;
  final double? height;
  final double? width;
  final Widget? prefixIcon;
  final Widget? suffix;
  final bool? obscureText;
  final String label;
  final TextEditingController? controller;
  final Function(String value)? onSubmitted;
  final Function(String value)? onChanged;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 50,
      width: width,
      decoration: BoxDecoration(
        color: kBackgroundPostLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: kDividerColor,
        ),
      ),
      child: TextField(
        controller: controller,
        onSubmitted: (value) {
          onSubmitted?.call(value);
        },
        onChanged: (value) {
          onChanged?.call(value);
        },
        keyboardType: keyboardType,
        cursorColor: kPrimaryLightColor,
        obscureText: obscureText ?? false,
        textInputAction: textInputAction,
        decoration: InputDecoration(
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
          label: Text(label),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
