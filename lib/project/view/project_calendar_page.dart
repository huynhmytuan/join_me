import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/dummy_data.dart' as dummy_data;
import 'package:join_me/data/models/models.dart';
import 'package:join_me/project/components/task_card.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/utilities/extensions/extensions.dart';
import 'package:join_me/widgets/rounded_container.dart';
import 'package:join_me/widgets/selection_bottom_sheet.dart';
import 'package:table_calendar/table_calendar.dart';

enum DayFilter {
  filterByCreatedDate,
  filterByDueDate,
}

class ProjectCalendarPage extends StatefulWidget {
  const ProjectCalendarPage({
    required this.projectId,
    Key? key,
  }) : super(key: key);
  final String projectId;

  @override
  State<ProjectCalendarPage> createState() => _ProjectCalendarPageState();
}

class _ProjectCalendarPageState extends State<ProjectCalendarPage> {
  late List<Task> _tasks;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  DayFilter _dayFilter = DayFilter.filterByDueDate;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  void _getData() {
    _tasks = dummy_data.tasksData
        .where(
          (element) =>
              element.projectId == widget.projectId &&
              element.type == TaskType.task,
        )
        .toList();
  }

  List<Task> _onLoadEvent(DateTime day) {
    List<Task> tasksInDay;
    switch (_dayFilter) {
      case DayFilter.filterByCreatedDate:
        tasksInDay =
            _tasks.where((task) => isSameDay(task.createdAt, day)).toList();

        break;
      case DayFilter.filterByDueDate:
        tasksInDay =
            _tasks.where((task) => isSameDay(task.dueDate, day)).toList();

        break;
    }
    return tasksInDay;
  }

  List<Task> _loadDayTask() {
    List<Task> tasksInDay;
    switch (_dayFilter) {
      case DayFilter.filterByCreatedDate:
        tasksInDay = _tasks
            .where((task) => isSameDay(task.createdAt, _selectedDay))
            .toList();

        break;
      case DayFilter.filterByDueDate:
        tasksInDay = _tasks
            .where((task) => isSameDay(task.dueDate, _selectedDay))
            .toList();
        break;
    }
    return tasksInDay;
  }

  void _showFilterSelection() {
    showModalBottomSheet<dynamic>(
      useRootNavigator: true,
      barrierColor: Colors.black.withOpacity(0.5),
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        // <-- for border radius
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(kDefaultRadius),
          topRight: Radius.circular(kDefaultRadius),
        ),
      ),
      builder: (context) {
        return SelectionBottomSheet(
          title: 'Filter By',
          listSelections: [
            SelectionRow(
              onTap: () {
                setState(() {
                  _dayFilter = DayFilter.filterByCreatedDate;
                });
                AutoRouter.of(context).pop();
              },
              title: 'Created Day',
              iconData: Ionicons.create_outline,
            ),
            SelectionRow(
              onTap: () {
                setState(() {
                  _dayFilter = DayFilter.filterByDueDate;
                });
                AutoRouter.of(context).pop();
              },
              title: 'Due Day',
              iconData: Ionicons.calendar_number_outline,
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    final screenSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: SizedBox(
        width: screenSize.width,
        height: screenSize.height,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: kDefaultPadding,
                left: kDefaultPadding,
                right: kDefaultPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCalendar(context, languageCode),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: kDefaultPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Day's Task",
                          style: CustomTextStyle.heading2(context),
                        ),
                        GestureDetector(
                          onTap: _showFilterSelection,
                          child: Row(
                            children: [
                              Text('${_dayFilter.name} '),
                              const Icon(Ionicons.filter),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  _buildListTodayTasks(languageCode),
                ],
              ),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: (!isSameDay(_selectedDay, DateTime.now())) ? 1 : 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDay = DateTime.now();
                      _focusedDay = DateTime.now();
                    });
                  },
                  child: RoundedContainer(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      'Today',
                      style: CustomTextStyle.heading4(context).copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildCalendar(BuildContext context, String languageCode) {
    return Container(
      padding: const EdgeInsets.all(kDefaultPadding / 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6FA),
        borderRadius: BorderRadius.circular(kDefaultRadius),
      ),
      child: TableCalendar<Task>(
        pageJumpingEnabled: true,
        locale: languageCode,
        calendarFormat: _calendarFormat,
        startingDayOfWeek: StartingDayOfWeek.monday,
        availableCalendarFormats: const {
          CalendarFormat.month: 'Month',
          CalendarFormat.week: 'Week',
        },
        calendarBuilders: CalendarBuilders<Task>(
          singleMarkerBuilder: (context, day, task) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 1.5),
              height: 7, // for vertical axis
              width: 5, // for horizontal axis
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: task.priority.getColor(),
              ),
            );
          },
          selectedBuilder: (context, day, focusDay) => Container(
            margin: const EdgeInsets.all(1.5),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(kDefaultRadius),
            ),
            child: Center(
              child: Text(
                day.day.toString(),
                style: CustomTextStyle.heading3(context)
                    .copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
        calendarStyle: CalendarStyle(
          cellMargin: const EdgeInsets.all(1.5),
          todayDecoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(kDefaultRadius),
            border: Border.all(color: Theme.of(context).primaryColor),
          ),
          todayTextStyle: CustomTextStyle.bodyMedium(context),
        ),
        focusedDay: _focusedDay,
        firstDay: DateTime.utc(2010),
        lastDay: DateTime(2050),
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _focusedDay = focusedDay;
            _selectedDay = selectedDay;
          });
        },
        onPageChanged: (day) {
          _focusedDay = day;
        },
        eventLoader: _onLoadEvent,
      ),
    );
  }

  Expanded _buildListTodayTasks(String languageCode) {
    final tasks = _loadDayTask().toList();
    return Expanded(
      child: tasks.isEmpty
          ? const Text('No task in this day.')
          : Scrollbar(
              child: ListView.builder(
                itemCount: _loadDayTask().length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  final assignedTo = dummy_data.usersData
                      .where((user) => task.assignee.contains(user.id))
                      .toList();
                  return TaskCard(
                    task: task,
                    assignedTo: assignedTo,
                  );
                },
              ),
            ),
    );
  }
}
