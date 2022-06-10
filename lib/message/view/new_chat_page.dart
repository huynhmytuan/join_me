import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/app/bloc/app_bloc.dart';
import 'package:join_me/config/router/app_router.dart';
import 'package:join_me/config/theme.dart';

import 'package:join_me/data/models/models.dart';
import 'package:join_me/data/repositories/message_repository.dart';

import 'package:join_me/message/bloc/new_conversation_bloc.dart';
import 'package:join_me/message/components/components.dart';
import 'package:join_me/message/components/no_conversation_handle.dart';
import 'package:join_me/user/cubit/search_user_cubit.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/widgets.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class NewChatPage extends StatelessWidget {
  const NewChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewConversationBloc(
        messageRepository: context.read<MessageRepository>(),
      )..add(AddSender(context.read<AppBloc>().state.user)),
      child: BlocConsumer<NewConversationBloc, NewConversationState>(
        listener: (context, state) {
          //Listen for send/create action and push to chat page
          if (state.newConversationStatus == NewConversationStatus.initial ||
              state.conversation == null) {
            return;
          }
          AutoRouter.of(context)
              .popAndPush(ChatRoute(conversationId: state.conversation!.id));
        },
        builder: (context, state) => KeyboardDismisser(
          child: Scaffold(
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      if (state.receivers.isNotEmpty) {
                        showDialog<bool>(
                          context: context,
                          builder: (context) => CustomAlertDialog(
                            title: 'Discard all changes?',
                            content:
                                'Everything which editing will be lost. Continue?',
                            submitLabel: 'Continue',
                            submitButtonColor: Colors.red,
                            onSubmit: () {
                              AutoRouter.of(context).pop(true);
                            },
                            onCancel: () {
                              AutoRouter.of(context).pop(false);
                            },
                          ),
                        ).then((value) {
                          if (value != null && value) {
                            AutoRouter.of(context).pop();
                          }
                        });
                      } else {
                        AutoRouter.of(context).pop();
                      }
                    },
                    child: const Text('Cancel'),
                  ),
                  const _UserSearch(),
                  const _ReceiverViewer(),
                  const Divider(),
                  const _ConversationViewer(),
                  const SizedBox(
                    height: kDefaultPadding,
                  ),
                  const _MessageInput(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageInput extends StatefulWidget {
  const _MessageInput({
    Key? key,
  }) : super(key: key);

  @override
  State<_MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<_MessageInput> {
  late TextEditingController _editingController;
  @override
  void initState() {
    _editingController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewConversationBloc, NewConversationState>(
      builder: (context, state) {
        return BottomTextField(
          textEditingController: _editingController,
          hintText: 'Say something...',
          onSubmit: () {
            if (state.receivers.isEmpty) {
              return;
            }
            if (state.conversation == null) {
              context.read<NewConversationBloc>().add(
                    AddConversation(
                      senderId: state.sender.id,
                      receiverIds: state.receivers.map((e) => e.id).toList(),
                      firstMessageContent: _editingController.text,
                    ),
                  );
            } else {
              context.read<NewConversationBloc>().add(
                    SendMessageToCurrentConversation(
                      messageContent: _editingController.text,
                    ),
                  );
            }
          },
        );
      },
    );
  }
}

class _ReceiverViewer extends StatelessWidget {
  const _ReceiverViewer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewConversationBloc, NewConversationState>(
      builder: (context, state) {
        return SizedBox(
          height: 40,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: state.receivers.length,
            itemBuilder: (context, index) => ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 200),
              child: Chip(
                avatar: CircleAvatarWidget(
                  imageUrl: state.receivers[index].photoUrl,
                ),
                label: Text(state.receivers[index].name),
                deleteIcon: const Icon(Ionicons.close_circle),
                onDeleted: () {
                  context
                      .read<NewConversationBloc>()
                      .add(RemoveReceiver(state.receivers[index]));
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _UserSearch extends StatelessWidget {
  const _UserSearch({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _currentUser = context.read<AppBloc>().state.user;
    return BlocBuilder<NewConversationBloc, NewConversationState>(
      builder: (context, state) {
        return BlocBuilder<SearchUserCubit, SearchUserState>(
          builder: (context, searchState) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              color: Theme.of(context).brightness == Brightness.light
                  ? kIconColorGrey
                  : Theme.of(context).cardColor,
              child: Row(
                children: [
                  const Text('Send to:'),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TypeAheadFormField<AppUser?>(
                      textFieldConfiguration: const TextFieldConfiguration(
                        autofocus: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                      itemBuilder: (BuildContext context, user) {
                        if (user == _currentUser) {
                          return const SizedBox();
                        }
                        return ListTile(
                          leading: CircleAvatarWidget(imageUrl: user!.photoUrl),
                          title: Text(user.name),
                          trailing: state.receivers.contains(user)
                              ? const Icon(Icons.check)
                              : null,
                        );
                      },
                      suggestionsBoxDecoration: SuggestionsBoxDecoration(
                        color: Theme.of(context).cardColor,
                        shape: kBorderRadiusShape,
                      ),
                      hideOnError: true,
                      hideOnLoading: true,
                      onSuggestionSelected: (AppUser? user) {
                        context
                            .read<NewConversationBloc>()
                            .add(AddReceiver(user!));
                      },
                      suggestionsCallback: (String pattern) {
                        return context
                            .read<SearchUserCubit>()
                            .searchUsers(pattern);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _ConversationViewer extends StatefulWidget {
  const _ConversationViewer({
    Key? key,
  }) : super(key: key);

  @override
  State<_ConversationViewer> createState() => _ConversationViewerState();
}

class _ConversationViewerState extends State<_ConversationViewer> {
  String messageIdShowingTime = '';
  @override
  Widget build(BuildContext context) {
    final appLocale = Localizations.localeOf(context);
    return Expanded(
      child: BlocBuilder<NewConversationBloc, NewConversationState>(
        builder: (context, state) {
          final members = List.of(state.receivers)..add(state.sender);
          if (state.conversation == null) {
            return NoConversationHandle(receivers: state.receivers);
          }
          return ListView.builder(
            reverse: true,
            padding: const EdgeInsets.only(bottom: kDefaultPadding),
            itemCount: state.messages.length,
            itemBuilder: (context, index) {
              var isNotLastMessage = false;
              var isNotFirstMessage = false;
              final isSender = state.sender ==
                  members.firstWhere(
                    (element) => state.messages[index].authorId == element.id,
                  );
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
                    message: state.messages[index],
                    author: members.firstWhere(
                      (element) => state.messages[index].authorId == element.id,
                    ),
                    isSelected:
                        messageIdShowingTime == state.messages[index].id,
                    isNotFirstMessage: isNotFirstMessage,
                    isNotLastMessage: isNotLastMessage,
                    isSender: isSender,
                    isGroupChat: state.receivers.length > 1,
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
          );
        },
      ),
    );
  }
}
