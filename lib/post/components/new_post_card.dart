import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/config/router/app_router.dart';
import 'package:join_me/data/dummy_data.dart' as dummy_data;
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/avatar_circle_widget.dart';
import 'package:join_me/widgets/rounded_container.dart';

class NewPostCard extends StatelessWidget {
  const NewPostCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const currentUser = dummy_data.currentUser;
    return RoundedContainer(
      margin: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding / 2,
      ),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding / 2),
        child: Row(
          children: [
            CircleAvatarWidget(imageUrl: currentUser.photoUrl),
            const SizedBox(
              width: 20,
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  AutoRouter.of(context).push(const NewPostRoute());
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding,
                    vertical: 5,
                  ),
                  child: const Text('What on your mind?'),
                ),
              ),
            ),
            const Spacer(),
            Material(
              color: Colors.transparent,
              child: IconButton(
                splashRadius: 24,
                onPressed: () {},
                icon: Icon(
                  Ionicons.image,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: IconButton(
                splashRadius: 24,
                onPressed: () {},
                icon: Icon(
                  Ionicons.person_add,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
