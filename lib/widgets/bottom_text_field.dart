import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/utilities/constant.dart';

class BottomTextField extends StatefulWidget {
  const BottomTextField({
    required this.textEditingController,
    required this.hintText,
    required this.onSubmit,
    this.onChange,
    this.focusNode,
    this.submitIcon,
    this.leading,
    Key? key,
  }) : super(key: key);
  final TextEditingController textEditingController;
  final String hintText;
  final Function(String value)? onChange;
  final Function() onSubmit;
  final FocusNode? focusNode;
  final Icon? submitIcon;
  final List<Widget>? leading;
  @override
  State<BottomTextField> createState() => _BottomTextFieldState();
}

class _BottomTextFieldState extends State<BottomTextField> {
  String inputText = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(kDefaultRadius),
          topRight: Radius.circular(kDefaultRadius),
        ),
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (widget.leading != null && widget.leading!.isNotEmpty)
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: widget.leading!,
              ),
            Expanded(
              child: Container(
                constraints: const BoxConstraints(
                  maxHeight: 150,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light
                      ? kTextFieldLightColor
                      : kTextFieldDarkColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                margin: const EdgeInsets.all(3),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  style: CustomTextStyle.bodyMedium(context),
                  controller: widget.textEditingController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: widget.hintText,
                    isDense: true,
                    counterText: '',
                  ),
                  focusNode: widget.focusNode,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  maxLength: 1000,
                  onChanged: (value) {
                    widget.onChange?.call(value);
                    setState(() {});
                  },
                ),
              ),
            ),
            if (widget.textEditingController.text.trim().isNotEmpty)
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                child: IconButton(
                  visualDensity: VisualDensity.compact,
                  color: Theme.of(context).primaryColor,
                  splashRadius: 20,
                  icon: widget.submitIcon ??
                      const Icon(
                        Ionicons.paper_plane,
                      ),
                  onPressed: () {
                    widget.onSubmit.call();
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
