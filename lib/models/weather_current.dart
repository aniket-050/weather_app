class WeatherCurrent {
  final String cityName;
  final String country;
  final double temperature;
  final String condition;
  final String description;
  final int weatherCode;
  final double windSpeed;
  final double latitude;
  final double longitude;
  final DateTime dateTime;

  WeatherCurrent({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.condition,
    required this.description,
    required this.weatherCode,
    required this.windSpeed,
    required this.latitude,
    required this.longitude,
    required this.dateTime,
  });

  factory WeatherCurrent.fromOpenMeteo({
    required Map<String, dynamic> weatherData,
    required String cityName,
    required String country,
    required double lat,
    required double lon,
  }) {
    final currentWeather = weatherData['current_weather'];
    final weatherCode = currentWeather['weathercode'] as int;

    return WeatherCurrent(
      cityName: cityName,
      country: country,
      temperature: currentWeather['temperature'].toDouble(),
      condition: _getConditionFromCode(weatherCode),
      description: _getDescriptionFromCode(weatherCode),
      weatherCode: weatherCode,
      windSpeed: currentWeather['windspeed'].toDouble(),
      latitude: lat,
      longitude: lon,
      dateTime: DateTime.parse(currentWeather['time']),
    );
  }

  static String _getConditionFromCode(int code) {
    if (code == 0) return 'Clear';
    if (code <= 3) return 'Clouds';
    if (code <= 48) return 'Fog';
    if (code <= 55) return 'Drizzle';
    if (code <= 67) return 'Rain';
    if (code <= 77) return 'Snow';
    if (code <= 82) return 'Rain';
    if (code <= 99) return 'Thunderstorm';
    return 'Clear';
  }

  static String _getDescriptionFromCode(int code) {
    switch (code) {
      case 0: return 'Clear sky';
      case 1: return 'Mainly clear';
      case 2: return 'Partly cloudy';
      case 3: return 'Overcast';
      case 45: case 48: return 'Foggy';
      case 51: return 'Light drizzle';
      case 53: return 'Moderate drizzle';
      case 55: return 'Dense drizzle';
      case 61: return 'Slight rain';
      case 63: return 'Moderate rain';
      case 65: return 'Heavy rain';
      case 71: return 'Slight snow';
      case 73: return 'Moderate snow';
      case 75: return 'Heavy snow';
      case 80: return 'Light rain showers';
      case 81: return 'Moderate rain showers';
      case 82: return 'Violent rain showers';
      case 95: return 'Thunderstorm';
      case 96: case 99: return 'Thunderstorm with hail';
      default: return 'Unknown';
    }
  }

  String get weatherEmoji {
    switch (condition.toLowerCase()) {
      case 'clear':
        return '☀️';
      case 'clouds':
        return '☁️';
      case 'rain':
        return '🌧️';
      case 'drizzle':
        return '🌦️';
      case 'thunderstorm':
        return '⛈️';
      case 'snow':
        return '❄️';
      case 'fog':
        return '🌫️';
      default:
        return '🌤️';
    }
  }

  // Estimated humidity based on weather condition (since Open-Meteo doesn't provide it in free tier)
  int get estimatedHumidity {
    switch (condition.toLowerCase()) {
      case 'rain':
      case 'drizzle':
      case 'thunderstorm':
        return 85;
      case 'fog':
        return 95;
      case 'clouds':
        return 70;
      case 'clear':
        return 45;
      default:
        return 60;
    }
  }

  // Estimated feels like temperature
  double get estimatedFeelsLike {
    // Simple heat index calculation
    double humidity = estimatedHumidity.toDouble();
    if (temperature < 20) return temperature - 2; // Wind chill effect
    if (temperature > 25 && humidity > 60) return temperature + 3; // Heat index
    return temperature;
  }
}