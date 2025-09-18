import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../models/weather_current.dart';
import '../models/weather_forecast.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import 'settings_controller.dart';
import '../constants/app_constants.dart';

class WeatherController extends GetxController {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = Get.find<StorageService>();
  final SettingsController _settingsController = Get.find<SettingsController>();

  // Observable variables
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;
  var currentWeather = Rxn<WeatherCurrent>();
  var forecast = <WeatherForecast>[].obs;
  var searchQuery = ''.obs;
  var recentCities = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadRecentCities();
    loadLastCity();
  }

  void loadRecentCities() {
    recentCities.value = _storageService.getRecentCities();
  }

  void loadLastCity() {
    final lastCity = _storageService.getLastCity() ?? AppConstants.defaultCity;
    searchWeather(lastCity);
  }

  Future<void> searchWeather(String city) async {
    if (city.trim().isEmpty) return;

    searchQuery.value = city;
    isLoading.value = true;
    hasError.value = false;

    try {
      final units = _settingsController.temperatureUnit.value;

      final weatherFuture = _apiService.getCurrentWeather(city, units);
      final forecastFuture = _apiService.getForecast(city, units);

      final results = await Future.wait([weatherFuture, forecastFuture]);

      currentWeather.value = results[0] as WeatherCurrent;
      forecast.value = results[1] as List<WeatherForecast>;

      await _storageService.saveLastCity(city);
      await _storageService.saveRecentCity(city);
      loadRecentCities();

    } catch (e) {
      hasError.value = true;

      // REDUCE ERROR LOGGING IN PRODUCTION
      if (kDebugMode) {
        print('Weather search error: $e');
      }

      if (e.toString().contains('404') || e.toString().contains('City not found')) {
        errorMessage.value = 'City not found. Please check the spelling and try again.';
      } else if (e.toString().contains('Network error') || e.toString().contains('SocketException')) {
        errorMessage.value = 'Network error. Please check your connection and try again.';
      } else {
        errorMessage.value = 'Something went wrong. Please try again later.';
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshWeather() async {
    if (currentWeather.value != null) {
      await searchWeather(currentWeather.value!.cityName);
    } else {
      loadLastCity();
    }
  }

  void retrySearch() {
    if (searchQuery.value.isNotEmpty) {
      searchWeather(searchQuery.value);
    } else {
      loadLastCity();
    }
  }

  Future<void> clearRecentCities() async {
    await _storageService.clearRecentCities();
    loadRecentCities();
  }

  List<String> getFilteredSuggestions(String query) {
    if (query.isEmpty) return recentCities.take(5).toList();

    return recentCities
        .where((city) => city.toLowerCase().contains(query.toLowerCase()))
        .take(5)
        .toList();
  }
}