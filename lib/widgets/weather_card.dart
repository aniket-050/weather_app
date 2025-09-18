import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/weather_current.dart';
import '../controllers/settings_controller.dart';

class WeatherCard extends StatelessWidget {
  final WeatherCurrent weather;
  final bool isDarkMode;

  const WeatherCard({
    Key? key,
    required this.weather,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<SettingsController>();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: _getCardBackground(),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _getCardBorder(),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _getCardShadow(),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Weather icon
          Text(
            weather.weatherEmoji,
            style: TextStyle(fontSize: 80),
          ),

          SizedBox(height: 16),

          // Temperature
          Obx(() => Text(
            '${weather.temperature.round()}${settingsController.temperatureSymbol}',
            style: TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.bold,
              color: _getTemperatureColor(),
            ),
          )),

          SizedBox(height: 8),

          // Location
          Text(
            '${weather.cityName}, ${weather.country}',
            style: TextStyle(
              fontSize: 18,
              color: _getLocationColor(),
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 24),

          // Weather details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDetailItem(
                '${weather.estimatedHumidity}%',
                'Humidity',
              ),
              _buildDetailItem(
                '${weather.windSpeed.round()} km/h',
                'Wind',
              ),
              Obx(() => _buildDetailItem(
                '${weather.estimatedFeelsLike.round()}${settingsController.temperatureSymbol}',
                'Feels like',
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _getDetailValueColor(),
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: _getDetailLabelColor(),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Theme-aware colors
  Color _getCardBackground() {
    return isDarkMode
        ? Color(0xFF2D2D44).withOpacity(0.95)
        : Colors.white.withOpacity(0.9);
  }

  Color _getCardBorder() {
    return isDarkMode
        ? Colors.white.withOpacity(0.1)
        : Colors.white.withOpacity(0.3);
  }

  Color _getCardShadow() {
    return isDarkMode
        ? Colors.black.withOpacity(0.4)
        : Colors.black.withOpacity(0.15);
  }

  Color _getTemperatureColor() {
    return isDarkMode ? Colors.white : Color(0xFF1A1A1A);
  }

  Color _getLocationColor() {
    return isDarkMode
        ? Colors.white.withOpacity(0.9)
        : Color(0xFF555555);
  }

  Color _getDetailValueColor() {
    return isDarkMode ? Colors.white : Color(0xFF1A1A1A);
  }

  Color _getDetailLabelColor() {
    return isDarkMode
        ? Colors.white.withOpacity(0.7)
        : Color(0xFF666666);
  }
}