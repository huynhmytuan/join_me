import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/utilities/constant.dart';

class BottomTextField extends StatefulWidget {
  const BottomTextField({
    required this.textEditingController,
    required this.hintText,
    required this.onSubmit,
    this.onChange,
    Key? key,
  }) : super(key: key);
  final TextEditingController textEditingController;
  final String hintText;
  final Function(String value)? onChange;
  final Function onSubmit;
  @override
  State<BottomTextField> createState() => _BottomTextFieldState();
}

class _BottomTextFieldState extends State<BottomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(kDefaultRadius),
          topRight: Radius.circular(kDefaultRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              constraints: const BoxConstraints(
                maxHeight: 200,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(30),
              ),
              // height: 30,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: TextField(
                controller: widget.textEditingController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: widget.hintText,
                ),
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onChanged: widget.onChange,
              ),
            ),
          ),
          if (widget.textEditingController.text.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: IconButton(
                color: Theme.of(context).primaryColor,
                icon: const Icon(
                  Ionicons.paper_plane,
                ),
                onPressed: () => widget.onSubmit,
              ),
            ),
        ],
      ),
    );
  }
}
