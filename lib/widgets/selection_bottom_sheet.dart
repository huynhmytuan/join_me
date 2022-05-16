import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
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
        const Align(
          alignment: Alignment.topCenter,
          child: Icon(
            Ionicons.remove,
            size: 40,
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
            kDefaultPadding,
          ),
          child: ListView.separated(
            separatorBuilder: (context, index) => const Divider(
              indent: kDefaultPadding,
              endIndent: kDefaultPadding,
            ),
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
    Key? key,
  }) : super(key: key);
  final String title;
  final IconData iconData;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // ignore: avoid_dynamic_calls
      onTap: () => onTap.call(),
      child: Row(
        children: [
          Icon(iconData),
          const SizedBox(
            width: kDefaultPadding,
          ),
          Text(
            title,
            style: CustomTextStyle.heading3(context),
          ),
        ],
      ),
    );
  }
}
