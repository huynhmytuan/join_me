import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:join_me/data/repositories/media_repository.dart';
import 'package:photo_manager/photo_manager.dart';

part 'images_picker_event.dart';
part 'images_picker_state.dart';

class ImagesPickerBloc extends Bloc<ImagesPickerEvent, ImagesPickerState> {
  ImagesPickerBloc({
    required MediaRepository mediaRepository,
  })  : _mediaRepository = mediaRepository,
        super(const ImagesPickerState()) {
    on<LoadMedias>(_onLoadMedias);
    on<ChangeAlbum>(_onChangeAlbum);
    on<MediaSelected>(_onMediaSelected);
  }

  final MediaRepository _mediaRepository;

  Future<void> _onLoadMedias(
    LoadMedias event,
    Emitter<ImagesPickerState> emit,
  ) async {
    emit(state.copyWith(status: ImagePickersStatus.loading));
    try {
      final albums = await _mediaRepository.fetchAllAlbums();
      final currentAlbum = albums.first;
      final albumMedias = await _mediaRepository.getAllAlbumAssets(
        album: currentAlbum,
      );
      emit(
        state.copyWith(
          albums: albums,
          currentAlbum: currentAlbum,
          medias: albumMedias,
          status: ImagePickersStatus.success,
          selectedAssets: event.initialMedias,
        ),
      );
    } on MediaAssetNotGranted {
      emit(state.copyWith(status: ImagePickersStatus.noPermission));
    }
  }

  Future<void> _onChangeAlbum(
    ChangeAlbum event,
    Emitter<ImagesPickerState> emit,
  ) async {
    if (event.album == state.currentAlbum) {
      return;
    }
    emit(state.copyWith(status: ImagePickersStatus.loading));
    try {
      final currentAlbum = event.album;
      final albumMedias = await _mediaRepository.getAllAlbumAssets(
        album: currentAlbum,
      );
      emit(
        state.copyWith(
          currentAlbum: currentAlbum,
          medias: albumMedias,
          status: ImagePickersStatus.success,
          currentPage: 1,
        ),
      );
    } on MediaAssetNotGranted {
      emit(state.copyWith(status: ImagePickersStatus.noPermission));
    }
  }

  Future<void> _onMediaSelected(
    MediaSelected event,
    Emitter<ImagesPickerState> emit,
  ) async {
    final selections = List<AssetEntity>.from(state.selectedAssets);
    if (selections.contains(event.media)) {
      selections.remove(event.media);
    } else {
      selections.add(event.media);
    }
    emit(state.copyWith(selectedAssets: selections));
  }
}
