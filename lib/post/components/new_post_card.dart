import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/utilities/constant.dart';

class NewPostCard extends StatelessWidget {
  const NewPostCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: kDefaultPadding,
        horizontal: kDefaultPadding / 2,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(kDefaultRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding / 2),
          child: Row(
            children: [
              CircleAvatar(
                radius: 15,
                child: SvgPicture.asset(kLogoLightDir),
              ),
              const SizedBox(
                width: 20,
              ),
              Material(
                child: InkWell(
                  onTap: () {},
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
      ),
    );
  }
}