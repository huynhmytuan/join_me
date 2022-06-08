import 'package:flutter/material.dart';
import 'package:join_me/data/models/app_user.dart';
import 'package:join_me/widgets/avatar_circle_widget.dart';

class ConversationAvatar extends StatelessWidget {
  const ConversationAvatar({
    required this.receivers,
    this.size = 40,
    Key? key,
  }) : super(key: key);
  final List<AppUser> receivers;
  final double size;
  @override
  Widget build(BuildContext context) {
    if (receivers.isEmpty) {
      return const SizedBox();
    }

    Widget avatar;
    if (receivers.length == 1) {
      avatar = CircleAvatarWidget(
        imageUrl: receivers.first.photoUrl,
        size: size,
      );
    } else {
      avatar = SizedBox(
        width: size,
        height: size,
        child: Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              child: CircleAvatarWidget(
                imageUrl: receivers.elementAt(0).photoUrl,
                size: size / 1.6,
                border: Border.all(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: 2,
                ),
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: CircleAvatarWidget(
                imageUrl: receivers.elementAt(1).photoUrl,
                size: size / 1.6,
                border: Border.all(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: 2,
                ),
              ),
            )
          ],
        ),
      );
    }
    return avatar;
  }
}
