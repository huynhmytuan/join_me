import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:join_me/data/services/hive_database.dart';
import 'package:join_me/utilities/keys/setting_box_keys.dart';
import 'package:json_annotation/json_annotation.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState.initial());

  void initialThemeSetting() {
    ThemeMode? themeMode;
    final themeSettingValue = HiveDatabase.getSettingValue(
      settingValueKey: SettingBoxKeys.themeSetting,
    );
    //Return ThemeMode from setting
    themeMode = _$ThemeSettingMap[themeSettingValue];
    emit(state.copyWith(themeMode: themeMode));
    //Put enum value to database
    HiveDatabase.putSettingValue(
      settingKey: SettingBoxKeys.themeSetting,
      settingValue: themeMode!.name,
    );
  }

  void setLightTheme() {
    emit(state.copyWith(themeMode: ThemeMode.light));
    //Put enum value to database
    HiveDatabase.putSettingValue(
      settingKey: SettingBoxKeys.themeSetting,
      settingValue: ThemeMode.light.name,
    );
  }

  void setDarkTheme() {
    emit(state.copyWith(themeMode: ThemeMode.dark));
    //Put enum value to database
    HiveDatabase.putSettingValue(
      settingKey: SettingBoxKeys.themeSetting,
      settingValue: ThemeMode.dark.name,
    );
  }

  void setSystem() {
    emit(state.copyWith(themeMode: ThemeMode.system));
    //Put enum value to database
    HiveDatabase.putSettingValue(
      settingKey: SettingBoxKeys.themeSetting,
      settingValue: ThemeMode.system.name,
    );
  }
}

const _$ThemeSettingMap = {
  'system': ThemeMode.system,
  'light': ThemeMode.light,
  'dark': ThemeMode.dark,
  'unknown': ThemeMode.system,
};
