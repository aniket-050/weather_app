import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';
import 'services/storage_service.dart';
import 'controllers/settings_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // DISABLE DEBUG OVERLAYS AND BANNERS
  if (kDebugMode) {
    debugPaintSizeEnabled = false;
    debugPrintRebuildDirtyWidgets = false;
    debugPrintBuildScope = false;
    debugPrintScheduleFrameStacks = false;
  }

  // SET PREFERRED ORIENTATIONS
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Enable edge-to-edge with immersive mode
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [], // This ensures truly transparent overlays
  );

  // Initialize services
  await Get.putAsync(() => StorageService().init());
  Get.put(SettingsController());

  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<SettingsController>();

    return Obx(() {
      final isDarkMode = settingsController.isDarkMode.value;

      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
          systemNavigationBarDividerColor: Colors.transparent,
          systemNavigationBarContrastEnforced: false,
        ),
      );

      return GetMaterialApp(
        title: 'Weatherly',
        debugShowCheckedModeBanner: false,

        // REMOVE DEBUG OVERLAYS
        showPerformanceOverlay: false,
        showSemanticsDebugger: false,
        checkerboardRasterCacheImages: false,
        checkerboardOffscreenLayers: false,

        // Theme configuration
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

        // Routing
        initialRoute: AppRoutes.home,
        getPages: AppPages.pages,

        // Global builder to handle system UI properly
        builder: (context, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
              statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
              systemNavigationBarColor: Colors.transparent,
              systemNavigationBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
              systemNavigationBarDividerColor: Colors.transparent,
              systemNavigationBarContrastEnforced: false,
            ),
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(1.0),
              ),
              child: GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: child!,
              ),
            ),
          );
        },

        // Localization
        locale: Locale('en', 'US'),
        fallbackLocale: Locale('en', 'US'),

        // Performance optimizations
        smartManagement: SmartManagement.full,

        // Route configuration
        unknownRoute: GetPage(
          name: '/notFound',
          page: () => Scaffold(
            body: Center(
              child: Text('Page not found'),
            ),
          ),
        ),
      );
    });
  }
}

// Global system UI manager
class SystemUIManager {
  static void setTransparentSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarContrastEnforced: false,
      ),
    );
  }

  static void updateForTheme(bool isDarkMode) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarContrastEnforced: false,
      ),
    );
  }
}