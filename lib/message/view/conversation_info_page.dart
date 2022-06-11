import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import 'package:join_me/app/bloc/app_bloc.dart';
import 'package:join_me/config/router/router.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/generated/locale_keys.g.dart';
import 'package:join_me/message/bloc/chat_bloc.dart';
import 'package:join_me/message/components/conversation_avatar.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/widgets.dart';

class ConversationInfoPage extends StatelessWidget {
  const ConversationInfoPage({required this.chatBloc, Key? key})
      : super(key: key);
  final ChatBloc chatBloc;

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AppBloc>().state.user;
    final appLocale = Localizations.localeOf(context);
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
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? kBackgroundPostLight
            : null,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? kBackgroundPostLight
              : Theme.of(context).scaffoldBackgroundColor,
          leading: RoundedIconButton(
            icon: const Icon(Ionicons.chevron_back),
            onTap: () => AutoRouter.of(context).pop(),
          ),
        ),
        body: BlocBuilder<ChatBloc, ChatState>(
          bloc: chatBloc,
          builder: (context, state) {
            if (state.conversationViewModel.members.isEmpty) {
              return const SizedBox();
            }
            final creator = state.conversationViewModel.members.firstWhere(
              (element) =>
                  element.id ==
                  state.conversationViewModel.conversation.creator,
            );
            final receivers = List.of(state.conversationViewModel.members)
              ..removeWhere((e) => e.id == currentUser.id);
            String name;
            if (receivers.length == 1) {
              name = receivers.first.name;
            } else if (receivers.length <= 4) {
              name = receivers
                  .map((e) => e.name.split(' ')[0])
                  .toList()
                  .join(', ');
            } else {
              name =
                  '${receivers.map((e) => e.name.split(' ')[0]).toList().take(4).join(', ')}...';
            }
            return Column(
              children: [
                const SizedBox(
                  height: kDefaultPadding,
                ),
                Align(
                  child: ConversationAvatar(
                    receivers: receivers,
                    size: 100,
                  ),
                ),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                Text(
                  name,
                  style: CustomTextStyle.heading2(context),
                ),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * .2,
                  ),
                  child: Text(
                    '${creator.id == currentUser.id ? LocaleKeys.general_you.tr() : creator.name} ${LocaleKeys.general_start.tr()} ${LocaleKeys.general_conversation.tr().toLowerCase()} ${LocaleKeys.general_from.tr()} \n${DateFormat.yMMMMEEEEd(appLocale.languageCode).format(
                      state.conversationViewModel.conversation.createdAt,
                    )}',
                    textAlign: TextAlign.center,
                    style: CustomTextStyle.heading4(context),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                RoundedContainer(
                  margin: const EdgeInsets.all(kDefaultPadding),
                  width: double.infinity,
                  color: Theme.of(context).cardColor,
                  child: Column(
                    children: [
                      if (state.conversationViewModel.conversation.type ==
                          ConversationType.directMessage)
                        _ActionRowButton(
                          onPressed: () {
                            AutoRouter.of(context).push(
                              UserInfoRoute(userId: receivers.first.id),
                            );
                          },
                          iconData: Icons.person,
                          label: LocaleKeys.button_viewUserPage.tr(),
                        ),
                      if (state.conversationViewModel.conversation.type ==
                          ConversationType.group)
                        _ActionRowButton(
                          onPressed: () {
                            AutoRouter.of(context)
                                .push(
                              ConversationMembersRoute(chatBloc: chatBloc),
                            )
                                .then((value) {
                              if (value != null && (value as bool)) {
                                AutoRouter.of(context).pop(true);
                              }
                            });
                          },
                          label: LocaleKeys.general_members.tr(),
                          iconData: Ionicons.people_outline,
                        ),
                      if (state.conversationViewModel.conversation.type ==
                              ConversationType.group &&
                          state.conversationViewModel.conversation.creator ==
                              currentUser.id)
                        Column(
                          children: [
                            const Divider(),
                            _ActionRowButton(
                              onPressed: () {
                                //Delete
                                showDialog<bool>(
                                  context: context,
                                  builder: (context) => CustomAlertDialog(
                                    title: LocaleKeys.dialog_delete_title.tr(),
                                    content:
                                        LocaleKeys.dialog_delete_content.tr(),
                                    submitButtonColor: Colors.red,
                                    submitLabel: LocaleKeys.button_delete.tr(),
                                    onCancel: () =>
                                        AutoRouter.of(context).pop(false),
                                    onSubmit: () =>
                                        AutoRouter.of(context).pop(true),
                                  ),
                                ).then((value) {
                                  if (value != null && value) {
                                    chatBloc.add(DeleteConversation());
                                    AutoRouter.of(context).pop(true);
                                  }
                                });
                              },
                              color: Colors.red,
                              iconData: Icons.delete_outline,
                              label:
                                  '${LocaleKeys.button_delete.tr()} ${LocaleKeys.general_conversation.tr()}',
                            ),
                          ],
                        ),
                      if (state.conversationViewModel.conversation.type ==
                              ConversationType.group &&
                          state.conversationViewModel.conversation.creator !=
                              currentUser.id)
                        Column(
                          children: [
                            const Divider(),
                            _ActionRowButton(
                              onPressed: () {
                                //Leave
                                showDialog<bool>(
                                  context: context,
                                  builder: (context) => CustomAlertDialog(
                                    title:
                                        '${LocaleKeys.dialog_leave_title.tr()} ${LocaleKeys.general_conversation.tr()}?',
                                    content:
                                        LocaleKeys.dialog_leave_content.tr(),
                                    submitButtonColor: Colors.red,
                                    submitLabel: LocaleKeys.button_leave.tr(),
                                    onCancel: () =>
                                        AutoRouter.of(context).pop(false),
                                    onSubmit: () =>
                                        AutoRouter.of(context).pop(true),
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
                              iconData: Ionicons.log_out_outline,
                              label:
                                  '${LocaleKeys.dialog_leave_title.tr()} ${LocaleKeys.general_conversation.tr()}',
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ActionRowButton extends StatelessWidget {
  const _ActionRowButton({
    Key? key,
    required this.onPressed,
    required this.label,
    required this.iconData,
    this.color,
  }) : super(key: key);
  final Function() onPressed;
  final String label;
  final IconData iconData;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        shape: kBorderRadiusShape,
        onTap: onPressed,
        leading: Icon(
          iconData,
          color: color,
          size: 30,
        ),
        title: Text(
          label,
          style: CustomTextStyle.heading4(context).copyWith(color: color),
        ),
      ),
    );
  }
}
