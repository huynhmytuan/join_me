import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:join_me/config/theme.dart';

class CupertinoPickerBottomSheet extends StatefulWidget {
  const CupertinoPickerBottomSheet({
    Key? key,
    this.initialIndex,
    required this.childCount,
    this.onValueChange,
    required this.itemBuilder,
    required this.onSubmit,
    required this.itemExtent,
  }) : super(key: key);
  final int? initialIndex;
  final Function(int index)? onValueChange;
  final Function(int index) onSubmit;
  final int childCount;
  final double itemExtent;
  final Widget? Function(BuildContext, int) itemBuilder;

  @override
  State<CupertinoPickerBottomSheet> createState() =>
      _CupertinoPickerBottomSheetState();
}

class _CupertinoPickerBottomSheetState
    extends State<CupertinoPickerBottomSheet> {
  int selectedIndex = 0;
  @override
  void initState() {
    selectedIndex = widget.initialIndex ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => AutoRouter.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: CustomTextStyle.bodyMedium(context),
                ),
              ),
              TextButton(
                onPressed: () {
                  widget.onSubmit.call(selectedIndex);
                  AutoRouter.of(context).pop();
                },
                child: Text(
                  'Done',
                  style: CustomTextStyle.bodyMedium(context).copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          constraints: const BoxConstraints(
            maxHeight: 150,
          ),
          margin: const EdgeInsets.symmetric(vertical: 20),
          child: CupertinoPicker.builder(
            scrollController: FixedExtentScrollController(
              initialItem: widget.initialIndex ?? 0,
            ),
            itemExtent: widget.itemExtent,
            childCount: widget.childCount,
            onSelectedItemChanged: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            itemBuilder: widget.itemBuilder,
          ),
        ),
      ],
    );
  }
}
