import '../models/weather.dart';

/// Provides sample weather data for demonstration purposes.
///
/// In a production app this service would call a real weather API
/// (e.g. OpenWeatherMap) and parse the JSON response.
class WeatherService {
  /// Returns mock [WeatherData] for [cityName].
  ///
  /// The data is generated deterministically from the city name so that
  /// different cities appear to have different weather conditions.
  WeatherData getMockWeatherData(String cityName) {
    final now = DateTime.now();
    final hash = cityName.codeUnits.fold<int>(0, (a, b) => a + b);

    final conditions = [
      'Clear',
      'Clouds',
      'Rain',
      'Thunderstorm',
      'Snow',
      'Mist',
    ];
    final descriptions = [
      'Clear sky',
      'Partly cloudy',
      'Light rain',
      'Thunderstorm with rain',
      'Light snow',
      'Misty',
    ];

    final conditionIndex = hash % conditions.length;
    final baseTemp = 15.0 + (hash % 20);

    final current = CurrentWeather(
      cityName: cityName,
      country: 'US',
      temperature: baseTemp,
      feelsLike: baseTemp - 2,
      tempMin: baseTemp - 4,
      tempMax: baseTemp + 5,
      humidity: 55 + (hash % 35),
      windSpeed: 5.0 + (hash % 15),
      windDegree: hash % 360,
      condition: conditions[conditionIndex],
      description: descriptions[conditionIndex],
      visibility: 8000 + (hash % 2000),
      uvIndex: 1.0 + (hash % 9),
      sunrise: DateTime(now.year, now.month, now.day, 6, 30),
      sunset: DateTime(now.year, now.month, now.day, 19, 45),
      lastUpdated: now,
    );

    final hourly = List.generate(24, (i) {
      final variation = (i % 6 - 3).toDouble();
      final hourConditions = [
        'Clear',
        'Clear',
        'Clouds',
        'Clouds',
        'Rain',
        'Clear',
      ];
      return HourlyWeather(
        time: now.add(Duration(hours: i)),
        temperature: baseTemp + variation,
        condition: hourConditions[(i + conditionIndex) % hourConditions.length],
        chanceOfRain: conditionIndex >= 2 ? 30 + (i % 40) : (i % 20),
      );
    });

    final dailyConditionList = [
      'Clear',
      'Clouds',
      'Rain',
      'Clear',
      'Clouds',
      'Thunderstorm',
      'Clear',
    ];
    final daily = List.generate(7, (i) {
      return DailyWeather(
        date: now.add(Duration(days: i)),
        tempMin: baseTemp - 5 + (i % 3),
        tempMax: baseTemp + 4 + (i % 4),
        condition: dailyConditionList[(conditionIndex + i) % dailyConditionList.length],
        chanceOfRain: conditionIndex >= 2 ? 20 + (i * 8 % 60) : (i * 5 % 30),
        uvIndex: 1.0 + (i % 9),
      );
    });

    return WeatherData(current: current, hourly: hourly, daily: daily);
  }

  /// Returns a list of popular city names for the search suggestions.
  List<String> get popularCities => const [
        'New York',
        'Los Angeles',
        'Chicago',
        'Houston',
        'London',
        'Paris',
        'Tokyo',
        'Sydney',
        'Dubai',
        'Toronto',
      ];
}
