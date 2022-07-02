part of 'images_picker_bloc.dart';

enum ImagePickersStatus {
  initial,
  loading,
  success,
  noPermission,
}

class ImagesPickerState extends Equatable {
  const ImagesPickerState({
    this.albums = const [],
    this.currentAlbum,
    this.medias = const [],
    this.status = ImagePickersStatus.initial,
    this.selectLimit,
    this.selectedAssets = const [],
  });

  final List<AssetPathEntity> albums;
  final AssetPathEntity? currentAlbum;
  final List<AssetEntity> medias;
  final ImagePickersStatus status;
  final int? selectLimit;
  final List<AssetEntity> selectedAssets;

  ImagesPickerState copyWith({
    List<AssetPathEntity>? albums,
    AssetPathEntity? currentAlbum,
    List<AssetEntity>? medias,
    int? currentPage,
    int? lastPage,
    List<AssetEntity>? selectedAssets,
    int? selectLimit,
    ImagePickersStatus? status,
  }) {
    return ImagesPickerState(
      albums: albums ?? this.albums,
      currentAlbum: currentAlbum ?? this.currentAlbum,
      medias: medias ?? this.medias,
      selectedAssets: selectedAssets ?? this.selectedAssets,
      selectLimit: selectLimit ?? this.selectLimit,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props {
    return [
      albums,
      medias,
      status,
      selectLimit,
      selectedAssets,
    ];
  }
}
