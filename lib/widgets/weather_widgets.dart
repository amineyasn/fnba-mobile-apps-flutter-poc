import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/weather.dart';
import '../theme/weather_theme.dart';

/// Displays weather information for a single hour in a compact card.
class HourlyWeatherCard extends StatelessWidget {
  final HourlyWeather hourly;
  final Color textCol;
  final bool isNow;

  const HourlyWeatherCard({
    super.key,
    required this.hourly,
    required this.textCol,
    this.isNow = false,
  });

  @override
  Widget build(BuildContext context) {
    final isNight = isNightTime(hourly.time);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 72,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: isNow
            ? Colors.white.withOpacity(0.35)
            : Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: isNow
            ? Border.all(color: Colors.white.withOpacity(0.6), width: 1.5)
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isNow ? 'Now' : DateFormat('h a').format(hourly.time),
            style: TextStyle(
              color: textCol,
              fontSize: 12,
              fontWeight: isNow ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 8),
          Icon(
            weatherIcon(hourly.condition, isNight: isNight),
            color: textCol,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            '${hourly.temperature.round()}°',
            style: TextStyle(
              color: textCol,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (hourly.chanceOfRain > 20) ...[
            const SizedBox(height: 4),
            Text(
              '${hourly.chanceOfRain}%',
              style: TextStyle(
                color: textCol.withOpacity(0.8),
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Displays a single row in the 7-day forecast list.
class DailyForecastRow extends StatelessWidget {
  final DailyWeather daily;
  final Color textCol;
  final bool isToday;
  /// The lowest temperature across the entire forecast period (for the bar scale).
  final double overallMin;
  /// The highest temperature across the entire forecast period (for the bar scale).
  final double overallMax;

  const DailyForecastRow({
    super.key,
    required this.daily,
    required this.textCol,
    required this.overallMin,
    required this.overallMax,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              isToday ? 'Today' : DateFormat('EEEE').format(daily.date),
              style: TextStyle(
                color: textCol,
                fontSize: 14,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Icon(weatherIcon(daily.condition), color: textCol, size: 20),
          const SizedBox(width: 8),
          if (daily.chanceOfRain > 20)
            Text(
              '${daily.chanceOfRain}%',
              style: TextStyle(
                color: Colors.lightBlueAccent,
                fontSize: 12,
              ),
            ),
          const Spacer(),
          Text(
            '${daily.tempMin.round()}°',
            style: TextStyle(
              color: textCol.withOpacity(0.65),
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 6),
          _TempBar(
            min: daily.tempMin,
            max: daily.tempMax,
            overallMin: overallMin,
            overallMax: overallMax,
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 36,
            child: Text(
              '${daily.tempMax.round()}°',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: textCol,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A small coloured bar that visualises a temperature range.
class _TempBar extends StatelessWidget {
  final double min;
  final double max;
  final double overallMin;
  final double overallMax;

  const _TempBar({
    required this.min,
    required this.max,
    required this.overallMin,
    required this.overallMax,
  });

  @override
  Widget build(BuildContext context) {
    final range = overallMax - overallMin;
    final startFrac = (min - overallMin) / range;
    final endFrac = (max - overallMin) / range;

    return SizedBox(
      width: 80,
      height: 6,
      child: CustomPaint(
        painter: _TempBarPainter(
          startFrac: startFrac.clamp(0.0, 1.0),
          endFrac: endFrac.clamp(0.0, 1.0),
        ),
      ),
    );
  }
}

class _TempBarPainter extends CustomPainter {
  final double startFrac;
  final double endFrac;

  _TempBarPainter({required this.startFrac, required this.endFrac});

  @override
  void paint(Canvas canvas, Size size) {
    // Background track
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(3),
      ),
      Paint()..color = Colors.white.withOpacity(0.2),
    );
    // Filled range
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          startFrac * size.width,
          0,
          (endFrac - startFrac) * size.width,
          size.height,
        ),
        const Radius.circular(3),
      ),
      Paint()
        ..shader = LinearGradient(
          colors: const [Color(0xFF64B5F6), Color(0xFFFFB74D)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );
  }

  @override
  bool shouldRepaint(_TempBarPainter old) =>
      old.startFrac != startFrac || old.endFrac != endFrac;
}

/// Displays a weather detail chip (e.g. Humidity 72%).
class WeatherDetailChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color textCol;

  const WeatherDetailChip({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.textCol,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textCol, size: 22),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: textCol,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: textCol.withOpacity(0.75),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
