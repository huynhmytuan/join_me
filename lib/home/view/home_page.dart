import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/config/router/router.dart';
import 'package:join_me/utilities/constant.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: const [
        PostsRouter(),
        ConversationRoute(),
        ProjectsRouter(),
        NotificationRoute(),
        MenuRoute(),
      ],
      bottomNavigationBuilder: _buildBottomBar,
    );
  }

  Widget _buildBottomBar(BuildContext context, TabsRouter tabsRouter) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      type: BottomNavigationBarType.fixed,
      elevation: 2,
      iconSize: 20,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: kTextColorGrey,
      currentIndex: tabsRouter.activeIndex,
      onTap: tabsRouter.setActiveIndex,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Ionicons.home_outline),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Ionicons.paper_plane_outline),
          label: 'Message',
        ),
        BottomNavigationBarItem(
          icon: Icon(Ionicons.folder_outline),
          label: 'Project',
        ),
        BottomNavigationBarItem(
          icon: Icon(Ionicons.notifications_outline),
          label: 'Notification',
        ),
        BottomNavigationBarItem(
          icon: Icon(Ionicons.menu_outline),
          label: 'Menu',
        )
      ],
    );
  }
}
