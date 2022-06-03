import 'package:flutter/material.dart';

class ExpandedText extends StatefulWidget {
  const ExpandedText({
    required this.text,
    this.duration,
    this.curve,
    Key? key,
  }) : super(key: key);
  final String text;
  final Duration? duration;
  final Curve? curve;

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
    if (secondHaft == '') {
      return;
    }
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
    return GestureDetector(
      onTap: _expandToggle,
      child: Container(
        child: (secondHaft == '')
            ? Text(
                firstHaft,
              )
            : AnimatedSize(
                duration: widget.duration ?? const Duration(milliseconds: 700),
                curve: widget.curve ?? Curves.fastLinearToSlowEaseIn,
                alignment: Alignment.topLeft,
                child: Wrap(
                  children: [
                    Text(
                      isExpanded ? widget.text : '$firstHaft...',
                    ),
                    AnimatedOpacity(
                      duration:
                          widget.duration ?? const Duration(milliseconds: 700),
                      opacity: isExpanded ? 0 : 1,
                      child: isExpanded
                          ? null
                          : Text(
                              'Read more',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
