import 'dart:async';

import 'package:auto_route/auto_route.dart';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/dummy_data.dart' as dummy_data;
import 'package:join_me/data/models/models.dart';
import 'package:join_me/message/components/components.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/avatar_circle_widget.dart';
import 'package:join_me/widgets/bottom_text_field.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    @pathParam required this.conversationId,
    Key? key,
  }) : super(key: key);
  final String conversationId;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late TextEditingController messageEditTextController;
  final StreamController _messageController =
      StreamController<List<Message>>.broadcast();
  late Stream<List<Message>> messageStream;
  void _getMessage() {
    final messages = dummy_data.messagesData
        .where((element) => element.conversationId == widget.conversationId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    _messageController.add(messages);
    return;
  }

  @override
  void initState() {
    messageStream = _messageController.stream as Stream<List<Message>>;
    messageEditTextController = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _getMessage();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    const currentUser = dummy_data.currentUser;
    final conversation = dummy_data.conversationsData
        .firstWhere((element) => element.id == widget.conversationId);
    final sender = dummy_data.usersData.firstWhere(
      (user) =>
          user.id ==
          (conversation.members.firstWhere((u) => u != currentUser.id)),
    );
    return KeyboardDismisser(
      // ignore: prefer_const_literals_to_create_immutables
      gestures: [GestureType.onTap],
      child: Scaffold(
        appBar: _buildAppBar(context, sender),
        body: Column(
          children: [
            _buildMessages(),
            const SizedBox(
              height: kDefaultPadding,
            ),
            BottomTextField(
              textEditingController: messageEditTextController,
              hintText: 'Send a message...',
              onSubmit: () {},
            ),
          ],
        ),
      ),
    );
  }

  Expanded _buildMessages() {
    return Expanded(
      child: StreamBuilder<List<Message>>(
        stream: messageStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No data'),
            );
          }

          return ListView.builder(
            clipBehavior: Clip.none,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            reverse: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var isGroup = false;
              if (index > 0) {
                isGroup = snapshot.data![index].authorId ==
                    snapshot.data![index - 1].authorId;
              }
              return MessageBubble(
                message: snapshot.data![index],
                isGroupMessage: isGroup,
              );
            },
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, User sender) {
    return AppBar(
      elevation: 5,
      shadowColor: Colors.grey.withOpacity(.3),
      leading: IconButton(
        onPressed: () => AutoRouter.of(context).pop(),
        icon: const Icon(
          Ionicons.chevron_back,
        ),
      ),
      title: Row(
        children: [
          CircleAvatarWidget(imageUrl: sender.photoUrl),
          const SizedBox(
            width: kDefaultPadding / 2,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //User display name
              Text(
                sender.displayName,
                style: CustomTextStyle.heading3(context),
              ),
              //PostTime
              // Text(
              //   timeago.format(
              //     post.createdAt,
              //     locale: appLocale.languageCode,
              //   ),
              //   style: CustomTextStyle.subText(context)
              //       .copyWith(color: kTextColorGrey),
              // ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: _getMessage,
          icon: const Icon(
            Icons.info_outline,
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    messageEditTextController.dispose();
    super.dispose();
  }
}
