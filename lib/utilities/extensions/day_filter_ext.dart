import 'package:join_me/project/view/view.dart';

extension DayFilterX on DayFilter {
  @override
  // ignore: override_on_non_overriding_member
  String get name {
    switch (this) {
      case DayFilter.filterByCreatedDate:
        return 'Filter By Created Day';

      case DayFilter.filterByDueDate:
        return 'Filter By Due Day';
    }
  }
}
