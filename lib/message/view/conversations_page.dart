import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/app/bloc/app_bloc.dart';
import 'package:join_me/config/router/app_router.dart';
import 'package:join_me/generated/locale_keys.g.dart';

import 'package:join_me/message/bloc/conversations_bloc.dart';
import 'package:join_me/message/components/components.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/handlers/empty_handler_widget.dart';

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
      appBar: AppBar(
        title: Text(LocaleKeys.appBarTitle_messages.tr()),
      ),
      body: const _ConversationsListView(),
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
        if (state.conversations.isEmpty) {
          return EmptyHandlerWidget(
            size: MediaQuery.of(context).size.width * .5,
            imageHandlerDir: kNoMessagePicDir,
            titleHandler: LocaleKeys.emptyHandler_noMessage_title.tr(),
            textHandler: LocaleKeys.emptyHandler_noMessage_content.tr(),
          );
        }
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
