import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

class AppTheme {
  // Light theme colors
  static const _lightBackgroundColor = Color(0xFFF5F5F5);
  static const _lightSurfaceColor = Colors.white;
  static const _lightSurfaceVariantColor = Color(0xFFF8F9FA);
  static const _lightPrimaryColor = Color(0xFF1976D2);
  static const _lightSecondaryColor = Color(0xFF42A5F5);
  static const _lightOnBackgroundColor = Color(0xFF1A1A1A);
  static const _lightOnSurfaceColor = Color(0xFF1A1A1A);
  static const _lightOnSurfaceVariantColor = Color(0xFF666666);
  static const _lightOutlineColor = Color(0xFFE0E0E0);
  static const _lightErrorColor = Color(0xFFD32F2F);

  // Dark theme colors
  static const _darkBackgroundColor = Color(0xFF16213E);
  static const _darkSurfaceColor = Color(0xFF1A1A2E);
  static const _darkSurfaceVariantColor = Color(0xFF2D2D44);
  static const _darkPrimaryColor = Color(0xFF4FC3F7);
  static const _darkSecondaryColor = Color(0xFF29B6F6);
  static const _darkOnBackgroundColor = Colors.white;
  static const _darkOnSurfaceColor = Colors.white;
  static const _darkOnSurfaceVariantColor = Color(0xFFBBBBBB);
  static const _darkOutlineColor = Color(0xFF4D4D6C);
  static const _darkErrorColor = Color(0xFFFF6B6B);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      fontFamily: 'SF Pro Display',

      // Define color scheme
      colorScheme: ColorScheme.light(
        brightness: Brightness.light,
        primary: _lightPrimaryColor,
        onPrimary: Colors.white,
        secondary: _lightSecondaryColor,
        onSecondary: Colors.white,
        surface: _lightSurfaceColor,
        onSurface: _lightOnSurfaceColor,
        background: _lightBackgroundColor,
        onBackground: _lightOnBackgroundColor,
        error: _lightErrorColor,
        onError: Colors.white,
        surfaceVariant: _lightSurfaceVariantColor,
        onSurfaceVariant: _lightOnSurfaceVariantColor,
        outline: _lightOutlineColor,
      ),

      // Scaffold theme for consistent background
      scaffoldBackgroundColor: _lightBackgroundColor,

      // AppBar theme with proper background handling
      appBarTheme: AppBarTheme(
        backgroundColor: _lightBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: _lightOnBackgroundColor),
        titleTextStyle: TextStyle(
          color: _lightOnBackgroundColor,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          fontFamily: 'SF Pro Display',
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: _lightBackgroundColor,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: _lightSurfaceColor,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Switch theme for settings toggles
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return _lightPrimaryColor;
          }
          return Colors.grey.shade400;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return _lightPrimaryColor.withOpacity(0.5);
          }
          return Colors.grey.shade300;
        }),
      ),

      // Text theme
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 64,
          fontWeight: FontWeight.bold,
          color: _lightOnBackgroundColor,
          fontFamily: 'SF Pro Display',
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: _lightOnBackgroundColor,
          fontFamily: 'SF Pro Display',
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: _lightOnBackgroundColor,
          fontFamily: 'SF Pro Display',
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: _lightOnBackgroundColor,
          fontFamily: 'SF Pro Display',
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: _lightOnSurfaceVariantColor,
          fontFamily: 'SF Pro Display',
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: _lightOnSurfaceVariantColor,
          fontFamily: 'SF Pro Display',
        ),
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _lightPrimaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _lightPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      fontFamily: 'SF Pro Display',

      // Define color scheme
      colorScheme: ColorScheme.dark(
        brightness: Brightness.dark,
        primary: _darkPrimaryColor,
        onPrimary: Colors.white,
        secondary: _darkSecondaryColor,
        onSecondary: Colors.white,
        surface: _darkSurfaceColor,
        onSurface: _darkOnSurfaceColor,
        background: _darkBackgroundColor,
        onBackground: _darkOnBackgroundColor,
        error: _darkErrorColor,
        onError: Colors.white,
        surfaceVariant: _darkSurfaceVariantColor,
        onSurfaceVariant: _darkOnSurfaceVariantColor,
        outline: _darkOutlineColor,
      ),

      // Scaffold theme for consistent background
      scaffoldBackgroundColor: _darkBackgroundColor,

      // AppBar theme with proper background handling
      appBarTheme: AppBarTheme(
        backgroundColor: _darkBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: _darkOnBackgroundColor),
        titleTextStyle: TextStyle(
          color: _darkOnBackgroundColor,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          fontFamily: 'SF Pro Display',
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: _darkBackgroundColor,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: _darkSurfaceColor,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Switch theme for settings toggles
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return _darkPrimaryColor;
          }
          return Colors.grey.shade600;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return _darkPrimaryColor.withOpacity(0.5);
          }
          return Colors.grey.shade700;
        }),
      ),

      // Text theme
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 64,
          fontWeight: FontWeight.bold,
          color: _darkOnBackgroundColor,
          fontFamily: 'SF Pro Display',
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: _darkOnBackgroundColor,
          fontFamily: 'SF Pro Display',
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: _darkOnBackgroundColor,
          fontFamily: 'SF Pro Display',
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: _darkOnBackgroundColor,
          fontFamily: 'SF Pro Display',
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: _darkOnSurfaceVariantColor,
          fontFamily: 'SF Pro Display',
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: _darkOnSurfaceVariantColor,
          fontFamily: 'SF Pro Display',
        ),
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkPrimaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _darkPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  // Method to get system UI overlay style based on theme
  static SystemUiOverlayStyle getSystemUiOverlayStyle(bool isDarkMode) {
    if (isDarkMode) {
      return SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: _darkBackgroundColor,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: Colors.transparent,
      );
    } else {
      return SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: _lightBackgroundColor,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
      );
    }
  }

  // Method to get background colors for external use
  static Color getLightBackgroundColor() => _lightBackgroundColor;
  static Color getDarkBackgroundColor() => _darkBackgroundColor;
}