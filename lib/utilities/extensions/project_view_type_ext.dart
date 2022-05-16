import 'package:join_me/config/router/router.dart';
import 'package:join_me/data/models/models.dart';

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
        return 'Dashboard';
      case ProjectViewType.listView:
        return 'List View';
      case ProjectViewType.calendarView:
        return 'Calendar View';
      case ProjectViewType.unknown:
        return 'Unknown';
    }
  }
}
