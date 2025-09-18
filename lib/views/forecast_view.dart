import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/controllers/settings_controller.dart';
import '../controllers/weather_controller.dart';
import '../widgets/forecast_tile.dart';
import '../widgets/animated_background.dart';

class ForecastView extends StatelessWidget {
  const ForecastView({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherController = Get.find<WeatherController>();
    final settingsController = Get.find<SettingsController>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('5-Day Forecast'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        final currentWeather = weatherController.currentWeather.value;
        final condition = currentWeather?.condition ?? 'clear';;
        final isDark = settingsController.isDarkMode.value;

        return AnimatedBackground(
          weatherCondition: condition,
          isDarkMode: isDark,
          child: SafeArea(
            child: weatherController.forecast.isEmpty
                ? Center(
              child: Text(
                'No forecast data available',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            )
                : ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: weatherController.forecast.length,
              itemBuilder: (context, index) {
                final forecast = weatherController.forecast[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 16),
                  child: Card(
                    child: ListTile(
                      leading: Text(
                        forecast.weatherEmoji,
                        style: TextStyle(fontSize: 32),
                      ),
                      title: Text(
                        index == 0 ? 'Today' : forecast.dayName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(forecast.description),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${forecast.maxTemp.round()}°',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${forecast.minTemp.round()}°',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}