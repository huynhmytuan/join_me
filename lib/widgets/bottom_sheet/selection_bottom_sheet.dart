import 'package:flutter/material.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/utilities/constant.dart';

class SelectionBottomSheet extends StatelessWidget {
  const SelectionBottomSheet({
    required this.title,
    required this.listSelections,
    Key? key,
  }) : super(key: key);
  final String title;
  final List<SelectionRow> listSelections;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            height: 5,
            width: 50,
            decoration: BoxDecoration(
              color: kIconColorGrey,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: kDefaultPadding,
              left: kDefaultPadding,
            ),
            child: Text(
              title,
              style: CustomTextStyle.heading3(context),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            kDefaultPadding,
            0,
            kDefaultPadding,
            40,
          ),
          child: ListView.separated(
            separatorBuilder: (context, index) => const Divider(),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: listSelections.length,
            itemBuilder: (context, index) => listSelections[index],
          ),
        ),
      ],
    );
  }
}

class SelectionRow extends StatelessWidget {
  const SelectionRow({
    required this.onTap,
    required this.title,
    required this.iconData,
    this.color,
    this.trailing,
    Key? key,
  }) : super(key: key);
  final String title;
  final IconData iconData;
  final Function onTap;
  final Color? color;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // ignore: avoid_dynamic_calls
      onTap: () => onTap.call(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(
              iconData,
              color: color,
              size: 24,
            ),
            const SizedBox(
              width: kDefaultPadding,
            ),
            Text(
              title,
              style: CustomTextStyle.heading4(context).copyWith(color: color),
            ),
            const Spacer(),
            trailing ?? const SizedBox(),
          ],
        ),
      ),
    );
  }
}
