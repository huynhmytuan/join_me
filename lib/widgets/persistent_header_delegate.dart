import 'package:flutter/material.dart';
import 'package:join_me/utilities/constant.dart';

class PersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  const PersistentHeaderDelegate({
    required this.child,
  });
  final Widget child;
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: overlapsContent ? Theme.of(context).cardColor : null,
        boxShadow: (overlapsContent &&
                Theme.of(context).brightness == Brightness.light)
            ? kDefaultBoxShadow
            : null,
      ),
      height: 50,
      child: child,
    );
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
