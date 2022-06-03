import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:join_me/app/blocs/app_bloc.dart';
import 'package:join_me/config/router/app_router.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/data/repositories/project_repository.dart';

class CheckIsProjectMember extends AutoRouteGuard {
  Future<bool> checkIsProjectMember(
    String projectId,
    AppUser currentUser,
  ) async {
    final project = await ProjectRepository().getProjectById(projectId).first;
    return project!.members.contains(currentUser.id);
  }

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final context = router.navigatorKey.currentContext;

    final projectId = resolver.route.pathParams.getString('projectId');

    final isMember = await checkIsProjectMember(
      projectId,
      context!.read<AppBloc>().state.user,
    );
    if (isMember) {
      resolver.next();
    } else {
      await router.push(SingleProjectGuestViewRoute(projectId: projectId));
    }
  }
}
