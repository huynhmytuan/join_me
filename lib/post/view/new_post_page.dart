import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/dummy_data.dart' as dummy_data;
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/widgets.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class NewPostPage extends StatefulWidget {
  const NewPostPage({Key? key}) : super(key: key);

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  // TODO(tuan): Get current user.
  final user = dummy_data.currentUser;
  final postTextEditController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      // ignore: prefer_const_literals_to_create_immutables
      gestures: [
        GestureType.onTap,
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => AutoRouter.of(context).pop(),
            icon: const Icon(Ionicons.close),
          ),
          title: const Text('Create new post'),
          actions: [
            IconButton(
              color: Theme.of(context).primaryColor,
              onPressed: postTextEditController.text.trim().isEmpty
                  ? null
                  : () {
                      // TODO(tuan): Send this post to sever
                    },
              icon: const Icon(Ionicons.share_outline),
            )
          ],
        ),
        body: Container(
          margin: const EdgeInsets.only(bottom: 40),
          child: Scrollbar(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CachedNetworkImage(
                            imageUrl: user.photoUrl,
                            errorWidget: (context, url, dynamic error) =>
                                const Icon(Icons.error),
                            fit: BoxFit.cover,
                            height: 30,
                            width: 30,
                          ),
                        ),
                        const SizedBox(
                          width: kDefaultPadding / 2,
                        ),
                        Text(
                          user.displayName,
                          style: CustomTextStyle.heading3(context),
                        )
                      ],
                    ),
                    TextField(
                      controller: postTextEditController,
                      autofocus: true,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'What on your mind?',
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              RoundedButton(
                height: 35,
                minWidth: 80,
                child: Row(
                  children: [
                    const Icon(
                      Ionicons.image,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Add Image',
                      style: CustomTextStyle.heading4(context).copyWith(
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
                onPressed: () {},
              ),
              const SizedBox(
                width: kDefaultPadding,
              ),
              RoundedButton(
                height: 35,
                minWidth: 80,
                color: kSecondaryBlue,
                child: Row(
                  children: [
                    const Icon(
                      Ionicons.person_add,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Add Invitation',
                      style: CustomTextStyle.heading4(context).copyWith(
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
