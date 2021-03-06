import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:join_me/config/router/app_router.dart';
import 'package:join_me/config/theme.dart';

import 'package:join_me/data/repositories/media_repository.dart';
import 'package:join_me/generated/locale_keys.g.dart';
import 'package:join_me/images_picker/bloc/images_picker_bloc.dart';
import 'package:join_me/utilities/constant.dart';

import 'package:photo_manager/photo_manager.dart';

class ImagesPickerPage extends StatelessWidget {
  const ImagesPickerPage({
    this.initialMedias = const [],
    this.limit = 10,
    this.type,
    Key? key,
  }) : super(key: key);
  final List<AssetEntity> initialMedias;
  final int? limit;
  final RequestType? type;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ImagesPickerBloc(
        mediaRepository: context.read<MediaRepository>(),
        limit: limit,
      )..add(LoadMedias(initialMedias: initialMedias, requestType: type)),
      child: BlocBuilder<ImagesPickerBloc, ImagesPickerState>(
        builder: (context, state) {
          return AutoTabsScaffold(
            routes: const [MediaGridRoute(), AlbumsListRoute()],
            appBarBuilder: (context, tabsRouter) => _CustomAppBar(
              tabsRouter: tabsRouter,
            ),
            floatingActionButton: _buildFloatingActionButton(context, state),
          );
        },
      ),
    );
  }

  Widget? _buildFloatingActionButton(
    BuildContext context,
    ImagesPickerState state,
  ) {
    return state.selectedAssets.isEmpty
        ? null
        : FloatingActionButton(
            shape: kBorderRadiusShape,
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () {
              context.read<ImagesPickerBloc>().add(ClearAll());
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.clear),
                Text(
                  state.selectedAssets.length.toString(),
                ),
              ],
            ),
          );
  }
}

class _CustomAppBar extends StatefulWidget with PreferredSizeWidget {
  const _CustomAppBar({
    required this.tabsRouter,
    Key? key,
  }) : super(key: key);
  final TabsRouter tabsRouter;
  @override
  State<_CustomAppBar> createState() => _CustomAppBarState();
  @override
  Size get preferredSize => const Size.fromHeight(50);
}

class _CustomAppBarState extends State<_CustomAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  bool isOpen = false;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  void onAlbumPressed() {
    setState(() {
      isOpen = !isOpen;
      isOpen ? _animationController.forward() : _animationController.reverse();
    });
    widget.tabsRouter.setActiveIndex(isOpen ? 1 : 0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ImagesPickerBloc, ImagesPickerState>(
      listenWhen: (previous, current) =>
          previous.currentAlbum != current.currentAlbum,
      listener: (context, state) {
        widget.tabsRouter.setActiveIndex(0);
        isOpen = false;
        _animationController.reverse();
      },
      builder: (context, state) {
        return AppBar(
          leading: GestureDetector(
            onTap: () => AutoRouter.of(context).pop(),
            child: const Icon(Icons.close),
          ),
          centerTitle: true,
          title: GestureDetector(
            onTap: onAlbumPressed,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (state.status == ImagePickersStatus.success)
                  if (state.currentAlbum != null)
                    Text(
                      state.currentAlbum!.name,
                      style: const TextStyle(fontSize: 16),
                    ),
                const SizedBox(
                  width: 10,
                ),
                AnimatedIcon(
                  icon: AnimatedIcons.menu_close,
                  progress: _animationController,
                  size: 16,
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: state.selectedAssets.isEmpty
                  ? null
                  : () {
                      AutoRouter.of(context).pop(state.selectedAssets);
                    },
              child: Text(LocaleKeys.button_done.tr()),
            )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
