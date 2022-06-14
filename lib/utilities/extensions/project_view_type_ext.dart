import 'package:easy_localization/easy_localization.dart';
import 'package:join_me/config/router/router.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/generated/locale_keys.g.dart';

extension ProjectViewTypeX on ProjectViewType {
  String toRouteName() {
    switch (this) {
      case ProjectViewType.dashBoard:
        return ProjectDashboardRoute.name;
      case ProjectViewType.listView:
        return ProjectTaskListRoute.name;
      case ProjectViewType.calendarView:
        return ProjectCalendarRoute.name;
      case ProjectViewType.unknown:
        return ProjectDashboardRoute.name;
    }
  }

  String toTitle() {
    switch (this) {
      case ProjectViewType.dashBoard:
        return LocaleKeys.projectViewType_dashboard.tr();
      case ProjectViewType.listView:
        return LocaleKeys.projectViewType_listView.tr();
      case ProjectViewType.calendarView:
        return LocaleKeys.projectViewType_calendarView.tr();
      case ProjectViewType.unknown:
        return 'Unknown';
    }
  }
}
