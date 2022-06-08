import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/utilities/constant.dart';

class CircleAvatarWidget extends StatelessWidget {
  const CircleAvatarWidget({
    Key? key,
    required this.imageUrl,
    this.size,
    this.border,
    this.padding,
    this.overlay,
  }) : super(key: key);

  final String imageUrl;

  ///Circle size, default value is 30
  final double? size;
  //
  final BoxBorder? border;

  final EdgeInsets? padding;

  final Widget? overlay;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: border,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius:
                BorderRadius.circular((size != null) ? size! / 2 : 15),
            child: (imageUrl.isEmpty)
                ? CircleAvatar(
                    radius: (size != null) ? size! / 2 : 15,
                    backgroundColor: kIconColorGrey,
                    foregroundColor: kTextColorGrey,
                    child: Icon(
                      Ionicons.person,
                      size: (size != null) ? size! / 2 : 15,
                    ),
                  )
                : CachedNetworkImage(
                    imageUrl: imageUrl,
                    errorWidget: (context, url, dynamic error) => CircleAvatar(
                      radius: (size != null) ? size! / 2 : 15,
                      foregroundColor: kTextColorGrey,
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: (size != null) ? size! / 2 : 15,
                      ),
                    ),
                    fit: BoxFit.cover,
                    height: size ?? 30,
                    width: size ?? 30,
                  ),
          ),
          Positioned.fill(
            child: overlay ?? const SizedBox(),
          ),
        ],
      ),
    );
  }
}
