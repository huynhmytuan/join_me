import 'package:auto_route/auto_route.dart';
import 'package:join_me/config/router/app_router.dart';
import 'package:join_me/data/repositories/post_repository.dart';

class CheckIfPostExists extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final postId = resolver.route.pathParams.getString('postId');
    final post = await PostRepository().getPostById(postId: postId).first;
    if (post != null) {
      resolver.next();
    } else {
      await router.push(const NotFoundRoute());
    }
  }
}
