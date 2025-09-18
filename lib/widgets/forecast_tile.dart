import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/weather_forecast.dart';
import '../controllers/settings_controller.dart';

class ForecastTile extends StatelessWidget {
  final WeatherForecast forecast;
  final bool isToday;
  final bool isDarkMode;

  const ForecastTile({
    Key? key,
    required this.forecast,
    this.isToday = false,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<SettingsController>();

    return Container(
      width: 85,
      margin: EdgeInsets.only(right: 8),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: _getCardBackground(),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getCardBorder(),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _getCardShadow(),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Day
          Text(
            isToday ? 'Today' : forecast.dayName,
            style: TextStyle(
              fontSize: 12,
              color: _getDayColor(),
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 6),

          // Weather icon
          Text(
            forecast.weatherEmoji,
            style: TextStyle(fontSize: 28),
          ),

          SizedBox(height: 6),

          // Temperature
          Obx(() => Column(
            children: [
              Text(
                '${forecast.maxTemp.round()}${settingsController.temperatureSymbol}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _getMaxTempColor(),
                ),
              ),
              Text(
                '${forecast.minTemp.round()}${settingsController.temperatureSymbol}',
                style: TextStyle(
                  fontSize: 12,
                  color: _getMinTempColor(),
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }

  // Theme-aware colors
  Color _getCardBackground() {
    return isDarkMode
        ? Color(0xFF2D2D44).withOpacity(0.9)
        : Colors.white.withOpacity(0.85);
  }

  Color _getCardBorder() {
    return isDarkMode
        ? Colors.white.withOpacity(0.1)
        : Colors.white.withOpacity(0.3);
  }

  Color _getCardShadow() {
    return isDarkMode
        ? Colors.black.withOpacity(0.3)
        : Colors.black.withOpacity(0.1);
  }

  Color _getDayColor() {
    return isDarkMode
        ? Colors.white.withOpacity(0.8)
        : Color(0xFF555555);
  }

  Color _getMaxTempColor() {
    return isDarkMode ? Colors.white : Color(0xFF1A1A1A);
  }

  Color _getMinTempColor() {
    return isDarkMode
        ? Colors.white.withOpacity(0.7)
        : Color(0xFF666666);
  }
}