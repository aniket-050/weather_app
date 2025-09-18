import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';
import '../controllers/weather_controller.dart';
import '../services/storage_service.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<SettingsController>();
    final weatherController = Get.find<WeatherController>();

    return Obx(() {
      final isDark = settingsController.isDarkMode.value;

      // Set system UI overlay for this screen
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
      );

      return Scaffold(
        // Extend body behind app bar and to screen edges
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,

        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: isDark ? Color(0xFF16213E) : Color(0xFFF5F5F5),
          ),
          child: SafeArea(
            top: true,
            bottom: false, // Let content extend to bottom
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 15,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      InkWell(onTap: () => Get.back(),

                child: Container(
                  width: 50,
                  height: 50,
                  padding: const EdgeInsets.all(20),
                  child: Icon(
                        Icons.arrow_back,
                        color: isDark ? Colors.white : Color(0xFF1A1A1A),
                      ),
                    ),),
                       Padding(
                         padding: const EdgeInsets.only(top: 10.0,left: 10),
                         child: Text(
                          'Settings',
                          style: TextStyle(
                            color: isDark ? Colors.white:Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                                               ),
                       ),
                    ],
                  ),
                ),
                SizedBox(height: 8),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Theme Section
                      Card(
                        color: isDark ? Color(0xFF1A1A2E) : Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Appearance',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Color(0xFF1A1A1A),
                                ),
                              ),
                              SizedBox(height: 16),
                              SwitchListTile(
                                title: Text(
                                  'Dark Mode',
                                  style: TextStyle(
                                    color: isDark ? Colors.white : Color(0xFF1A1A1A),
                                  ),
                                ),
                                subtitle: Text(
                                  'Switch between light and dark theme',
                                  style: TextStyle(
                                    color: isDark ? Color(0xFFBBBBBB) : Color(0xFF666666),
                                  ),
                                ),
                                value: settingsController.isDarkMode.value,
                                onChanged: (value) => settingsController.toggleDarkMode(),
                                secondary: Icon(
                                  settingsController.isDarkMode.value
                                      ? Icons.dark_mode
                                      : Icons.light_mode,
                                  color: isDark ? Color(0xFF4FC3F7) : Color(0xFF1976D2),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 16),

                      // Temperature Unit Section
                      Card(
                        color: isDark ? Color(0xFF1A1A2E) : Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Temperature Unit',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Color(0xFF1A1A1A),
                                ),
                              ),
                              SizedBox(height: 16),
                              SwitchListTile(
                                title: Text(
                                  'Use Fahrenheit',
                                  style: TextStyle(
                                    color: isDark ? Colors.white : Color(0xFF1A1A1A),
                                  ),
                                ),
                                subtitle: Text(
                                  'Currently using ${settingsController.temperatureUnitName}',
                                  style: TextStyle(
                                    color: isDark ? Color(0xFFBBBBBB) : Color(0xFF666666),
                                  ),
                                ),
                                value: settingsController.temperatureUnit.value == 'fahrenheit',
                                onChanged: (value) {
                                  settingsController.toggleTemperatureUnit();
                                  weatherController.refreshWeather();
                                },
                                secondary: Icon(
                                  Icons.thermostat,
                                  color: isDark ? Color(0xFF4FC3F7) : Color(0xFF1976D2),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 16),

                      // Search History Section
                      Card(
                        color: isDark ? Color(0xFF1A1A2E) : Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Search History',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Color(0xFF1A1A1A),
                                ),
                              ),
                              SizedBox(height: 16),
                              Obx(() {
                                final recentCities = weatherController.recentCities;

                                if (recentCities.isEmpty) {
                                  return ListTile(
                                    leading: Icon(
                                      Icons.history,
                                      color: isDark ? Color(0xFF4FC3F7) : Color(0xFF1976D2),
                                    ),
                                    title: Text(
                                      'No Recent Searches',
                                      style: TextStyle(
                                        color: isDark ? Colors.white : Color(0xFF1A1A1A),
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Search for cities to see them here',
                                      style: TextStyle(
                                        color: isDark ? Color(0xFFBBBBBB) : Color(0xFF666666),
                                      ),
                                    ),
                                  );
                                }

                                return Column(
                                  children: [
                                    ListTile(
                                      leading: Icon(
                                        Icons.history,
                                        color: isDark ? Color(0xFF4FC3F7) : Color(0xFF1976D2),
                                      ),
                                      title: Text(
                                        'Recent Cities',
                                        style: TextStyle(
                                          color: isDark ? Colors.white : Color(0xFF1A1A1A),
                                        ),
                                      ),
                                      subtitle: Text(
                                        '${recentCities.length} cities saved',
                                        style: TextStyle(
                                          color: isDark ? Color(0xFFBBBBBB) : Color(0xFF666666),
                                        ),
                                      ),
                                      trailing: TextButton(
                                        onPressed: () => _showClearRecentCitiesDialog(context, weatherController),
                                        child: Text(
                                          'Clear All',
                                          style: TextStyle(
                                            color: isDark ? Color(0xFF4FC3F7) : Color(0xFF1976D2),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Divider(color: isDark ? Color(0xFF4D4D6C) : Color(0xFFE0E0E0)),
                                    ...recentCities.take(5).map((city) => ListTile(
                                      leading: Icon(
                                        Icons.location_on,
                                        size: 20,
                                        color: isDark ? Color(0xFF4FC3F7) : Color(0xFF1976D2),
                                      ),
                                      title: Text(
                                        city,
                                        style: TextStyle(
                                          color: isDark ? Colors.white : Color(0xFF1A1A1A),
                                        ),
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          size: 18,
                                          color: isDark ? Color(0xFFBBBBBB) : Color(0xFF666666),
                                        ),
                                        onPressed: () => _removeCityFromRecent(city, weatherController),
                                      ),
                                      onTap: () {
                                        weatherController.searchWeather(city);
                                        Get.back();
                                      },
                                    )).toList(),
                                    if (recentCities.length > 5)
                                      ListTile(
                                        leading: Icon(
                                          Icons.more_horiz,
                                          color: isDark ? Color(0xFF4FC3F7) : Color(0xFF1976D2),
                                        ),
                                        title: Text(
                                          '${recentCities.length - 5} more cities...',
                                          style: TextStyle(
                                            color: isDark ? Colors.white : Color(0xFF1A1A1A),
                                          ),
                                        ),
                                        onTap: () => _showAllRecentCities(context, weatherController),
                                      ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 16),

                      // Data Section
                      Card(
                        color: isDark ? Color(0xFF1A1A2E) : Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Data',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Color(0xFF1A1A1A),
                                ),
                              ),
                              SizedBox(height: 16),
                              ListTile(
                                leading: Icon(
                                  Icons.clear_all,
                                  color: isDark ? Color(0xFFFF6B6B) : Color(0xFFD32F2F),
                                ),
                                title: Text(
                                  'Clear All Data',
                                  style: TextStyle(
                                    color: isDark ? Colors.white : Color(0xFF1A1A1A),
                                  ),
                                ),
                                subtitle: Text(
                                  'Remove all saved cities and preferences',
                                  style: TextStyle(
                                    color: isDark ? Color(0xFFBBBBBB) : Color(0xFF666666),
                                  ),
                                ),
                                onTap: () => _showClearDataDialog(context),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 16),

                      // About Section
                      Card(
                        color: isDark ? Color(0xFF1A1A2E) : Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'About',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Color(0xFF1A1A1A),
                                ),
                              ),
                              SizedBox(height: 16),
                              ListTile(
                                leading: Icon(
                                  Icons.info,
                                  color: isDark ? Color(0xFF4FC3F7) : Color(0xFF1976D2),
                                ),
                                title: Text(
                                  'Weatherly',
                                  style: TextStyle(
                                    color: isDark ? Colors.white : Color(0xFF1A1A1A),
                                  ),
                                ),
                                subtitle: Text(
                                  'Version 1.0.0\nBuilt with Flutter & GetX',
                                  style: TextStyle(
                                    color: isDark ? Color(0xFFBBBBBB) : Color(0xFF666666),
                                  ),
                                ),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.cloud,
                                  color: isDark ? Color(0xFF4FC3F7) : Color(0xFF1976D2),
                                ),
                                title: Text(
                                  'Data Source',
                                  style: TextStyle(
                                    color: isDark ? Colors.white : Color(0xFF1A1A1A),
                                  ),
                                ),
                                subtitle: Text(
                                  'Weather data provided by Open-Meteo API',
                                  style: TextStyle(
                                    color: isDark ? Color(0xFFBBBBBB) : Color(0xFF666666),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // CRITICAL: Add bottom padding for system navigation bar
                      SizedBox(height: MediaQuery.of(context).padding.bottom + 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void _removeCityFromRecent(String city, WeatherController weatherController) {
    final storageService = Get.find<StorageService>();
    storageService.removeRecentCity(city);
    weatherController.loadRecentCities();

    Get.snackbar(
      'Removed',
      '$city removed from recent searches',
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
    );
  }

  void _showAllRecentCities(BuildContext context, WeatherController weatherController) {
    final settingsController = Get.find<SettingsController>();
    final isDark = settingsController.isDarkMode.value;

    Get.dialog(
      AlertDialog(
        backgroundColor: isDark ? Color(0xFF1A1A2E) : Colors.white,
        title: Text(
          'All Recent Cities',
          style: TextStyle(
            color: isDark ? Colors.white : Color(0xFF1A1A1A),
          ),
        ),
        content: Container(
          width: double.maxFinite,
          height: 300,
          child: Obx(() => ListView.builder(
            itemCount: weatherController.recentCities.length,
            itemBuilder: (context, index) {
              final city = weatherController.recentCities[index];
              return ListTile(
                leading: Icon(
                  Icons.location_on,
                  color: isDark ? Color(0xFF4FC3F7) : Color(0xFF1976D2),
                ),
                title: Text(
                  city,
                  style: TextStyle(
                    color: isDark ? Colors.white : Color(0xFF1A1A1A),
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: isDark ? Color(0xFFBBBBBB) : Color(0xFF666666),
                  ),
                  onPressed: () => _removeCityFromRecent(city, weatherController),
                ),
                onTap: () {
                  weatherController.searchWeather(city);
                  Get.back();
                  Get.back();
                },
              );
            },
          )),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Close',
              style: TextStyle(
                color: isDark ? Color(0xFF4FC3F7) : Color(0xFF1976D2),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              weatherController.clearRecentCities();
              Get.back();
            },
            child: Text(
              'Clear All',
              style: TextStyle(
                color: isDark ? Color(0xFFFF6B6B) : Color(0xFFD32F2F),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearRecentCitiesDialog(BuildContext context, WeatherController weatherController) {
    final settingsController = Get.find<SettingsController>();
    final isDark = settingsController.isDarkMode.value;

    Get.dialog(
      AlertDialog(
        backgroundColor: isDark ? Color(0xFF1A1A2E) : Colors.white,
        title: Text(
          'Clear Recent Cities',
          style: TextStyle(
            color: isDark ? Colors.white : Color(0xFF1A1A1A),
          ),
        ),
        content: Text(
          'This will remove all recently searched cities. Are you sure?',
          style: TextStyle(
            color: isDark ? Color(0xFFBBBBBB) : Color(0xFF666666),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDark ? Color(0xFF4FC3F7) : Color(0xFF1976D2),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              await weatherController.clearRecentCities();
              Get.back();
              Get.snackbar(
                'Cleared',
                'All recent cities cleared successfully',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: Text(
              'Clear',
              style: TextStyle(
                color: isDark ? Color(0xFFFF6B6B) : Color(0xFFD32F2F),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    final settingsController = Get.find<SettingsController>();
    final isDark = settingsController.isDarkMode.value;

    Get.dialog(
      AlertDialog(
        backgroundColor: isDark ? Color(0xFF1A1A2E) : Colors.white,
        title: Text(
          'Clear All Data',
          style: TextStyle(
            color: isDark ? Colors.white : Color(0xFF1A1A1A),
          ),
        ),
        content: Text(
          'This will remove all saved cities and reset your preferences. Are you sure?',
          style: TextStyle(
            color: isDark ? Color(0xFFBBBBBB) : Color(0xFF666666),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDark ? Color(0xFF4FC3F7) : Color(0xFF1976D2),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final storageService = Get.find<StorageService>();
              await storageService.clearAll();

              final settingsController = Get.find<SettingsController>();
              settingsController.loadSettings();

              final weatherController = Get.find<WeatherController>();
              weatherController.loadLastCity();

              Get.back();
              Get.snackbar(
                'Success',
                'All data cleared successfully',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: Text(
              'Clear',
              style: TextStyle(
                color: isDark ? Color(0xFFFF6B6B) : Color(0xFFD32F2F),
              ),
            ),
          ),
        ],
      ),
    );
  }
}