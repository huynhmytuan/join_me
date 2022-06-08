import 'package:flutter/material.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/models/app_user.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/stack_image.dart';

class NoConversationHandle extends StatelessWidget {
  const NoConversationHandle({required this.receivers, Key? key})
      : super(key: key);
  final List<AppUser> receivers;

  @override
  Widget build(BuildContext context) {
    if (receivers.isEmpty) {
      return const SizedBox();
    }
    String name;
    if (receivers.length == 1) {
      name = receivers.first.name;
    } else if (receivers.length <= 4) {
      name = receivers.map((e) => e.name.split(' ')[0]).toList().join(', ');
    } else {
      name =
          '${receivers.map((e) => e.name.split(' ')[0]).toList().take(4).join(', ')}...';
    }
    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StackedImages(
            imageUrlList: receivers.map((e) => e.photoUrl).toList(),
            totalCount: receivers.length,
            imageSize: receivers.length == 1 ? 70 : 50,
          ),
          const SizedBox(height: 10),
          Text(
            name,
            style: CustomTextStyle.heading2(context),
          ),
        ],
      ),
    );
  }
}
