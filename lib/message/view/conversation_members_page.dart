import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/app/bloc/app_bloc.dart';
import 'package:join_me/config/router/router.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/generated/locale_keys.g.dart';
import 'package:join_me/message/bloc/chat_bloc.dart';
import 'package:join_me/user/cubit/search_user_cubit.dart';
import 'package:join_me/widgets/bottom_sheet/selection_bottom_sheet.dart';
import 'package:join_me/widgets/widgets.dart';

class ConversationMembersPage extends StatelessWidget {
  const ConversationMembersPage({required this.chatBloc, Key? key})
      : super(key: key);
  final ChatBloc chatBloc;

  void _onUserTap(BuildContext context, AppUser user, AppUser currentUser) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SelectionBottomSheet(
        title: user.name,
        listSelections: [
          SelectionRow(
            onTap: () {
              AutoRouter.of(context).pop();
              AutoRouter.of(context).push(UserInfoRoute(userId: user.id));
            },
            title: LocaleKeys.button_viewUserPage.tr(),
            iconData: Icons.person_outline,
          ),
          if (currentUser.id ==
                  chatBloc.state.conversationViewModel.conversation.creator &&
              currentUser.id != user.id)
            SelectionRow(
              onTap: () {
                AutoRouter.of(context).pop();
                showDialog<bool>(
                  context: context,
                  builder: (context) => CustomAlertDialog(
                    title: LocaleKeys.dialog_removeMember_title.tr(),
                    content: LocaleKeys.dialog_removeMember_content.tr(),
                    submitButtonColor: Colors.red,
                    submitLabel: LocaleKeys.button_remove.tr(),
                    onCancel: () => AutoRouter.of(context).pop(false),
                    onSubmit: () => AutoRouter.of(context).pop(true),
                  ),
                ).then((value) {
                  if (value != null && value) {
                    chatBloc.add(RemoveMember(user));
                  }
                });
              },
              color: Colors.red,
              title: [
                LocaleKeys.button_remove.tr(),
                LocaleKeys.general_conversation.tr()
              ].join(' '),
              iconData: Icons.remove,
            )
          else if (currentUser.id == user.id)
            SelectionRow(
              onTap: () {
                showDialog<bool>(
                  context: context,
                  builder: (context) => CustomAlertDialog(
                    title: LocaleKeys.dialog_leave_title.tr(),
                    content: LocaleKeys.dialog_leave_content.tr(),
                    submitButtonColor: Colors.red,
                    submitLabel: LocaleKeys.button_leave.tr(),
                    onCancel: () => AutoRouter.of(context).pop(false),
                    onSubmit: () => AutoRouter.of(context).pop(true),
                  ),
                ).then((value) {
                  if (value != null && value) {
                    chatBloc.add(RemoveMember(currentUser));
                    //Pop and send value to tell chat page
                    //that member was leave.
                    AutoRouter.of(context).pop(true);
                  }
                });
              },
              color: Colors.red,
              title: [
                LocaleKeys.button_leave.tr(),
                LocaleKeys.general_conversation.tr()
              ].join(' '),
              iconData: Ionicons.log_out_outline,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AppBloc>().state.user;
    return BlocListener<ChatBloc, ChatState>(
      bloc: chatBloc,
      listener: (context, state) {
        if (state.status == ChatViewStatus.notFound ||
            !state.conversationViewModel.conversation.members
                .contains(currentUser.id)) {
          AutoRouter.of(context).popForced();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(LocaleKeys.general_members.tr()),
          leading: RoundedIconButton(
            icon: const Icon(Ionicons.chevron_back),
            onTap: () => AutoRouter.of(context).pop(),
          ),
          actions: [
            IconButton(
              onPressed: () {
                showDialog<AppUser>(
                  context: context,
                  builder: (context) => const AddUserDialog(),
                ).then((user) {
                  context.read<SearchUserCubit>().clearResults();
                  if (user != null) {
                    chatBloc.add(AddMember(user));
                  }
                });
              },
              splashRadius: 25,
              icon: const Icon(
                Icons.add,
                size: 30,
              ),
            )
          ],
        ),
        body: BlocBuilder<ChatBloc, ChatState>(
          bloc: chatBloc,
          builder: (context, state) {
            return ListView.builder(
              itemCount: state.conversationViewModel.members.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  onTap: () => _onUserTap(
                    context,
                    state.conversationViewModel.members[index],
                    currentUser,
                  ),
                  leading: CircleAvatarWidget(
                    imageUrl:
                        state.conversationViewModel.members[index].photoUrl,
                    size: 50,
                  ),
                  title: Text(
                    state.conversationViewModel.members[index].name,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
