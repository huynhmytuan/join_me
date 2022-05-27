import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:join_me/images_picker/bloc/images_picker_bloc.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:photo_manager/photo_manager.dart';

class AlbumsListPage extends StatelessWidget {
  const AlbumsListPage({Key? key}) : super(key: key);
  Future<Uint8List?> _getPreviewImage(AssetPathEntity album) async {
    final assets = await album.getAssetListRange(start: 0, end: 1);
    return assets[0].thumbnailDataWithSize(const ThumbnailSize.square(200));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImagesPickerBloc, ImagesPickerState>(
      builder: (context, state) {
        return ListView.builder(
          itemCount: state.albums.length,
          itemBuilder: (context, index) => ListTile(
            onTap: () {
              context
                  .read<ImagesPickerBloc>()
                  .add(ChangeAlbum(album: state.albums[index]));
              context.tabsRouter.setActiveIndex(0);
            },
            leading: FutureBuilder<Uint8List?>(
              future: _getPreviewImage(state.albums[index]),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return AspectRatio(
                    aspectRatio: 1,
                    child: Image.memory(
                      snapshot.data!,
                      fit: BoxFit.cover,
                    ),
                  );
                }
                return AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    color: kIconColorGrey,
                  ),
                );
              },
            ),
            title: Text(state.albums[index].name),
            subtitle: Text(state.albums[index].assetCount.toString()),
          ),
        );
      },
    );
  }
}
