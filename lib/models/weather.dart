/// Represents the current weather conditions for a location.
class CurrentWeather {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final double windSpeed;
  final int windDegree;
  final String condition;
  final String description;
  final int visibility;
  final double uvIndex;
  final DateTime sunrise;
  final DateTime sunset;
  final DateTime lastUpdated;

  const CurrentWeather({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.windSpeed,
    required this.windDegree,
    required this.condition,
    required this.description,
    required this.visibility,
    required this.uvIndex,
    required this.sunrise,
    required this.sunset,
    required this.lastUpdated,
  });
}

/// Represents weather data for a single hour.
class HourlyWeather {
  final DateTime time;
  final double temperature;
  final String condition;
  final int chanceOfRain;

  const HourlyWeather({
    required this.time,
    required this.temperature,
    required this.condition,
    required this.chanceOfRain,
  });
}

/// Represents weather data for a single day.
class DailyWeather {
  final DateTime date;
  final double tempMin;
  final double tempMax;
  final String condition;
  final int chanceOfRain;
  final double uvIndex;

  const DailyWeather({
    required this.date,
    required this.tempMin,
    required this.tempMax,
    required this.condition,
    required this.chanceOfRain,
    required this.uvIndex,
  });
}

/// Bundles current, hourly, and daily weather data together.
class WeatherData {
  final CurrentWeather current;
  final List<HourlyWeather> hourly;
  final List<DailyWeather> daily;

  const WeatherData({
    required this.current,
    required this.hourly,
    required this.daily,
  });
}
