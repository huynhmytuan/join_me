import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/dummy_data.dart' as dummy_data;
import 'package:join_me/data/models/models.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/expanded_text.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentWidget extends StatefulWidget {
  const CommentWidget({
    required this.comment,
    Key? key,
  }) : super(key: key);
  final Comment comment;
  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  late User author;

  void _getAuthor() {
    author = dummy_data.usersData
        .firstWhere((element) => element.id == widget.comment.authorId);
  }

  @override
  void initState() {
    _getAuthor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              //TODO: Go to user's Page
            },
            child: CircleAvatar(
              radius: 17,
              backgroundImage: NetworkImage(author.photoUrl),
            ),
          ),
          const SizedBox(
            width: kDefaultPadding / 2,
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                kDefaultPadding,
                kDefaultPadding / 2,
                kDefaultPadding,
                kDefaultPadding,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(kDefaultPadding),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //User display name
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              //TODO: Go to user's Page
                            },
                            child: Text(
                              author.displayName,
                              style: CustomTextStyle.heading4(context).copyWith(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: kDefaultPadding,
                          ),
                          Text(
                            timeago.format(
                              widget.comment.createdAt,
                              locale:
                                  Localizations.localeOf(context).languageCode,
                            ),
                            style: CustomTextStyle.subText(context),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: kDefaultPadding / 2,
                      ),
                      ExpandedText(text: widget.comment.content),
                    ],
                  ),
                  const SizedBox(
                    height: kDefaultPadding / 2,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          splashRadius: 20,
                          onPressed: () {},
                          icon: const Icon(
                            Ionicons.heart_outline,
                            color: kTextColorGrey,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(widget.comment.likes.length.toString()),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
