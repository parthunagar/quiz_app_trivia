import 'package:flutterquiz/utils/constants/constants.dart';
import 'package:flutterquiz/utils/constants/string_labels.dart';
import 'package:hive/hive.dart';

class SettingsLocalDataSource {
  bool? showIntroSlider() {
    return Hive.box(settingsBox).get(showIntroSliderKey, defaultValue: false);
  }

  Future<void> setShowIntroSlider(bool value) async {
    Hive.box(settingsBox).put(showIntroSliderKey, value);
  }

  bool? sound() {
    return Hive.box(settingsBox).get(soundKey, defaultValue: true);
  }

  Future<void> setSound(bool value) async {
    Hive.box(settingsBox).put(soundKey, value);
  }

  bool? backgroundMusic() {
    return Hive.box(settingsBox).get(backgroundMusicKey, defaultValue: true);
  }

  Future<void> setbackgroundMusic(bool value) async {
    Hive.box(settingsBox).put(backgroundMusicKey, value);
  }

  bool? vibration() {
    return Hive.box(settingsBox).get(vibrationKey, defaultValue: true);
  }

  Future<void> setVibration(bool value) async {
    Hive.box(settingsBox).put(vibrationKey, value);
  }

  String? languageCode() {
    return Hive.box(settingsBox)
        .get(languageCodeKey, defaultValue: defaultLanguageCode); //
  }

  Future<void> setLanguageCode(String value) async {
    Hive.box(settingsBox).put(languageCodeKey, value);
  }

  double? playAreaFontSize() {
    return Hive.box(settingsBox).get(fontSizeKey, defaultValue: 16.0); //
  }

  Future<void> setPlayAreaFontSize(double value) async {
    Hive.box(settingsBox).put(fontSizeKey, value);
  }

  bool rewardEarned() {
    return Hive.box(settingsBox).get(rewardEarnedKey, defaultValue: false);
  }

  Future<void> setRewardEarned(bool value) async {
    Hive.box(settingsBox).put(rewardEarnedKey, value);
  }

  String theme() {
    return Hive.box(settingsBox)
        .get(settingsThemeKey, defaultValue: darkThemeKey);
  }

  Future<void> setTheme(String value) async {
    Hive.box(settingsBox).put(settingsThemeKey, value);
  }
}
