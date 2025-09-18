class WeatherForecast {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final String condition;
  final String description;
  final int weatherCode;

  WeatherForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.condition,
    required this.description,
    required this.weatherCode,
  });

  factory WeatherForecast.fromOpenMeteo({
    required String dateStr,
    required double maxTemp,
    required double minTemp,
    required int weatherCode,
  }) {
    return WeatherForecast(
      date: DateTime.parse(dateStr),
      maxTemp: maxTemp,
      minTemp: minTemp,
      condition: _getConditionFromCode(weatherCode),
      description: _getDescriptionFromCode(weatherCode),
      weatherCode: weatherCode,
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

  String get dayName {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final forecastDate = DateTime(date.year, date.month, date.day);

    final difference = forecastDate.difference(today).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Tomorrow';

    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days[date.weekday % 7];
  }
}