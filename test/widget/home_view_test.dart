import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import '../../lib/views/home_view.dart';
import '../../lib/controllers/weather_controller.dart';
import '../../lib/controllers/settings_controller.dart';
import '../../lib/services/storage_service.dart';

void main() {
  group('HomeView Widget Tests', () {
    setUp(() {
      // Initialize GetX services for testing
      Get.testMode = true;
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('should display search input', (WidgetTester tester) async {
      // Setup mock controllers
      Get.put(StorageService());
      Get.put(SettingsController());
      Get.put(WeatherController());

      await tester.pumpWidget(
        GetMaterialApp(
          home: HomeView(),
        ),
      );

      // Verify search input is present
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search city...'), findsOneWidget);
    });

    testWidgets('should display app title', (WidgetTester tester) async {
      Get.put(StorageService());
      Get.put(SettingsController());
      Get.put(WeatherController());

      await tester.pumpWidget(
        GetMaterialApp(
          home: HomeView(),
        ),
      );

      expect(find.text('Weatherly'), findsOneWidget);
    });
  });
}