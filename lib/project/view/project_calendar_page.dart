import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/dummy_data.dart' as dummy_data;
import 'package:join_me/data/models/models.dart';
import 'package:join_me/project/components/stack_image.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:table_calendar/table_calendar.dart';

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

  List<Task> _loadDayTask() {
    return _tasks
        .where((task) => isSameDay(task.dueDate, _selectedDay))
        .toList();
  }

  Color _loadColorByPriority(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.none:
        return kTextColorGrey;

      case TaskPriority.low:
        return kSecondaryBlue;

      case TaskPriority.medium:
        return kSecondaryYellow;

      case TaskPriority.high:
        return kSecondaryRed;

      case TaskPriority.unknown:
        return kIconColorGrey;
    }
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCalendar(context, languageCode),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
            child: Text(
              "Day's Task",
              style: CustomTextStyle.heading2(context),
            ),
          ),
          _buildListTodayTasks(languageCode),
        ],
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
                color: _loadColorByPriority(task.priority),
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
        lastDay: DateTime.now(),
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
        eventLoader: (day) {
          final tasksInDay =
              _tasks.where((task) => isSameDay(task.dueDate, day)).toList();
          return tasksInDay;
        },
        // currentDay: currentDate  ?? focusedDay,
      ),
    );
  }

  Expanded _buildListTodayTasks(String languageCode) {
    return Expanded(
      child: Scrollbar(
        child: ListView.builder(
          itemCount: _loadDayTask().length,
          itemBuilder: (context, index) {
            final task = _loadDayTask().toList()[index];
            final assignedTo = dummy_data.usersData
                .where((user) => task.assignTo.contains(user.id))
                .toList();
            return Container(
              height: 100,
              padding: const EdgeInsets.fromLTRB(
                0,
                kDefaultPadding,
                kDefaultPadding,
                kDefaultPadding,
              ),
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [kDefaultBoxShadow],
                borderRadius: BorderRadius.circular(kDefaultRadius),
              ),
              child: Row(
                children: [
                  Container(
                    height: 57,
                    width: 10,
                    decoration: BoxDecoration(
                      color: _loadColorByPriority(
                        task.priority,
                      ),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(kDefaultRadius),
                        bottomRight: Radius.circular(kDefaultRadius),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: kDefaultPadding,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.name,
                          style: CustomTextStyle.heading3(context),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Ionicons.time,
                                  size: 17,
                                  color: kTextColorGrey,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  DateFormat.yMMMMEEEEd(languageCode)
                                      .format(task.dueDate),
                                  style: CustomTextStyle.heading4(context)
                                      .copyWith(
                                    color: kTextColorGrey,
                                  ),
                                ),
                              ],
                            ),
                            StackImage(
                              imageUrlList:
                                  assignedTo.map((e) => e.photoUrl).toList(),
                              imageSize: 24,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
