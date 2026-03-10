# fnba-mobile-apps-flutter-poc

A sample **Flutter weather app** for iOS and Android.

## Features

- 🌡️ Current weather with temperature, feels-like, high/low
- 🕐 24-hour hourly forecast (horizontal scroll)
- 📅 7-day daily forecast with temperature range bars
- 💧 Weather details: humidity, wind speed & direction, visibility, sunrise/sunset
- 🌈 Dynamic gradient background that changes with weather condition and time of day
- 🔍 City search with popular city suggestions
- 📱 Runs on both **iOS** (12+) and **Android** (API 21+)

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) ≥ 3.10.0
- Dart ≥ 3.0.0
- Android Studio / Xcode (for device/emulator builds)

### Run the app

```bash
# Install dependencies
flutter pub get

# Run on a connected device or emulator
flutter run

# Run tests
flutter test
```

## Project structure

```
lib/
├── main.dart                     # App entry point
├── models/
│   └── weather.dart              # Data models (CurrentWeather, HourlyWeather, DailyWeather)
├── screens/
│   └── home_screen.dart          # Main weather screen + city search sheet
├── services/
│   └── weather_service.dart      # Mock weather data provider
├── theme/
│   └── weather_theme.dart        # Colours, icons, and gradient helpers
└── widgets/
    └── weather_widgets.dart      # Reusable UI components

android/                          # Android platform files
ios/                              # iOS platform files
test/
└── widget_test.dart              # Unit and widget tests
```

## Notes

This is a **proof-of-concept** that uses deterministic mock data so it works
without an API key. To connect to a real weather API (e.g. OpenWeatherMap),
replace `WeatherService.getMockWeatherData()` with an HTTP call and parse the
JSON response into the existing model classes.