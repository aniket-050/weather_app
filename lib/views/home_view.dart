import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/weather_controller.dart';
import '../controllers/settings_controller.dart';
import '../widgets/animated_background.dart';
import '../widgets/search_input.dart';
import '../widgets/weather_card.dart';
import '../widgets/forecast_tile.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/error_view.dart';
import '../routes/app_routes.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherController = Get.find<WeatherController>();
    final settingsController = Get.find<SettingsController>();

    return Obx(() {
      final currentWeather = weatherController.currentWeather.value;
      final condition = currentWeather?.condition ?? 'clear';
      final isDark = settingsController.isDarkMode.value;

      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
      );

      return Material(
        color: Colors.transparent,
        child: AnimatedBackground(
          weatherCondition: condition,
          isDarkMode: isDark,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: RefreshIndicator(
                onRefresh: weatherController.refreshWeather,
                backgroundColor: isDark ? const Color(0xFF2D2D44) : Colors.white,
                color: isDark ? const Color(0xFF4FC3F7) : const Color(0xFF1976D2),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height,
                    ),
                    child: Column(
                      children: [
                        // Custom App Bar
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top + 15,
                            left: 16,
                            right: 16,
                            bottom: 15,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Weatherly',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        isDark ? Icons.light_mode : Icons.dark_mode,
                                        color: Colors.white,
                                      ),
                                      onPressed: settingsController.toggleDarkMode,
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.settings, color: Colors.white),
                                      onPressed: () => Get.toNamed(AppRoutes.settings),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Search Bar
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SearchInput(),
                        ),

                        const SizedBox(height: 20),

                        // Content based on state
                        _buildMainContent(
                          weatherController,
                          settingsController,
                          currentWeather,
                          isDark,
                          context,
                        ),

                        // Bottom padding for navigation bar
                        SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildMainContent(
      WeatherController weatherController,
      SettingsController settingsController,
      dynamic currentWeather,
      bool isDark,
      BuildContext context,
      ) {
    if (weatherController.isLoading.value) {
      return _buildLoadingContent(isDark, context);
    } else if (weatherController.hasError.value) {
      return _buildErrorContent(weatherController, isDark, context);
    } else if (currentWeather != null) {
      return _buildWeatherContent(weatherController, settingsController, currentWeather, isDark);
    } else {
      return _buildEmptyContent(isDark, context);
    }
  }

  Widget _buildLoadingContent(bool isDark, BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(40),
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF2D2D44).withOpacity(0.9)
                : Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.white.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.3)
                    : Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  isDark ? const Color(0xFF4FC3F7) : const Color(0xFF1976D2),
                ),
                strokeWidth: 3,
              ),
              const SizedBox(height: 20),
              Text(
                'Loading weather data...',
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorContent(WeatherController weatherController, bool isDark, BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF2D2D44).withOpacity(0.9)
                  : Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.white.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.3)
                      : Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.cloud_off,
                  size: 80,
                  color: isDark
                      ? Colors.white.withOpacity(0.8)
                      : const Color(0xFF666666),
                ),
                const SizedBox(height: 20),
                Text(
                  'Oops!',
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  weatherController.errorMessage.value,
                  style: TextStyle(
                    color: isDark
                        ? Colors.white.withOpacity(0.8)
                        : const Color(0xFF666666),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: weatherController.retrySearch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? const Color(0xFF4FC3F7) : const Color(0xFF1976D2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: isDark ? 0 : 4,
                  ),
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyContent(bool isDark, BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(40),
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF2D2D44).withOpacity(0.9)
                : Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.white.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.3)
                    : Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.wb_cloudy,
                size: 80,
                color: isDark
                    ? Colors.white.withOpacity(0.8)
                    : const Color(0xFF666666),
              ),
              const SizedBox(height: 20),
              Text(
                'Welcome to Weatherly',
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Search for a city to see the weather forecast',
                style: TextStyle(
                  color: isDark
                      ? Colors.white.withOpacity(0.8)
                      : const Color(0xFF666666),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherContent(
      WeatherController weatherController,
      SettingsController settingsController,
      dynamic currentWeather,
      bool isDark,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Current Weather Card
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: WeatherCard(
            weather: currentWeather,
            isDarkMode: isDark,
          ),
        ),

        const SizedBox(height: 20),

        // 5-Day Forecast Section
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '5-Day Forecast',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              // Horizontal Forecast Cards
              Container(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: weatherController.forecast.length,
                  itemBuilder: (context, index) {
                    final forecast = weatherController.forecast[index];
                    return Container(
                      margin: const EdgeInsets.only(right: 12),
                      child: ForecastTile(
                        forecast: forecast,
                        isToday: index == 0,
                        isDarkMode: isDark,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),

        // View Detailed Forecast Button
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: GestureDetector(
            onTap: () => Get.toNamed('/forecast-screen'),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF4FC3F7).withOpacity(0.2)
                    : Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF4FC3F7).withOpacity(0.3)
                      : Colors.white.withOpacity(0.4),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withOpacity(0.3)
                        : Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.analytics,
                    color: isDark ? const Color(0xFF4FC3F7) : Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'View Detailed Forecast',
                    style: TextStyle(
                      color: isDark ? const Color(0xFF4FC3F7) : Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.arrow_forward,
                    color: isDark ? const Color(0xFF4FC3F7) : Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 40),
      ],
    );
  }
}