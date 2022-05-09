import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
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
        MessagesRouter(),
        ProjectsRouter(),
        NotificationRoute(),
        MenuRoute(),
      ],
      bottomNavigationBuilder: _buildBottomBar,
    );
  }

  Widget _buildBottomBar(BuildContext context, TabsRouter tabsRouter) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(kDefaultRadius),
          topRight: Radius.circular(kDefaultRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.2),
            blurRadius: 10,
            offset: const Offset(0, -4),
          )
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
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
      ),
    );
  }
}
