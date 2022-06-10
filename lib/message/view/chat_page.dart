import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/app/bloc/app_bloc.dart';
import 'package:join_me/app/cubit/app_message_cubit.dart';
import 'package:join_me/config/router/app_router.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/data/repositories/repositories.dart';
import 'package:join_me/message/bloc/chat_bloc.dart';
import 'package:join_me/message/components/components.dart';
import 'package:join_me/message/components/conversation_avatar.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/bottom_sheet/selection_bottom_sheet.dart';
import 'package:join_me/widgets/bottom_text_field.dart';
import 'package:join_me/widgets/dialog/custom_alert_dialog.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    @PathParam('conversationId') required this.conversationId,
    Key? key,
  }) : super(key: key);
  final String conversationId;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatBloc chatBloc;
  late AppUser currentUser;
  @override
  void initState() {
    currentUser = context.read<AppBloc>().state.user;
    chatBloc = ChatBloc(
      appMessageCubit: context.read<AppMessageCubit>(),
      messageRepository: context.read<MessageRepository>(),
      userRepository: context.read<UserRepository>(),
    )..add(
        LoadChat(
          conversationId: widget.conversationId,
          userId: currentUser.id,
        ),
      );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      bloc: chatBloc,
      listener: (context, state) {
        if (state.status == ChatViewStatus.notFound) {
          AutoRouter.of(context).popAndPush(const NotFoundRoute());
        }
        final members = state.conversationViewModel.conversation.members;

        if (members.isNotEmpty && !members.contains(currentUser.id)) {
          AutoRouter.of(context).popForced();
          log(state.conversationViewModel.conversation.members.toString());
          context.read<AppMessageCubit>().showInfoSnackbar(
                message: 'You have been removed',
              );
        }
      },
      child: KeyboardDismisser(
        child: Scaffold(
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? kBackgroundPostLight
              : null,
          appBar: _buildAppBar(context, currentUser, chatBloc),
          body: Column(
            children: [
              _MessagesListView(
                chatBloc: chatBloc,
              ),
              const SizedBox(
                height: kDefaultPadding,
              ),
              _MessageInput(
                chatBloc: chatBloc,
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSize _buildAppBar(
    BuildContext context,
    AppUser currentUser,
    ChatBloc chatBloc,
  ) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(130),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => AutoRouter.of(context).pop(),
                    icon: const Icon(
                      Ionicons.chevron_back,
                    ),
                  ),
                  BlocBuilder<ChatBloc, ChatState>(
                    bloc: chatBloc,
                    builder: (context, state) {
                      if (state.status == ChatViewStatus.loading ||
                          state.status == ChatViewStatus.initial) {
                        return const SizedBox();
                      }
                      final senders =
                          List.of(state.conversationViewModel.members)
                            ..removeWhere((user) => user.id == currentUser.id);

                      String name;
                      if (senders.length == 1) {
                        name = senders.first.name;
                      } else if (senders.length <= 4) {
                        name = senders
                            .map((e) => e.name.split(' ')[0])
                            .toList()
                            .join(', ');
                      } else {
                        name =
                            '${senders.map((e) => e.name.split(' ')[0]).toList().take(4).join(', ')}...';
                      }
                      return Row(
                        children: [
                          ConversationAvatar(receivers: senders),
                          const SizedBox(
                            width: kDefaultPadding / 2,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //User display name
                              Text(
                                name,
                                style: CustomTextStyle.heading3(context)
                                    .copyWith(),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  //Push and check callback value
                  //If value is true, that mean this conversation is deleted or
                  //current user leave this conversation.
                  AutoRouter.of(context)
                      .push(ConversationInfoRoute(chatBloc: chatBloc))
                      .then((isPop) {
                    log(isPop.toString());
                    if (isPop != null && (isPop as bool)) {
                      AutoRouter.of(context).pop();
                    }
                  });
                },
                icon: const Icon(
                  Icons.info_outline,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    chatBloc.close();
    super.dispose();
  }
}

class _MessagesListView extends StatefulWidget {
  const _MessagesListView({required this.chatBloc, Key? key}) : super(key: key);
  final ChatBloc chatBloc;

  @override
  State<_MessagesListView> createState() => _MessagesListViewState();
}

class _MessagesListViewState extends State<_MessagesListView> {
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
          title: 'More',
          listSelections: [
            SelectionRow(
              onTap: () {
                Clipboard.setData(ClipboardData(text: message.content));
                AutoRouter.of(context).pop();
              },
              title: 'Copy Comment',
              iconData: Ionicons.copy_outline,
            ),
            if (isOwner)
              SelectionRow(
                onTap: () {
                  AutoRouter.of(context).pop().then(
                        (value) => showDialog<bool>(
                          context: context,
                          builder: (context) => CustomAlertDialog(
                            title: 'Are you sure?',
                            content:
                                '''Once you delete this message, this cannot be undone.''',
                            submitButtonColor: Theme.of(context).errorColor,
                            submitLabel: 'Delete',
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
                title: 'Delete Comment',
                iconData: Ionicons.trash_bin_outline,
              )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = Localizations.localeOf(context);
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
                          appLocale.languageCode,
                        ).format(state.messages[index].createdAt),
                        style: CustomTextStyle.bodySmall(context),
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

class _MessageInput extends StatefulWidget {
  const _MessageInput({required this.chatBloc, Key? key}) : super(key: key);
  final ChatBloc chatBloc;

  @override
  State<_MessageInput> createState() => __MessageInputState();
}

class __MessageInputState extends State<_MessageInput> {
  late TextEditingController messageEditTextController;
  @override
  void initState() {
    messageEditTextController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AppBloc>().state.user;
    return BlocBuilder<ChatBloc, ChatState>(
      bloc: widget.chatBloc,
      buildWhen: (previous, current) => false,
      builder: (context, state) {
        return BottomTextField(
          textEditingController: messageEditTextController,
          hintText: 'Send a message...',
          onSubmit: () {
            widget.chatBloc.add(
              SendMessage(
                content: messageEditTextController.text,
                author: currentUser,
              ),
            );
            messageEditTextController.clear();
          },
        );
      },
    );
  }

  @override
  void dispose() {
    messageEditTextController.dispose();
    super.dispose();
  }
}
