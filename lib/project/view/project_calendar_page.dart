import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/project/components/task_card.dart';
import 'package:join_me/task/bloc/tasks_overview_bloc.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/utilities/extensions/extensions.dart';
import 'package:join_me/widgets/bottom_sheet/selection_bottom_sheet.dart';
import 'package:join_me/widgets/handlers/empty_handler_widget.dart';
import 'package:join_me/widgets/rounded_container.dart';
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
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  DayFilter _dayFilter = DayFilter.filterByDueDate;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  List<Task> _onLoadEvent(DateTime day, List<Task> tasks) {
    List<Task> tasksInDay;
    switch (_dayFilter) {
      case DayFilter.filterByCreatedDate:
        tasksInDay =
            tasks.where((task) => isSameDay(task.createdAt, day)).toList();

        break;
      case DayFilter.filterByDueDate:
        tasksInDay =
            tasks.where((task) => isSameDay(task.dueDate, day)).toList();

        break;
    }
    return tasksInDay;
  }

  List<TaskViewModel> _loadDayTask(List<TaskViewModel> tasks) {
    List<TaskViewModel> tasksInDay;
    switch (_dayFilter) {
      case DayFilter.filterByCreatedDate:
        tasksInDay = tasks
            .where((taskVM) => isSameDay(taskVM.task.createdAt, _selectedDay))
            .toList();

        break;
      case DayFilter.filterByDueDate:
        tasksInDay = tasks
            .where((taskVM) => isSameDay(taskVM.task.dueDate, _selectedDay))
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;

    return BlocBuilder<TasksOverviewBloc, TasksOverviewState>(
      builder: (context, state) {
        if (state is TasksOverviewLoading) {
          return const CircularProgressIndicator();
        }
        if (state is TasksOverviewLoadSuccess) {
          return Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: kDefaultPadding,
                    left: kDefaultPadding,
                    right: kDefaultPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCalendar(
                        context,
                        languageCode,
                        state.tasks.map((task) => task.task).toList(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: kDefaultPadding,
                        ),
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
                      _buildListTodayTasks(
                        languageCode,
                        state.tasks,
                      ),
                    ],
                  ),
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
          );
        }
        return const Center(
          child: Text('Something went wrong'),
        );
      },
    );
  }

  Container _buildCalendar(
    BuildContext context,
    String languageCode,
    List<Task> tasks,
  ) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? kIconColorGrey.withOpacity(.4)
            : Theme.of(context).cardColor,
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
              height: 7,
              width: 5,
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
        eventLoader: (day) => _onLoadEvent(day, tasks),
      ),
    );
  }

  Expanded _buildListTodayTasks(
    String languageCode,
    List<TaskViewModel> tasks,
  ) {
    final dayTasks = _loadDayTask(tasks);
    return Expanded(
      child: dayTasks.isEmpty
          ? Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.width * .2,
              ),
              child: EmptyHandlerWidget(
                size: MediaQuery.of(context).size.width * .3,
                imageHandlerDir: kNoDayTaskPicDir,
                textHandler: 'No task in this day.',
              ),
            )
          : Scrollbar(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: dayTasks.length,
                itemBuilder: (context, index) {
                  final taskViewModel = dayTasks[index];
                  return TaskCard(
                    key: UniqueKey(),
                    task: taskViewModel.task,
                    assignedTo: taskViewModel.assignee,
                  );
                },
              ),
            ),
    );
  }
}
