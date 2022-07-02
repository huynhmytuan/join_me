import 'package:flutter/material.dart';

class ScaleUpWidget extends StatefulWidget {
  const ScaleUpWidget({
    Key? key,
    required this.scaleUpSize,
    required this.duration,
    required this.buildChild,
  }) : super(key: key);
  final double scaleUpSize;
  final Duration duration;
  final Widget Function(double sizeValue) buildChild;

  @override
  State<ScaleUpWidget> createState() => _ScaleUpWidgetState();
}

class _ScaleUpWidgetState extends State<ScaleUpWidget>
    with TickerProviderStateMixin {
  late Animation _animation;
  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 0, end: widget.scaleUpSize).animate(
      CurvedAnimation(curve: Curves.bounceOut, parent: _animationController),
    );
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) =>
          widget.buildChild.call(_animation.value as double),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
