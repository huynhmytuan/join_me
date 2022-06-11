import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:join_me/config/router/router.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/utilities/extensions/task_priority_ext.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/utilities/constant.dart';

// ignore: must_be_immutable
class TaskListRow extends StatefulWidget {
  TaskListRow({
    required this.task,
    this.trailing,
    this.onChange,
    this.isShowPriorityColor = true,
    Key? key,
  }) : super(key: key);
  Task task;
  final Widget? trailing;
  final Function(bool?)? onChange;
  final bool isShowPriorityColor;

  @override
  State<TaskListRow> createState() => _TaskListRowState();
}

class _TaskListRowState extends State<TaskListRow> {
  bool isComplete = false;

  void _loadData() {
    isComplete = widget.task.isComplete;
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      radius: kDefaultRadius,
      borderRadius: BorderRadius.circular(kDefaultRadius),
      onTap: () {
        AutoRouter.of(context).push(SingleTaskRoute(taskId: widget.task.id));
      },
      child: Container(
        decoration: BoxDecoration(
          color: widget.isShowPriorityColor
              ? widget.task.priority.getColor().withOpacity(.7)
              : null,
          borderRadius: BorderRadius.circular(kDefaultRadius),
        ),
        child: Row(
          children: [
            Checkbox(
              value: widget.task.isComplete,
              onChanged: (value) {
                widget.onChange?.call(value);
                setState(() {
                  widget.task = widget.task.copyWith(isComplete: value);
                });
              },
            ),
            Expanded(
              child: Text(
                widget.task.name,
                style: CustomTextStyle.bodyMedium(context),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            if (widget.trailing != null)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: widget.trailing,
              )
          ],
        ),
      ),
    );
  }
}
