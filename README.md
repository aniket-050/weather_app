
# README.md
# 🌤️ Weatherly - Premium Flutter Weather App

A beautiful, modern weather application built with Flutter and GetX state management. Features a premium UI with weather-inspired gradients, animations, and comprehensive weather information powered by **Open-Meteo API** - completely free with no API key required!

## ✨ Features

- **Premium UI Design**: Weather-inspired gradients and animations
- **Current Weather**: Real-time weather data with detailed information
- **5-Day Forecast**: Extended weather forecast with daily breakdowns
- **Search Functionality**: Search weather by city name worldwide
- **Dark/Light Theme**: Toggle between themes with persistent storage
- **Temperature Units**: Switch between Celsius and Fahrenheit
- **Pull to Refresh**: Update weather data with pull gesture
- **Local Storage**: Remembers last searched city
- **Error Handling**: Graceful error states with retry functionality
- **Responsive Design**: Adapts to different screen sizes
- **No API Key Required**: Uses free Open-Meteo API service

## 🌐 Weather Data Source

This app uses **Open-Meteo API**, a free and open-source weather service that provides:
- ✅ **Completely Free** - No API key required
- ✅ **No Registration** - No account creation needed
- ✅ **No Personal Data** - No credit card or personal information
- ✅ **High Quality Data** - Professional weather forecasting
- ✅ **Global Coverage** - Weather data for cities worldwide
- ✅ **Real-time Updates** - Current weather and forecasts

## 🏗️ Technical Stack

- **Framework**: Flutter 3.10+
- **State Management**: GetX
- **Networking**: HTTP package
- **Storage**: SharedPreferences
- **Animations**: Custom animations with Lottie support
- **Architecture**: Clean architecture with GetX pattern
- **Weather API**: Open-Meteo (Free, no API key)

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.10.0 or higher
- Dart 3.0.0 or higher
- Android Studio / VS Code
- Android SDK / Xcode (for iOS)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/weather_app.git
cd weather_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

**No API key setup required!** The app uses Open-Meteo's free service.

### Building APK

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release
```

The APK will be available in `build/app/outputs/flutter-apk/`

## 🧪 Testing

Run unit tests:
```bash
flutter test test/unit/
```

Run widget tests:
```bash
flutter test test/widget/
```

Run all tests:
```bash
flutter test
```

## 📱 Screenshots

The app features:
- **Home Screen**: Search bar, current weather card, and 5-day forecast
- **Settings Screen**: Theme toggle, temperature unit selection, and data management
- **Error States**: Friendly error messages with retry options
- **Loading States**: Smooth shimmer loading animations

## 🎨 UI Components

- **Animated Backgrounds**: Dynamic gradients based on weather conditions
- **Weather Cards**: Clean, modern cards with weather information
- **Forecast Tiles**: Horizontal scrollable forecast items
- **Search Input**: Elegant search bar with animations
- **Loading Shimmer**: Professional loading states

## 🔧 Configuration

### Weather Conditions Mapping

The app maps weather conditions to:
- **Colors**: Dynamic gradient backgrounds
- **Icons**: Weather-appropriate emojis
- **Animations**: Subtle particle effects

### Storage Keys

- `last_city`: Last searched city
- `temperature_unit`: Celsius/Fahrenheit preference (`celsius` or `fahrenheit`)
- `dark_mode`: Theme preference

### Temperature Units

- **Celsius**: Default unit (`celsius`)
- **Fahrenheit**: Alternative unit (`fahrenheit`)

## 📦 Dependencies

```yaml
dependencies:
  get: ^4.6.6              # State management
  http: ^1.1.0             # HTTP requests
  shared_preferences: ^2.2.2 # Local storage
  flutter_svg: ^2.0.9      # SVG icons
  lottie: ^2.7.0           # Animations
  shimmer: ^3.0.0          # Loading effects
  intl: ^0.19.0            # Date formatting
```

## 🌟 Why Open-Meteo?

- **100% Free**: Never pay for weather data
- **No Limits**: Unlimited API calls
- **Privacy Focused**: No tracking or data collection
- **Open Source**: Transparent and community-driven
- **Professional Quality**: Used by meteorologists worldwide
- **Global Coverage**: Weather for any location
- **Real-time Data**: Always up-to-date information

## 🚀 Deployment

### Android

1. Update `android/app/build.gradle` with your signing config
2. Build release APK: `flutter build apk --release`
3. Build AAB for Play Store: `flutter build appbundle --release`

### iOS

1. Configure signing in Xcode
2. Build for iOS: `flutter build ios --release`

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Open-Meteo for free weather data API
- Flutter team for the amazing framework
- GetX team for the powerful state management solution
- Material Design for UI inspiration

## 📞 Support

For support, email your-email@example.com or open an issue on GitHub.

---

**Built with ❤️ using Flutter & GetX | Powered by Open-Meteo Free API**