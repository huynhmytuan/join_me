import 'package:flutter/material.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/utilities/constant.dart';

extension TaskPriorityX on TaskPriority {
  Color getColor() {
    switch (this) {
      case TaskPriority.none:
        return kTextColorGrey;

      case TaskPriority.low:
        return kSecondaryGreen;

      case TaskPriority.medium:
        return kSecondaryYellow;

      case TaskPriority.high:
        return kSecondaryRed;

      case TaskPriority.unknown:
        return kIconColorGrey;
    }
  }

  String toTitle() {
    switch (this) {
      case TaskPriority.none:
        return 'None';

      case TaskPriority.low:
        return 'Low';

      case TaskPriority.medium:
        return 'Medium';

      case TaskPriority.high:
        return 'High';

      case TaskPriority.unknown:
        return 'Unknown';
    }
  }
}
