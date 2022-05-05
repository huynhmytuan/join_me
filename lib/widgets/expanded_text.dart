import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class ExpandedText extends StatefulWidget {
  const ExpandedText({
    required this.text,
    Key? key,
  }) : super(key: key);
  final String text;

  @override
  State<ExpandedText> createState() => _ExpandedTextState();
}

class _ExpandedTextState extends State<ExpandedText> {
  late String firstHaft;
  late String secondHaft;
  bool isExpanded = false;
  void _splitText() {
    if (widget.text.length > 100) {
      firstHaft = widget.text.substring(0, 100);
      secondHaft = widget.text.substring(100);
    } else {
      firstHaft = widget.text;
      secondHaft = '';
    }
  }

  void _expandToggle() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  void initState() {
    _splitText();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: (secondHaft == '')
          ? Text(
              firstHaft,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isExpanded ? widget.text : '$firstHaft...'),
                TextButton(
                  onPressed: _expandToggle,
                  child: Row(
                    children: [
                      Text(isExpanded ? 'show less' : 'show more'),
                      Icon(
                        isExpanded
                            ? Ionicons.chevron_up
                            : Ionicons.chevron_down,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
