import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/dummy_data.dart' as dummy_data;
import 'package:join_me/data/models/models.dart';
import 'package:join_me/message/components/components.dart';
import 'package:join_me/utilities/constant.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  List<Conversation> conversations = [];
  //
  void _getConversation() {
    const user = dummy_data.currentUser;
    // ignore: lines_longer_than_80_chars
    conversations = dummy_data.conversationsData
        .where((c) => c.members.contains(user.id))
        .toList();
  }

  @override
  void initState() {
    _getConversation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        key: const PageStorageKey<String>('AlbumScreen'),
        headerSliverBuilder: (context, value) {
          return [
            const SliverAppBar(
              pinned: true,
              title: Text('Messages'),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 30,
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Center(
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
          ];
        },
        body: conversations.isEmpty
            ? const Center(
                child: Text('Empty'),
              )
            : SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  itemCount: conversations.length,
                  itemBuilder: (context, index) {
                    return ConversationCard(
                      conversation: conversations[index],
                    );
                  },
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'new_message',
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // <-- Radius
        ),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {},
        child: const Icon(
          Ionicons.add,
          size: 30,
        ),
      ),
    );
  }
}
