import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker({
    this.initialDay,
    this.firstDate,
    this.lastDate,
    Key? key,
  }) : super(key: key);
  final DateTime? initialDay;

  ///If no firstDate added, default value will be [DateTime.now()]
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  @override
  void initState() {
    _selectedDay = widget.initialDay;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    return Dialog(
      shape: kBorderRadiusShape,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    AutoRouter.of(context).pop(false);
                  },
                  child: Text(
                    'Cancel',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Text(
                  'Due date',
                  style: CustomTextStyle.heading3(context),
                ),
                TextButton(
                  onPressed: () {
                    AutoRouter.of(context).pop(_selectedDay);
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
            const Divider(),
            Stack(
              children: [
                Align(
                  child: Text(
                    _selectedDay == null
                        ? 'No date selected'
                        : DateFormat.yMMMd(languageCode).format(_selectedDay!),
                    style: CustomTextStyle.heading3(context)
                        .copyWith(color: Theme.of(context).primaryColor),
                  ),
                ),
                Positioned(
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDay = null;
                      });
                    },
                    child: const Icon(Ionicons.close_circle),
                  ),
                ),
              ],
            ),
            const Divider(),
            Container(
              height: 350,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding / 2,
              ),
              child: TableCalendar<dynamic>(
                pageJumpingEnabled: true,
                shouldFillViewport: true,
                locale: languageCode,
                startingDayOfWeek: StartingDayOfWeek.monday,
                headerStyle: const HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                ),
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  cellMargin: const EdgeInsets.all(1.5),
                  selectedDecoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Theme.of(context).primaryColor),
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: kTextColorGrey),
                  ),
                  todayTextStyle: CustomTextStyle.bodyMedium(context),
                ),
                focusedDay: _focusedDay,
                firstDay: widget.firstDate ?? DateTime.now(),
                lastDay: widget.lastDate ?? DateTime(2100),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
