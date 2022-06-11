import 'dart:io';
import 'package:hive/hive.dart';
import 'package:join_me/utilities/keys/setting_box_keys.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class HiveDatabase {
  HiveDatabase._();

  static Box? settingBox;

  static Future<void> checkIfDatabaseInitialized() async {
    //Get application directory
    final databaseDir = await path_provider.getApplicationSupportDirectory();
    //Init hive database in application dir
    Hive.init(databaseDir.path);
    //Check Setting box exits
    if (await Hive.boxExists(SettingBoxKeys.settingBox)) {
      //Open setting box
      settingBox = await Hive.openBox<dynamic>(SettingBoxKeys.settingBox);
    } else {
      await createDatabase();
    }
  }

  static Future<void> createDatabase() async {
    //Get application directory
    final databaseDir = await path_provider.getApplicationSupportDirectory();
    //Init hive database in application dir
    Hive.init(databaseDir.path);
    //Open the database
    settingBox = await Hive.openBox<dynamic>(SettingBoxKeys.settingBox);
  }

  static String getSettingValue({required String settingValueKey}) {
    final settingValue = settingBox?.get(
      SettingBoxKeys.themeSetting,
      defaultValue: 'unknown',
    ) as String;
    return settingValue;
  }

  static void putSettingValue({
    required String settingKey,
    required String settingValue,
  }) {
    settingBox?.put(settingKey, settingValue);
  }
}
