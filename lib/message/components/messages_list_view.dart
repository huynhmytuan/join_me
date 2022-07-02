import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/app/bloc/app_bloc.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/generated/locale_keys.g.dart';
import 'package:join_me/message/bloc/chat_bloc.dart';
import 'package:join_me/message/components/components.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/bottom_sheet/selection_bottom_sheet.dart';
import 'package:join_me/widgets/widgets.dart';

class MessagesListView extends StatefulWidget {
  const MessagesListView({required this.chatBloc, Key? key}) : super(key: key);
  final ChatBloc chatBloc;

  @override
  State<MessagesListView> createState() => _MessagesListViewState();
}

class _MessagesListViewState extends State<MessagesListView> {
  String messageIdShowingTime = '';
  void _showMoreDialog(
    Message message,
    AppUser currentUser,
  ) {
    showModalBottomSheet<ProjectViewType>(
      useRootNavigator: true,
      barrierColor: Colors.black.withOpacity(0.5),
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        // <-- for border radius
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(kDefaultRadius),
          topRight: Radius.circular(kDefaultRadius),
        ),
      ),
      builder: (context) {
        final _currentUser = context.read<AppBloc>().state.user;
        final isOwner = _currentUser.id == message.authorId;
        return SelectionBottomSheet(
          title: LocaleKeys.general_more.tr(),
          listSelections: [
            SelectionRow(
              onTap: () {
                Clipboard.setData(ClipboardData(text: message.content));
                AutoRouter.of(context).pop();
              },
              title: LocaleKeys.button_copy.tr(),
              iconData: Ionicons.copy_outline,
            ),
            if (isOwner)
              SelectionRow(
                onTap: () {
                  AutoRouter.of(context).pop().then(
                        (value) => showDialog<bool>(
                          context: context,
                          builder: (context) => CustomAlertDialog(
                            title: LocaleKeys.dialog_delete_title.tr(),
                            content: LocaleKeys.dialog_delete_content.tr(),
                            submitButtonColor: Theme.of(context).errorColor,
                            submitLabel: LocaleKeys.button_delete.tr(),
                            onCancel: () => AutoRouter.of(context).pop(false),
                            onSubmit: () => AutoRouter.of(context).pop(true),
                          ),
                        ).then((choice) {
                          if (choice != null && choice) {
                            widget.chatBloc
                                .add(DeletedMessage(message: message));
                          }
                        }),
                      );
                },
                color: Theme.of(context).errorColor,
                title: LocaleKeys.button_delete.tr(),
                iconData: Ionicons.trash_bin_outline,
              )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AppBloc>().state.user;
    return BlocBuilder<ChatBloc, ChatState>(
      bloc: widget.chatBloc,
      builder: (context, state) {
        if (state.status == ChatViewStatus.initial ||
            state.status == ChatViewStatus.loading ||
            state.messages.isEmpty ||
            state.conversationViewModel.members.isEmpty) {
          return const Expanded(child: SizedBox());
        }
        return Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            clipBehavior: Clip.none,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            reverse: true,
            itemCount: state.messages.length,
            itemBuilder: (context, index) {
              var isNotLastMessage = false;
              var isNotFirstMessage = false;
              final isSender = state.messages[index].authorId == currentUser.id;
              if (index > 0) {
                isNotLastMessage = state.messages[index].authorId ==
                    state.messages[index - 1].authorId;
              }
              if (index < state.messages.length - 1) {
                isNotFirstMessage = state.messages[index].authorId ==
                    state.messages[index + 1].authorId;
              }
              return Column(
                crossAxisAlignment: isSender
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  MessageBubble(
                    onTap: () => setState(() {
                      if (messageIdShowingTime == state.messages[index].id) {
                        messageIdShowingTime = '';
                      } else {
                        messageIdShowingTime = state.messages[index].id;
                      }
                    }),
                    onLongPress: () => _showMoreDialog(
                      state.messages[index],
                      currentUser,
                    ),
                    isSelected:
                        messageIdShowingTime == state.messages[index].id,
                    message: state.messages[index],
                    author: state.conversationViewModel.members.firstWhere(
                      (user) => user.id == state.messages[index].authorId,
                    ),
                    isNotFirstMessage: isNotFirstMessage,
                    isNotLastMessage: isNotLastMessage,
                    isSender: isSender,
                    isGroupChat:
                        state.conversationViewModel.conversation.type ==
                            ConversationType.group,
                  ),
                  if (messageIdShowingTime == state.messages[index].id)
                    Padding(
                      padding: EdgeInsets.only(
                        left: isSender ? 0 : 45,
                        right: isSender ? kDefaultPadding : 0,
                      ),
                      child: Text(
                        DateFormat(
                          'HH:mm a EEEE dd/MM/yyyy',
                          context.locale.languageCode,
                        ).format(state.messages[index].createdAt),
                        style: CustomTextStyle.bodySmall(context),
                      ),
                    ),
                  // if (isSender)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Builder(
                      builder: (ctx) {
                        final viewers = List<AppUser>.from(
                          state.conversationViewModel.members,
                        )..removeWhere(
                            (element) => element.id == currentUser.id,
                          );
                        final viewerWidget = <Widget>[];
                        for (final member in viewers) {
                          if (index == state.messages.length - 1) {
                            return const SizedBox();
                          }
                          if (index == 0) {
                            if (state.messages[index].seenBy
                                .contains(member.id)) {
                              viewerWidget.add(
                                CircleAvatarWidget(
                                  padding: const EdgeInsets.all(1.5),
                                  imageUrl: member.photoUrl,
                                  size: 15,
                                ),
                              );
                            }
                          } else if (state.messages[index].seenBy
                                  .contains(member.id) &&
                              !state.messages[index - 1].seenBy
                                  .contains(member.id)) {
                            viewerWidget.add(
                              CircleAvatarWidget(
                                padding: const EdgeInsets.all(1.5),
                                imageUrl: member.photoUrl,
                                size: 15,
                              ),
                            );
                          }
                        }
                        return viewerWidget.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  right: 12,
                                  top: 3,
                                  bottom: 3,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: viewerWidget,
                                ),
                              )
                            : const SizedBox();
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
