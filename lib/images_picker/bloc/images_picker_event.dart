part of 'images_picker_bloc.dart';

abstract class ImagesPickerEvent extends Equatable {
  const ImagesPickerEvent();

  @override
  List<Object> get props => [];
}

class LoadMedias extends ImagesPickerEvent {
  const LoadMedias({this.initialMedias = const []});
  final List<AssetEntity> initialMedias;
  @override
  List<Object> get props => [initialMedias];
}

class ChangeAlbum extends ImagesPickerEvent {
  const ChangeAlbum({required this.album});

  final AssetPathEntity album;
  @override
  List<Object> get props => [album];
}

class MediaSelected extends ImagesPickerEvent {
  const MediaSelected({required this.media});

  final AssetEntity media;
  @override
  List<Object> get props => [media];
}
