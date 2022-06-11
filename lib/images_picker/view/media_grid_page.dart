import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/images_picker/bloc/images_picker_bloc.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/utilities/extensions/string_ext.dart';
import 'package:join_me/widgets/widgets.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaGridPage extends StatelessWidget {
  const MediaGridPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImagesPickerBloc, ImagesPickerState>(
      buildWhen: (previous, current) => previous.medias != current.medias,
      builder: (context, state) {
        if (state.status == ImagePickersStatus.success) {
          return _MediaGrid(assets: state.medias);
        }
        if (state.status == ImagePickersStatus.noPermission) {
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No permission'),
                RoundedButton(
                  height: 30,
                  child: const Text('Open Setting'),
                  onPressed: () {},
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}

class _MediaGrid extends StatelessWidget {
  const _MediaGrid({
    required this.assets,
    Key? key,
  }) : super(key: key);
  final List<AssetEntity> assets;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: assets.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
      ),
      itemBuilder: (context, index) => _MediaThumbnail(
        asset: assets[index],
      ),
    );
  }
}

class _MediaThumbnail extends StatelessWidget {
  const _MediaThumbnail({
    Key? key,
    required this.asset,
  }) : super(key: key);
  final AssetEntity asset;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      excludeFromSemantics: true,
      onTap: () {
        HapticFeedback.lightImpact();
        context.read<ImagesPickerBloc>().add(MediaSelected(media: asset));
      },
      child: FutureBuilder<Uint8List?>(
        future: asset.thumbnailDataWithOption(
          (Platform.isIOS)
              ? ThumbnailOption.ios(
                  size: const ThumbnailSize.square(500),
                  deliveryMode: DeliveryMode.fastFormat,
                )
              : const ThumbnailOption(
                  size: ThumbnailSize.square(150),
                ),
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Stack(
              fit: StackFit.expand,
              children: [
                Image.memory(
                  snapshot.data!,
                  fit: BoxFit.cover,
                ),
                if (asset.type == AssetType.video)
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 3,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        ''.formatDuration(asset.duration),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                BlocBuilder<ImagesPickerBloc, ImagesPickerState>(
                  builder: (context, state) {
                    if (state.selectedAssets.contains(asset)) {
                      return Positioned.fill(
                        child: Container(
                          alignment: Alignment.topRight,
                          padding: const EdgeInsets.only(top: 5, right: 5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 5,
                              color: kPrimaryLightColor,
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: kPrimaryDarkColor,
                            ),
                            child: Text(
                              (state.selectedAssets.indexOf(asset) + 1)
                                  .toString(),
                              style:
                                  CustomTextStyle.bodyMedium(context).copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                )
              ],
            );
          }
          return Container(
            color: kIconColorGrey,
          );
        },
      ),
    );
  }
}
