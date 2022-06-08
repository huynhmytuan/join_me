import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/app/bloc/app_bloc.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/data/repositories/project_repository.dart';
import 'package:join_me/utilities/constant.dart';

class AddProjectInviteDialog extends StatefulWidget {
  const AddProjectInviteDialog({Key? key}) : super(key: key);

  @override
  State<AddProjectInviteDialog> createState() => _AddProjectInviteDialogState();
}

class _AddProjectInviteDialogState extends State<AddProjectInviteDialog> {
  late AppUser _currentUser;
  late List<Project> _userProjects;
  List<Project> _projects = [];
  late TextEditingController _textEditingController;
  final _projectRepository = ProjectRepository();
  bool isLoading = true;

  void _onSearching() {
    final searchQuery = _textEditingController.text..toLowerCase();
    setState(() {
      _projects = List<Project>.from(
        _userProjects
            .where((pro) => pro.name.toLowerCase().contains(searchQuery))
            .toList(),
      );
    });
  }

  @override
  void initState() {
    _textEditingController = TextEditingController()..addListener(_onSearching);
    SchedulerBinding.instance!.addPostFrameCallback((_) async {
      _currentUser = context.read<AppBloc>().state.user;
      _userProjects =
          await _projectRepository.getUserProjects(_currentUser.id).first;
      _projects = List<Project>.from(_userProjects);
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: kBorderRadiusShape,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ProjectSearchInput(
                  textEditingController: _textEditingController,
                ),
                if (isLoading)
                  const SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Center(
                      child: Text('Loading...'),
                    ),
                  )
                else
                  _ProjectList(
                    projects: _projects,
                  ),
              ],
            ),
          ),
          Positioned(
            bottom: -50,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  size: 16,
                  color: kTextColorGrey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectList extends StatelessWidget {
  const _ProjectList({
    required this.projects,
    Key? key,
  }) : super(key: key);
  final List<Project> projects;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 10),
        itemCount: projects.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) => ListTile(
          onTap: () {
            AutoRouter.of(context).pop(projects[index]);
          },
          dense: true,
          title: Text(
            projects[index].name,
            style: CustomTextStyle.heading4(context),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Ionicons.people_outline,
                size: 12,
              ),
              Text(
                projects[index].members.length.toString(),
                style: CustomTextStyle.subText(context),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectSearchInput extends StatelessWidget {
  const _ProjectSearchInput({
    required this.textEditingController,
    Key? key,
  }) : super(key: key);
  final TextEditingController textEditingController;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? kTextFieldLightColor
            : kTextFieldDarkColor,
        borderRadius: BorderRadius.circular(kDefaultRadius),
      ),
      child: Row(
        children: [
          const Icon(
            Ionicons.search,
            color: kTextColorGrey,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: TextField(
              controller: textEditingController,
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'Search for project name...',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
