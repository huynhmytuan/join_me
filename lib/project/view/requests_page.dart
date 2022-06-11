import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/config/router/app_router.dart';
import 'package:join_me/data/models/app_user.dart';
import 'package:join_me/data/repositories/repositories.dart';
import 'package:join_me/generated/locale_keys.g.dart';
import 'package:join_me/project/bloc/join_requests_bloc.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/avatar_circle_widget.dart';
import 'package:join_me/widgets/rounded_button.dart';

class RequestsPage extends StatelessWidget {
  const RequestsPage({
    required this.projectId,
    Key? key,
  }) : super(key: key);
  final String projectId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => JoinRequestsBloc(
        projectRepository: context.read<ProjectRepository>(),
        userRepository: context.read<UserRepository>(),
      )..add(LoadRequests(projectId)),
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => AutoRouter.of(context).pop(),
            child: const Icon(Ionicons.chevron_back),
          ),
          title: Text(LocaleKeys.project_joinRequest.tr()),
        ),
        body: _RequestsView(projectId: projectId),
      ),
    );
  }
}

class _RequestsView extends StatelessWidget {
  const _RequestsView({
    Key? key,
    required this.projectId,
  }) : super(key: key);

  final String projectId;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<JoinRequestsBloc>().add(LoadRequests(projectId));
      },
      child: BlocBuilder<JoinRequestsBloc, JoinRequestsState>(
        builder: (context, state) {
          if (state.status == JoinRequestsStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.status == JoinRequestsStatus.failure) {
            return const Center(
              child: Text('Failure'),
            );
          }
          return ListView.separated(
            clipBehavior: Clip.none,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            itemBuilder: (context, index) => _RequestCard(
              requester: state.requesters.elementAt(index),
            ),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: state.requesters.length,
          );
        },
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.requester, Key? key}) : super(key: key);
  final AppUser requester;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () => AutoRouter.of(context).push(
            UserInfoRoute(userId: requester.id),
          ),
          leading: CircleAvatarWidget(
            imageUrl: requester.photoUrl,
            size: 35,
          ),
          title: Text(requester.name),
          subtitle: Text(requester.email),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RoundedButton(
              onPressed: () {
                context
                    .read<JoinRequestsBloc>()
                    .add(RejectRequest(requester.id));
              },
              color: kIconColorGrey,
              elevation: 0,
              height: 30,
              child: Text(
                LocaleKeys.button_request_decline.tr(),
                style: const TextStyle(color: Colors.black),
              ),
            ),
            RoundedButton(
              onPressed: () {
                context
                    .read<JoinRequestsBloc>()
                    .add(AcceptRequest(requester.id));
              },
              elevation: 0,
              height: 30,
              child: Text(
                LocaleKeys.button_request_accept.tr(),
              ),
            ),
          ],
        )
      ],
    );
  }
}
