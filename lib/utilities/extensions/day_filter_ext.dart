import 'package:easy_localization/easy_localization.dart';
import 'package:join_me/generated/locale_keys.g.dart';
import 'package:join_me/project/view/view.dart';

extension DayFilterX on DayFilter {
  @override
  // ignore: override_on_non_overriding_member
  String get name {
    switch (this) {
      case DayFilter.filterByCreatedDate:
        return LocaleKeys.taskFilter_byCreatedDate_value.tr();

      case DayFilter.filterByDueDate:
        return LocaleKeys.taskFilter_byDueDate_value.tr();
    }
  }
}
