import 'package:flutter/material.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/widgets.dart';

class ThemeSettingPage extends StatelessWidget {
  const ThemeSettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Language'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: SelectedListWidget(
          onSelection: (index, title) {},
          selectionTitles: const [
            'Light Mode',
            'Dark Mode',
            'System',
          ],
        ),
      ),
    );
  }
}
