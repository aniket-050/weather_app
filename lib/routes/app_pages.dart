import 'package:get/get.dart';
import 'package:weather_app/views/forecast_screen.dart';
import '../controllers/weather_controller.dart';
import '../views/home_view.dart';
import '../views/forecast_view.dart';
import '../views/settings_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.forecast,
      page: () => const ForecastView(),
    ),
    GetPage(
      name: AppRoutes.forecastScreen,
      page: () =>  const ForecastScreen(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => SettingsView(),
    ),
  ];
}
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WeatherController());
  }
}

