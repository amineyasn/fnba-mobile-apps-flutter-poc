import 'package:flutter/material.dart';

/// Returns the appropriate weather icon for the given [condition] string.
IconData weatherIcon(String condition, {bool isNight = false}) {
  switch (condition.toLowerCase()) {
    case 'clear':
      return isNight ? Icons.nightlight_round : Icons.wb_sunny;
    case 'clouds':
      return isNight ? Icons.nights_stay : Icons.wb_cloudy;
    case 'rain':
    case 'drizzle':
      return Icons.grain;
    case 'thunderstorm':
      return Icons.thunderstorm;
    case 'snow':
      return Icons.ac_unit;
    case 'mist':
    case 'fog':
    case 'haze':
      return Icons.cloud_queue;
    default:
      return Icons.wb_sunny;
  }
}

/// Returns the gradient colors that match the current [condition] and time.
List<Color> backgroundGradient(String condition, {bool isNight = false}) {
  if (isNight) {
    return const [Color(0xFF0D1B2A), Color(0xFF1B263B)];
  }
  switch (condition.toLowerCase()) {
    case 'clear':
      return const [Color(0xFF1E90FF), Color(0xFF87CEEB)];
    case 'clouds':
      return const [Color(0xFF546E7A), Color(0xFF90A4AE)];
    case 'rain':
    case 'drizzle':
      return const [Color(0xFF37474F), Color(0xFF607D8B)];
    case 'thunderstorm':
      return const [Color(0xFF212121), Color(0xFF424242)];
    case 'snow':
      return const [Color(0xFFB0BEC5), Color(0xFFECEFF1)];
    case 'mist':
    case 'fog':
    case 'haze':
      return const [Color(0xFF78909C), Color(0xFFB0BEC5)];
    default:
      return const [Color(0xFF1E90FF), Color(0xFF87CEEB)];
  }
}

/// Returns the primary text color that has good contrast against the
/// gradient returned by [backgroundGradient].
Color textColor(String condition, {bool isNight = false}) {
  if (isNight) return Colors.white;
  switch (condition.toLowerCase()) {
    case 'snow':
      return const Color(0xFF37474F);
    default:
      return Colors.white;
  }
}

/// Converts a wind-degree value to a compass direction string.
String windDirection(int degree) {
  const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
  return directions[((degree + 22) / 45).floor() % 8];
}

/// Returns true when [time] falls in the night-time window (20:00–05:59).
bool isNightTime(DateTime time) => time.hour < 6 || time.hour >= 20;
