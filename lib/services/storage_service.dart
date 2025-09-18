import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // Save last searched city
  Future<bool> saveLastCity(String city) async {
    return await _prefs.setString('last_city', city);
  }

  // Get last searched city
  String? getLastCity() {
    return _prefs.getString('last_city');
  }

  //  Save recent searched cities (up to 10)
  Future<bool> saveRecentCity(String city) async {
    List<String> recentCities = getRecentCities();

    // Remove if already exists to avoid duplicates
    recentCities.removeWhere((c) => c.toLowerCase() == city.toLowerCase());

    // Add to the beginning
    recentCities.insert(0, city);

    // Keep only last 10 cities
    if (recentCities.length > 10) {
      recentCities = recentCities.take(10).toList();
    }

    return await _prefs.setStringList('recent_cities', recentCities);
  }

  //  Get recent searched cities
  List<String> getRecentCities() {
    return _prefs.getStringList('recent_cities') ?? [];
  }

  //  Clear recent cities
  Future<bool> clearRecentCities() async {
    return await _prefs.remove('recent_cities');
  }

  // Save temperature unit (celsius or fahrenheit)
  Future<bool> saveTemperatureUnit(String unit) async {
    return await _prefs.setString('temperature_unit', unit);
  }

  // Get temperature unit
  String getTemperatureUnit() {
    return _prefs.getString('temperature_unit') ?? 'celsius';
  }

  // Save dark mode preference
  Future<bool> saveDarkMode(bool isDark) async {
    return await _prefs.setBool('dark_mode', isDark);
  }

  // Get dark mode preference
  bool getDarkMode() {
    return _prefs.getBool('dark_mode') ?? false;
  }

  // Clear all data
  Future<bool> clearAll() async {
    return await _prefs.clear();
  }

  Future<bool> removeRecentCity(String city) async {
    List<String> recentCities = getRecentCities();
    recentCities.removeWhere((c) => c.toLowerCase() == city.toLowerCase());
    return await _prefs.setStringList('recent_cities', recentCities);
  }


}
