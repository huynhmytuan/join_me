import 'package:join_me/project/view/view.dart';

extension DayFilterX on DayFilter {
  @override
  String get name {
    switch (this) {
      case DayFilter.filterByCreatedDate:
        return 'Filter By Created Day';

      case DayFilter.filterByDueDate:
        return 'Filter By Due Day';
    }
  }
}
