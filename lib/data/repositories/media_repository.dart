import 'package:photo_manager/photo_manager.dart';

///Throw if media access permission is not granted
class MediaAssetNotGranted implements Exception {}

class MediaRepository {
  Future<bool> _photoPermissionAuth() async {
    final ps = await PhotoManager.requestPermissionExtend();
    return ps.isAuth;
  }

  Future<List<AssetPathEntity>> fetchAllAlbums({
    RequestType? requestType,
  }) async {
    //Check photo permission
    final isAuth = await _photoPermissionAuth();
    if (!isAuth) {
      throw MediaAssetNotGranted();
    }
    return PhotoManager.getAssetPathList(
      type: requestType ?? RequestType.common,
    );
  }

  Future<List<AssetEntity>> getAllAlbumAssets({
    required AssetPathEntity album,
  }) async {
    //Check photo permission
    final isAuth = await _photoPermissionAuth();
    if (!isAuth) {
      throw MediaAssetNotGranted();
    }
    return album.getAssetListRange(start: 0, end: 100000);
  }
}
