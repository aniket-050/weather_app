import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/storage_service.dart';

class SettingsController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  // Observable variables
  var isDarkMode = false.obs;
  var temperatureUnit = 'celsius'.obs; // 'celsius' or 'fahrenheit'

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  void loadSettings() {
    isDarkMode.value = _storageService.getDarkMode();
    temperatureUnit.value = _storageService.getTemperatureUnit();
  }

  void toggleDarkMode() {
    isDarkMode.value = !isDarkMode.value;
    _storageService.saveDarkMode(isDarkMode.value);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleTemperatureUnit() {
    temperatureUnit.value = temperatureUnit.value == 'celsius' ? 'fahrenheit' : 'celsius';
    _storageService.saveTemperatureUnit(temperatureUnit.value);
  }

  String get temperatureSymbol => temperatureUnit.value == 'celsius' ? '°C' : '°F';
  String get temperatureUnitName => temperatureUnit.value == 'celsius' ? 'Celsius' : 'Fahrenheit';
}
