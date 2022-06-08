import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:join_me/app/bloc/app_bloc.dart';
import 'package:join_me/config/router/app_router.dart';
import 'package:join_me/project/bloc/project_overview_bloc.dart';

import 'package:join_me/project/components/components.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({Key? key}) : super(key: key);

  void _showNewProjectDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => const NewProjectDialog(),
    );
  }

  void _loadData(BuildContext context) {
    final currentUserId = context.read<AppBloc>().state.user.id;
    context.read<ProjectOverviewBloc>().add(
          LoadProjects(currentUserId),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            const SliverAppBar(
              elevation: 0,
              title: Text('My Projects'),
            ),
          ];
        },
        body: RefreshIndicator(
          onRefresh: () async {
            _loadData(context);
          },
          child: const _ProjectListView(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'new_project',
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // <-- Radius
        ),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => _showNewProjectDialog(context),
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
    );
  }
}

class _ProjectListView extends StatelessWidget {
  const _ProjectListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProjectOverviewBloc, ProjectOverviewState>(
      listener: (context, state) {
        if (state is NewProjectCreated) {
          AutoRouter.of(context)
              .push(SingleProjectRoute(projectId: state.project.id));
        }
      },
      builder: (context, state) {
        if (state is ProjectsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is ProjectsLoaded) {
          return state.projects.isNotEmpty
              ? ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: state.projects.length,
                  itemBuilder: (context, index) {
                    return ProjectCard(
                      project: state.projects[index].project,
                      users: state.projects[index].members,
                      tasks: state.projects[index].tasks,
                    );
                  },
                )
              : const Center(
                  child: Text('No project.'),
                );
        }
        return const Center(
          child: Text('Something went wrong.'),
        );
      },
    );
  }
}
