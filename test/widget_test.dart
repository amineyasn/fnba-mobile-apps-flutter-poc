import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:weather_app/main.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/theme/weather_theme.dart';

void main() {
  group('WeatherService', () {
    late WeatherService service;

    setUp(() {
      service = WeatherService();
    });

    test('getMockWeatherData returns WeatherData for given city', () {
      final data = service.getMockWeatherData('New York');
      expect(data.current.cityName, 'New York');
      expect(data.hourly.length, 24);
      expect(data.daily.length, 7);
    });

    test('getMockWeatherData temperature is within reasonable range', () {
      final data = service.getMockWeatherData('London');
      expect(data.current.temperature, greaterThanOrEqualTo(-10));
      expect(data.current.temperature, lessThanOrEqualTo(50));
    });

    test('getMockWeatherData humidity is 0-100', () {
      final data = service.getMockWeatherData('Tokyo');
      expect(data.current.humidity, inInclusiveRange(0, 100));
    });

    test('getMockWeatherData hourly times are sequential', () {
      final data = service.getMockWeatherData('Paris');
      for (int i = 1; i < data.hourly.length; i++) {
        expect(
          data.hourly[i].time.isAfter(data.hourly[i - 1].time),
          isTrue,
        );
      }
    });

    test('getMockWeatherData daily dates are sequential', () {
      final data = service.getMockWeatherData('Sydney');
      for (int i = 1; i < data.daily.length; i++) {
        expect(
          data.daily[i].date.isAfter(data.daily[i - 1].date),
          isTrue,
        );
      }
    });

    test('popularCities returns non-empty list', () {
      expect(service.popularCities, isNotEmpty);
    });
  });

  group('weatherTheme helpers', () {
    test('weatherIcon returns sunny icon for clear condition', () {
      final icon = weatherIcon('Clear');
      expect(icon, Icons.wb_sunny);
    });

    test('weatherIcon returns night icon when isNight is true', () {
      final icon = weatherIcon('Clear', isNight: true);
      expect(icon, Icons.nightlight_round);
    });

    test('weatherIcon returns rain icon for rain condition', () {
      final icon = weatherIcon('Rain');
      expect(icon, Icons.grain);
    });

    test('backgroundGradient returns dark colours at night', () {
      final gradient = backgroundGradient('Clear', isNight: true);
      expect(gradient.length, 2);
      // Night gradient should be dark
      expect(gradient[0].computeLuminance(), lessThan(0.1));
    });

    test('windDirection converts degrees to compass point', () {
      expect(windDirection(0), 'N');
      expect(windDirection(90), 'E');
      expect(windDirection(180), 'S');
      expect(windDirection(270), 'W');
    });
  });

  group('Widget smoke tests', () {
    testWidgets('WeatherApp renders without error', (tester) async {
      await tester.pumpWidget(const WeatherApp());
      await tester.pump(); // let the fade animation begin

      // The app should at least show a temperature degree symbol
      expect(find.textContaining('°'), findsWidgets);
    });

    testWidgets('HomeScreen shows a location icon', (tester) async {
      await tester.pumpWidget(const WeatherApp());
      await tester.pump();

      expect(find.byIcon(Icons.location_on), findsOneWidget);
    });

    testWidgets('HomeScreen shows search icon', (tester) async {
      await tester.pumpWidget(const WeatherApp());
      await tester.pump();

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('Tapping search opens city sheet', (tester) async {
      await tester.pumpWidget(const WeatherApp());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      expect(find.text('Select City'), findsOneWidget);
    });

    testWidgets('City search sheet filters cities', (tester) async {
      await tester.pumpWidget(const WeatherApp());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'London');
      await tester.pump();

      expect(find.text('London'), findsOneWidget);
      expect(find.text('New York'), findsNothing);
    });
  });
}
