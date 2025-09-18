import 'package:flutter/material.dart';

class AppColors {
  // Weather condition colors
  static const Color sunnyPrimary = Color(0xFFFFD54F);
  static const Color sunnySecondary = Color(0xFFFF9800);

  static const Color rainyPrimary = Color(0xFF42A5F5);
  static const Color rainySecondary = Color(0xFF1976D2);

  static const Color cloudyPrimary = Color(0xFF4DB6AC);
  static const Color cloudySecondary = Color(0xFF00695C);

  // UI Colors
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBackgroundDark = Color(0xFF2D2D2D);

  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textLight = Color(0xFF888888);

  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFBBBBBB);

  // Gradients
  static const List<Color> sunnyGradient = [sunnyPrimary, sunnySecondary];
  static const List<Color> rainyGradient = [rainyPrimary, rainySecondary];
  static const List<Color> cloudyGradient = [cloudyPrimary, cloudySecondary];

  // Get gradient by weather condition
  static List<Color> getWeatherGradient(String condition) {
    condition = condition.toLowerCase();
    if (condition.contains('rain') || condition.contains('drizzle')) {
      return rainyGradient;
    } else if (condition.contains('cloud') || condition.contains('overcast')) {
      return cloudyGradient;
    } else {
      return sunnyGradient;
    }
  }
}