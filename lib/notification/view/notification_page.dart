import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:join_me/app/bloc/app_bloc.dart';
import 'package:join_me/generated/locale_keys.g.dart';
import 'package:join_me/notification/bloc/notification_bloc.dart';
import 'package:join_me/notification/components/notification_list_tile.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/handlers/empty_handler_widget.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(LocaleKeys.bottomBarLabel_notifications.tr()),
        actions: [
          IconButton(
            onPressed: () {
              final currentUser = context.read<AppBloc>().state.user;
              context
                  .read<NotificationBloc>()
                  .add(MarkAllAsRead(currentUser.id));
            },
            icon: Icon(
              Icons.done_all,
              color: Theme.of(context).primaryColor,
            ),
          )
        ],
      ),
      body: const _NotificationsView(),
    );
  }
}

class _NotificationsView extends StatelessWidget {
  const _NotificationsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AppBloc>().state.user;
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        if (state.notifications.isEmpty) {
          return EmptyHandlerWidget(
            size: MediaQuery.of(context).size.width * .4,
            imageHandlerDir: kNoNotificationPicDir,
            titleHandler: LocaleKeys.emptyHandler_noNotification_title.tr(),
            textHandler: LocaleKeys.emptyHandler_noNotification_content.tr(),
          );
        }
        return RefreshIndicator(
          onRefresh: () async => context
              .read<NotificationBloc>()
              .add(LoadNotifications(currentUser.id)),
          child: ListView.builder(
            itemCount: state.notifications.length,
            itemBuilder: (ctx, index) => NotificationListTile(
              notificationViewModel: state.notifications[index],
            ),
          ),
        );
      },
    );
  }
}
