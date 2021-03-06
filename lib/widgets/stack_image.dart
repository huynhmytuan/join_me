import 'package:flutter/material.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/avatar_circle_widget.dart';

class StackedImages extends StatelessWidget {
  const StackedImages({
    required this.imageUrlList,
    required this.totalCount,
    this.borderWidth,
    this.imageSize,
    this.imageCount,
    this.emptyHandler,
    Key? key,
  }) : super(key: key);
  final List<String> imageUrlList;

  ///The width of circle image with default value is 2
  final double? borderWidth;
  final double? imageSize;

  ///How many image view in the [StackedImages]
  ///default value = 3
  ///Must be lower than [totalCount]
  final int? imageCount;

  ///Show number of remain Image in list
  final int totalCount;

  ///Show this widget when list is empty
  final Widget? emptyHandler;

  @override
  Widget build(BuildContext context) {
    final stackList = imageUrlList
        .sublist(
          0,
          imageUrlList.length <= 3 ? imageUrlList.length : imageCount ?? 3,
        )
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
    if (totalCount > stackList.length) {
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
                '+${totalCount - stackList.length}',
                style: CustomTextStyle.bodySmall(context).copyWith(
                  color: kTextColorGrey,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return imageUrlList.isEmpty
        ? emptyHandler ?? const Text('Empty')
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
