import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_current.dart';
import '../models/weather_forecast.dart';
import '../constants/app_constants.dart';

class LocationData {
  final double latitude;
  final double longitude;
  final String name;
  final String country;

  LocationData({
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.country,
  });
}

class ApiService {
  static const String _weatherBaseUrl = AppConstants.weatherBaseUrl;
  static const String _geocodingBaseUrl = AppConstants.geocodingBaseUrl;

  // Geocoding: Get coordinates from city name
  Future<LocationData> getLocationFromCity(String city) async {
    final url = '$_geocodingBaseUrl/search?name=${Uri.encodeComponent(city)}&count=1&language=en&format=json';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;

        if (results.isEmpty) {
          throw Exception('City not found');
        }

        final location = results[0];
        return LocationData(
          latitude: location['latitude'].toDouble(),
          longitude: location['longitude'].toDouble(),
          name: location['name'] ?? city,
          country: location['country'] ?? '',
        );
      } else {
        throw Exception('Failed to geocode city: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('City not found')) {
        throw Exception('City "$city" not found. Please check the spelling and try again.');
      }
      throw Exception('Network error: $e');
    }
  }

  // Get current weather using coordinates
  Future<WeatherCurrent> getCurrentWeather(String city, String units) async {
    try {
      // First get coordinates
      final location = await getLocationFromCity(city);

      // Then get weather data
      final tempUnit = units == 'fahrenheit' ? 'fahrenheit' : 'celsius';
      final windUnit = units == 'fahrenheit' ? 'mph' : 'kmh';

      final url = '$_weatherBaseUrl/forecast?'
          'latitude=${location.latitude}&'
          'longitude=${location.longitude}&'
          'current_weather=true&'
          'temperature_unit=$tempUnit&'
          'windspeed_unit=$windUnit&'
          'timezone=auto';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        return WeatherCurrent.fromOpenMeteo(
          weatherData: data,
          cityName: location.name,
          country: location.country,
          lat: location.latitude,
          lon: location.longitude,
        );
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      throw e; // Re-throw to preserve error messages
    }
  }

  // Get 7-day forecast (we'll take first 5 days)
  Future<List<WeatherForecast>> getForecast(String city, String units) async {
    try {
      // First get coordinates
      final location = await getLocationFromCity(city);

      // Then get forecast data
      final tempUnit = units == 'fahrenheit' ? 'fahrenheit' : 'celsius';

      final url = '$_weatherBaseUrl/forecast?'
          'latitude=${location.latitude}&'
          'longitude=${location.longitude}&'
          'daily=temperature_2m_max,temperature_2m_min,weathercode&'
          'temperature_unit=$tempUnit&'
          'timezone=auto';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final daily = data['daily'];

        final List<String> dates = List<String>.from(daily['time']);
        final List<double> maxTemps = List<double>.from(
            daily['temperature_2m_max'].map((temp) => temp.toDouble())
        );
        final List<double> minTemps = List<double>.from(
            daily['temperature_2m_min'].map((temp) => temp.toDouble())
        );
        final List<int> weatherCodes = List<int>.from(daily['weathercode']);

        final List<WeatherForecast> forecasts = [];

        // Take first 5 days
        for (int i = 0; i < 5 && i < dates.length; i++) {
          forecasts.add(WeatherForecast.fromOpenMeteo(
            dateStr: dates[i],
            maxTemp: maxTemps[i],
            minTemp: minTemps[i],
            weatherCode: weatherCodes[i],
          ));
        }

        return forecasts;
      } else {
        throw Exception('Failed to load forecast data: ${response.statusCode}');
      }
    } catch (e) {
      throw e; // Re-throw to preserve error messages
    }
  }
}