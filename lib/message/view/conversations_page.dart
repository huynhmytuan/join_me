import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/app/bloc/app_bloc.dart';
import 'package:join_me/config/router/app_router.dart';
import 'package:join_me/config/theme.dart';

import 'package:join_me/message/bloc/conversations_bloc.dart';
import 'package:join_me/message/components/components.dart';
import 'package:join_me/utilities/constant.dart';

class ConversationsPage extends StatefulWidget {
  const ConversationsPage({Key? key}) : super(key: key);

  @override
  State<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverAppBar(
              // pinned: true,
              floating: true,
              snap: true,
              title: const Text('Messages'),
              expandedHeight: 100,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  height: 30,
                  padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding,
                    vertical: kDefaultPadding / 2,
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(kDefaultRadius),
                      radius: kDefaultRadius,
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(.2),
                          borderRadius: BorderRadius.circular(kDefaultRadius),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Ionicons.search_outline,
                              size: 20,
                              color: kTextColorGrey,
                            ),
                            const SizedBox(
                              width: kDefaultPadding / 2,
                            ),
                            Text(
                              'Search Something',
                              style: CustomTextStyle.bodyMedium(context)
                                  .copyWith(color: kTextColorGrey),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: const _ConversationsListView(),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'new_message',
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // <-- Radius
        ),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          AutoRouter.of(context).push(const NewChatRoute());
        },
        child: const Icon(
          Ionicons.create_outline,
          size: 30,
        ),
      ),
    );
  }
}

class _ConversationsListView extends StatelessWidget {
  const _ConversationsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _currentUser = context.read<AppBloc>().state.user;
    return BlocBuilder<ConversationsBloc, ConversationsState>(
      bloc: context.read<ConversationsBloc>()
        ..add(FetchConversations(_currentUser.id)),
      builder: (context, state) {
        return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          itemCount: state.conversations.length,
          itemBuilder: (context, index) {
            return ConversationCard(
              conversationViewModel: state.conversations[index],
              currentUser: _currentUser,
            );
          },
        );
      },
    );
  }
}
