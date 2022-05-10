import 'package:flutter/material.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/avatar_circle_widget.dart';

class StackImage extends StatelessWidget {
  const StackImage({
    required this.imageUrlList,
    this.borderWidth,
    this.imageSize,
    this.imageCount,
    this.totalCount,
    Key? key,
  }) : super(key: key);
  final List<String> imageUrlList;

  ///The width of circle image with default value is 2
  final double? borderWidth;
  final double? imageSize;

  ///How many image view in the [StackImage]
  ///default value = 3
  ///Must be lower than [totalCount]
  final int? imageCount;

  ///Show number of remain Image in list
  final int? totalCount;

  @override
  Widget build(BuildContext context) {
    final stackList = imageUrlList
        .sublist(
            0, imageUrlList.length <= 3 ? imageUrlList.length : imageCount ?? 3)
        .asMap()
        .map(
          (index, value) => MapEntry(
            index,
            Padding(
              padding: EdgeInsets.only(left: 0.8 * index * (imageSize ?? 30)),
              child: CircleAvatarWidget(
                imageUrl: imageUrlList[index],
                border: Border.all(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: borderWidth ?? 2,
                ),
                size: imageSize,
              ),
            ),
          ),
        )
        .values
        .toList();
    if (totalCount != null && totalCount! > stackList.length) {
      stackList.add(
        Padding(
          padding: EdgeInsets.only(
            left: 0.8 * stackList.length * (imageSize ?? 30),
          ),
          child: Container(
            height: imageSize ?? 32,
            width: imageSize ?? 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: kIconColorGrey,
              borderRadius: BorderRadius.circular(imageSize ?? 30),
              border: Border.all(
                color: Theme.of(context).scaffoldBackgroundColor,
                width: borderWidth ?? 2,
              ),
            ),
            child: FittedBox(
              child: Text(
                '+${totalCount! - stackList.length}',
                style: CustomTextStyle.bodySmall(context).copyWith(
                  color: kTextColorGrey,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Row(
      children: [
        Stack(
          alignment: Alignment.centerLeft,
          clipBehavior: Clip.none,
          children: stackList,
        ),
      ],
    );
  }
}
