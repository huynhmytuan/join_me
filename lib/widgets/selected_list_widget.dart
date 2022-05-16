import 'package:flutter/material.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/widgets/rounded_container.dart';

class SelectedListWidget extends StatefulWidget {
  const SelectedListWidget({
    required this.selectionTitles,
    this.onSelection,
    this.initIndex,
    Key? key,
  }) : super(key: key);

  final List<String> selectionTitles;
  final Function(int index, String selectedTitle)? onSelection;
  final int? initIndex;

  @override
  State<SelectedListWidget> createState() => _SelectedListWidgetState();
}

class _SelectedListWidgetState extends State<SelectedListWidget> {
  late int currentIndex;
  @override
  void initState() {
    currentIndex = widget.initIndex ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Material(
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          removeBottom: true,
          child: ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return const Divider(
                thickness: 1,
                indent: 20,
                endIndent: 20,
              );
            },
            itemCount: widget.selectionTitles.length,
            physics: const ScrollPhysics(),
            itemBuilder: (context, index) {
              return SelectedItem(
                onTap: () {
                  setState(() {
                    currentIndex = index;
                  });
                  widget.onSelection?.call(
                    currentIndex,
                    widget.selectionTitles[index],
                  );
                },
                title: widget.selectionTitles[index],
                isSelected: currentIndex == index,
              );
            },
          ),
        ),
      ),
    );
  }
}

class SelectedItem extends StatelessWidget {
  const SelectedItem({
    required this.title,
    this.isSelected = false,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final String title;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      enableFeedback: true,
      onTap: () {
        onTap?.call();
      },
      title: Text(
        title,
        style: CustomTextStyle.heading4(context),
      ),
      trailing: isSelected
          ? Icon(
              Icons.check,
              color: Theme.of(context).primaryColor,
            )
          : null,
    );
  }
}
