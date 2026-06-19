import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  static const _keyHighContrast = 'high_contrast';
  static const _keyFontSize = 'font_size';

  final RxBool highContrast = false.obs;
  final RxString fontSize = 'normal'.obs; // 'normal' | 'large' | 'xlarge'

  double get fontSizeMultiplier {
    switch (fontSize.value) {
      case 'large': return 1.25;
      case 'xlarge': return 1.50;
      default: return 1.0;
    }
  }

  ThemeMode get themeMode => highContrast.value ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    highContrast.value = prefs.getBool(_keyHighContrast) ?? false;
    fontSize.value = prefs.getString(_keyFontSize) ?? 'normal';
  }

  Future<void> setHighContrast(bool value) async {
    highContrast.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHighContrast, value);
    // Rebuild app theme
    Get.changeThemeMode(themeMode);
  }

  Future<void> setFontSize(String value) async {
    fontSize.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFontSize, value);
  }
}
