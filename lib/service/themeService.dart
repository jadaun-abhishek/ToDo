import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class ThemeService {
  // instance of GetStorage used to read and write data
  final _box = GetStorage();

  final _key = 'isDarkMode';

  // method to write data
  _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  // method to read data
  bool _loadThemeFromBox() => _box.read(_key) ?? false;

  // theme loads current theme mode
  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  void switchTheme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
  }
}
