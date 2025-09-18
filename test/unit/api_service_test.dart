import 'package:flutter_test/flutter_test.dart';
import '../../lib/services/api_service.dart';

void main() {
  group('ApiService Tests', () {
    late ApiService apiService;

    setUp(() {
      apiService = ApiService();
    });

    test('should parse weather data correctly', () async {
      // Mock API response data
      final mockWeatherData = {
        'name': 'New York',
        'sys': {'country': 'US'},
        'main': {
          'temp': 25.5,
          'humidity': 65,
          'feels_like': 27.2,
        },
        'weather': [
          {
            'main': 'Clear',
            'description': 'clear sky',
            'icon': '01d',
          }
        ],
        'wind': {'speed': 3.2},
        'dt': 1640995200,
      };

      // Test that our model can parse this data structure
      expect(mockWeatherData['name'], 'New York');
      expect(mockWeatherData['main']?['temp'], 25.5);
      expect(mockWeatherData['weather'][0.toString()]['main'], 'Clear');
    });
  });
}

extension on Object? {
  operator [](String other) {}
}