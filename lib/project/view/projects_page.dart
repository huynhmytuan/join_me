import 'package:flutter/material.dart';
import 'package:join_me/data/dummy_data.dart' as dummy_data;
import 'package:join_me/data/models/models.dart';
import 'package:join_me/project/components/components.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({Key? key}) : super(key: key);

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  List<Project> _projects = [];
  void _getProject() {
    const currentUser = dummy_data.currentUser;
    _projects = dummy_data.projectsData
        .where((proj) => proj.members.contains(currentUser.id))
        .toList();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _getProject();
    super.didChangeDependencies();
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
        body: (_projects.isNotEmpty)
            ? ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: _projects.length,
                itemBuilder: (context, index) {
                  return ProjectCard(project: _projects[index]);
                },
              )
            : const Center(
                child: Text('No data'),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'new_project',
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // <-- Radius
        ),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {},
        child: const Icon(
          Icons.note_add_outlined,
          size: 30,
        ),
      ),
    );
  }
}
