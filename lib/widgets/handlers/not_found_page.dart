import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/rounded_icon_button.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: RoundedIconButton(
          icon: const Icon(Ionicons.chevron_back),
          onTap: () => AutoRouter.of(context).pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              kNotFoundPicDir,
              width: screenSize.width * .70,
            ),
            Text(
              'Oops! What you looking for not exist.',
              style: CustomTextStyle.heading2(context),
            ),
          ],
        ),
      ),
    );
  }
}
