import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/weather_controller.dart';
import '../controllers/settings_controller.dart';
import '../models/weather_forecast.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({super.key});

  @override
  _ForecastScreenState createState() =>
      _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen>
    with TickerProviderStateMixin {
  int selectedDayIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late AnimationController _chartAnimationController;
  late Animation<double> _chartAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _chartAnimationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _chartAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _chartAnimationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
    _chartAnimationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _chartAnimationController.dispose();
    super.dispose();
  }

  void _selectDay(int index) {
    setState(() {
      selectedDayIndex = index;
    });
    _animationController.reset();
    _animationController.forward();
  }

  // Theme-aware color scheme
  ColorScheme _getColorScheme(bool isDark) {
    if (isDark) {
      return ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0xFF4FC3F7),
        onPrimary: Colors.white,
        secondary: Color(0xFF29B6F6),
        onSecondary: Colors.white,
        surface: Color(0xFF1A1A2E),
        onSurface: Colors.white,
        background: Color(0xFF16213E),
        onBackground: Colors.white,
        error: Color(0xFFFF6B6B),
        onError: Colors.white,
        surfaceVariant: Color(0xFF2D2D44),
        onSurfaceVariant: Color(0xFFBBBBBB),
        outline: Color(0xFF4D4D6C),
        shadow: Color(0xFF000000),
      );
    } else {
      return ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xFF1976D2),
        onPrimary: Colors.white,
        secondary: Color(0xFF42A5F5),
        onSecondary: Colors.white,
        surface: Colors.white,
        onSurface: Color(0xFF1A1A1A),
        background: Color(0xFFF5F5F5),
        onBackground: Color(0xFF1A1A1A),
        error: Color(0xFFD32F2F),
        onError: Colors.white,
        surfaceVariant: Color(0xFFF8F9FA),
        onSurfaceVariant: Color(0xFF666666),
        outline: Color(0xFFE0E0E0),
        shadow: Color(0xFF000000),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherController = Get.find<WeatherController>();
    final settingsController = Get.find<SettingsController>();

    return Obx(() {
      final isDark = settingsController.isDarkMode.value;
      final colorScheme = _getColorScheme(isDark);

      // Set system UI overlay for this screen
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarContrastEnforced: false,
      ));

      return Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        backgroundColor: colorScheme.background,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: colorScheme.background,
          ),
          child: SafeArea(
            top: true,
            bottom: false,
            child: Column(
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: 15,
                    left: 16,
                    right: 16,
                    bottom: 15,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: colorScheme.onBackground),
                          onPressed: () => Get.back(),
                        ),
                         Text(
                          'Weather Forecast',
                          style: TextStyle(
                            color: isDark? Colors.white:Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                isDark ? Icons.light_mode : Icons.dark_mode,
                                color: colorScheme.onBackground,
                              ),
                              onPressed: settingsController.toggleDarkMode,
                            ),
                            IconButton(
                              icon: Icon(Icons.refresh, color: colorScheme.onBackground),
                              onPressed: () => weatherController.refreshWeather(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Content - FIXED: Removed nested SingleChildScrollView and Expanded conflict
                Expanded(
                  child: Obx(() {
                    if (weatherController.isLoading.value) {
                      return _buildLoadingState(colorScheme);
                    }

                    if (weatherController.hasError.value) {
                      return _buildErrorState(weatherController, colorScheme);
                    }

                    final forecast = weatherController.forecast;
                    if (forecast.isEmpty) {
                      return _buildNoDataState(colorScheme);
                    }

                    return Column(
                      children: [
                        // Day Selection Tabs
                        _buildDayTabs(forecast, settingsController, colorScheme),

                        // Main Content - FIXED: Use Expanded here instead of inside SingleChildScrollView
                        Expanded(
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).padding.bottom + 40,
                            ),
                            child: AnimatedBuilder(
                              animation: _fadeAnimation,
                              builder: (context, child) {
                                return Opacity(
                                  opacity: _fadeAnimation.value,
                                  child: Transform.translate(
                                    offset: Offset(0, 20 * (1 - _fadeAnimation.value)),
                                    child: _buildSelectedDayContent(
                                      forecast[selectedDayIndex],
                                      settingsController,
                                      forecast,
                                      colorScheme,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildLoadingState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            strokeWidth: 3,
          ),
          SizedBox(height: 20),
          Text(
            'Loading detailed forecast...',
            style: TextStyle(
              color: colorScheme.onBackground,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
      WeatherController controller, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: colorScheme.error,
            ),
            SizedBox(height: 20),
            Text(
              'Unable to load forecast',
              style: TextStyle(
                color: colorScheme.onBackground,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              controller.errorMessage.value,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: controller.retrySearch,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoDataState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_off,
            size: 80,
            color: colorScheme.onSurfaceVariant,
          ),
          SizedBox(height: 20),
          Text(
            'No forecast data available',
            style: TextStyle(
              color: colorScheme.onBackground,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayTabs(
      List<WeatherForecast> forecast,
      SettingsController settingsController,
      ColorScheme colorScheme,
      ) {
    return Container(
      height: 120,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: forecast.length,
        itemBuilder: (context, index) {
          final day = forecast[index];
          final isSelected = index == selectedDayIndex;

          return GestureDetector(
            onTap: () => _selectDay(index),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: 90,
              margin: EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                  colors: [colorScheme.primary, colorScheme.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
                    : null,
                color: isSelected ? null : colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.transparent : colorScheme.outline,
                  width: 1,
                ),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  )
                ]
                    : null,
              ),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      index == 0 ? 'Today' : day.dayName,
                      style: TextStyle(
                        color: isSelected
                            ? colorScheme.onPrimary
                            : colorScheme.onSurface,
                        fontSize: 12,
                        fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                    Text(
                      day.weatherEmoji,
                      style: TextStyle(fontSize: 24),
                    ),
                    Obx(() => Text(
                      '${day.maxTemp.round()}°${settingsController.temperatureSymbol.replaceAll('°', '')}',
                      style: TextStyle(
                        color: isSelected
                            ? colorScheme.onPrimary
                            : colorScheme.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectedDayContent(
      WeatherForecast selectedDay,
      SettingsController settingsController,
      List<WeatherForecast> allForecast,
      ColorScheme colorScheme,
      ) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selected Day Header
          _buildSelectedDayHeader(selectedDay, colorScheme),

          SizedBox(height: 30),

          // Temperature Chart
          _buildTemperatureChart(allForecast, settingsController, colorScheme),

          SizedBox(height: 30),

          // Detailed Weather Info Grid
          _buildWeatherInfoGrid(selectedDay, settingsController, colorScheme),

          SizedBox(height: 30),

          // Hourly Forecast Simulation
          _buildHourlyForecast(selectedDay, settingsController, colorScheme),
        ],
      ),
    );
  }

  Widget _buildSelectedDayHeader(
      WeatherForecast selectedDay, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.surfaceVariant, colorScheme.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outline, width: 1),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            DateFormat('EEEE, MMMM dd').format(selectedDay.date),
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text(
            selectedDay.weatherEmoji,
            style: TextStyle(fontSize: 80),
          ),
          SizedBox(height: 16),
          Text(
            selectedDay.description.toUpperCase(),
            style: TextStyle(
              color: colorScheme.primary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemperatureChart(
      List<WeatherForecast> forecast,
      SettingsController settingsController,
      ColorScheme colorScheme,
      ) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outline, width: 1),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.show_chart, color: colorScheme.primary, size: 24),
              SizedBox(width: 12),
              Text(
                'Temperature Trend',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            height: 200,
            child: AnimatedBuilder(
              animation: _chartAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: TemperatureChartPainter(
                    forecast: forecast,
                    selectedIndex: selectedDayIndex,
                    animation: _chartAnimation.value,
                    temperatureUnit: settingsController.temperatureSymbol,
                    colorScheme: colorScheme,
                  ),
                  child: Container(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherInfoGrid(
      WeatherForecast selectedDay,
      SettingsController settingsController,
      ColorScheme colorScheme,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weather Details',
          style: TextStyle(
            color: colorScheme.onBackground,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          childAspectRatio: 1.3,
          children: [
            _buildInfoCard(
              'High Temperature',
              '${selectedDay.maxTemp.round()}${settingsController.temperatureSymbol}',
              Icons.thermostat,
              colorScheme.error,
              colorScheme,
            ),
            _buildInfoCard(
              'Low Temperature',
              '${selectedDay.minTemp.round()}${settingsController.temperatureSymbol}',
              Icons.ac_unit,
              Color(0xFF4ECDC4),
              colorScheme,
            ),
            _buildInfoCard(
              'Weather Code',
              selectedDay.weatherCode.toString(),
              Icons.code,
              colorScheme.secondary,
              colorScheme,
            ),
            _buildInfoCard(
              'Condition',
              selectedDay.condition,
              Icons.wb_cloudy,
              Color(0xFF96CEB4),
              colorScheme,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard(
      String title,
      String value,
      IconData icon,
      Color iconColor,
      ColorScheme colorScheme,
      ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline, width: 1),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 24),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
          Text(
            value,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyForecast(
      WeatherForecast selectedDay,
      SettingsController settingsController,
      ColorScheme colorScheme,
      ) {
    // Simulate hourly data for the selected day
    final hourlyData = _generateHourlyData(selectedDay);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hourly Forecast',
          style: TextStyle(
            color: colorScheme.onBackground,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Container(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: hourlyData.length,
            itemBuilder: (context, index) {
              final hour = hourlyData[index];
              return Container(
                width: 80,
                margin: EdgeInsets.only(right: 12),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colorScheme.outline, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withOpacity(0.05),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      hour['time'],
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      hour['emoji'],
                      style: TextStyle(fontSize: 20),
                    ),
                    Obx(() => Text(
                      '${hour['temp']}${settingsController.temperatureSymbol}',
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _generateHourlyData(WeatherForecast selectedDay) {
    final random = math.Random();
    final baseTemp = (selectedDay.maxTemp + selectedDay.minTemp) / 2;

    return List.generate(8, (index) {
      final hour = 6 + (index * 3); // 6 AM, 9 AM, 12 PM, etc.
      final tempVariation = random.nextDouble() * 6 - 3; // ±3 degrees
      final temp = (baseTemp + tempVariation).round();

      return {
        'time': '${hour.toString().padLeft(2, '0')}:00',
        'temp': temp,
        'emoji': selectedDay.weatherEmoji,
      };
    });
  }
}

//  Custom Painter with Theme Support
class TemperatureChartPainter extends CustomPainter {
  final List<WeatherForecast> forecast;
  final int selectedIndex;
  final double animation;
  final String temperatureUnit;
  final ColorScheme colorScheme;

  TemperatureChartPainter({
    required this.forecast,
    required this.selectedIndex,
    required this.animation,
    required this.temperatureUnit,
    required this.colorScheme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final pointPaint = Paint()..style = PaintingStyle.fill;

    final textPainter = TextPainter()..textDirection = ui.TextDirection.ltr;

    if (forecast.isEmpty) return;

    // Calculate temperature range
    double minTemp = forecast.map((f) => f.minTemp).reduce(math.min);
    double maxTemp = forecast.map((f) => f.maxTemp).reduce(math.max);
    double tempRange = maxTemp - minTemp;
    if (tempRange == 0) tempRange = 1;

    // Calculate positions
    final stepX = size.width / (forecast.length - 1);
    final points = <Offset>[];

    for (int i = 0; i < forecast.length; i++) {
      final x = i * stepX;
      final avgTemp = (forecast[i].maxTemp + forecast[i].minTemp) / 2;
      final y = size.height -
          ((avgTemp - minTemp) / tempRange) * size.height * 0.8 -
          20;
      points.add(Offset(x, y));
    }

    // Draw animated line
    final animatedPoints =
    points.take((points.length * animation).ceil()).toList();

    if (animatedPoints.length > 1) {
      final path = Path();
      path.moveTo(animatedPoints[0].dx, animatedPoints[0].dy);

      for (int i = 1; i < animatedPoints.length; i++) {
        path.lineTo(animatedPoints[i].dx, animatedPoints[i].dy);
      }

      // Draw gradient line with theme colors
      paint.shader = LinearGradient(
        colors: [
          colorScheme.primary,
          colorScheme.secondary,
          colorScheme.primary
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

      canvas.drawPath(path, paint);
    }

    // Draw points and labels
    for (int i = 0; i < animatedPoints.length; i++) {
      final point = animatedPoints[i];
      final isSelected = i == selectedIndex;

      // Point
      pointPaint.color = isSelected ? colorScheme.error : colorScheme.primary;
      canvas.drawCircle(
        point,
        isSelected ? 8 : 6,
        pointPaint,
      );

      // Selected point ring
      if (isSelected) {
        pointPaint.color = colorScheme.error.withOpacity(0.3);
        canvas.drawCircle(point, 12, pointPaint);
      }

      // Temperature label
      final avgTemp = (forecast[i].maxTemp + forecast[i].minTemp) / 2;
      textPainter.text = TextSpan(
        text: '${avgTemp.round()}°',
        style: TextStyle(
          color: isSelected ? colorScheme.error : colorScheme.onSurface,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(point.dx - textPainter.width / 2, point.dy - 25),
      );

      // Day label
      textPainter.text = TextSpan(
        text: i == 0 ? 'Today' : forecast[i].dayName,
        style: TextStyle(
          color: isSelected ? colorScheme.error : colorScheme.onSurfaceVariant,
          fontSize: 10,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(point.dx - textPainter.width / 2, size.height - 15),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}