import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/weather.dart';
import '../services/weather_service.dart';
import '../theme/weather_theme.dart';
import '../widgets/weather_widgets.dart';

/// The main home screen that displays weather information for a selected city.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final WeatherService _weatherService = WeatherService();

  late WeatherData _weatherData;
  String _selectedCity = 'New York';

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _loadWeather(_selectedCity);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _loadWeather(String city) {
    setState(() {
      _selectedCity = city;
      _weatherData = _weatherService.getMockWeatherData(city);
    });
    _fadeController
      ..reset()
      ..forward();
  }

  bool get _isNight => isNightTime(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final current = _weatherData.current;
    final textCol = textColor(current.condition, isNight: _isNight);
    final gradients = backgroundGradient(current.condition, isNight: _isNight);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradients,
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHeader(current, textCol)),
                SliverToBoxAdapter(child: _buildCurrentWeather(current, textCol)),
                SliverToBoxAdapter(child: _buildHourlyForecast(textCol)),
                SliverToBoxAdapter(
                  child: _buildDetailGrid(current, textCol),
                ),
                SliverToBoxAdapter(child: _buildDailyForecast(textCol)),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(CurrentWeather current, Color textCol) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 0),
      child: Row(
        children: [
          Icon(Icons.location_on, color: textCol, size: 20),
          const SizedBox(width: 4),
          Text(
            '${current.cityName}, ${current.country}',
            style: TextStyle(
              color: textCol,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.search, color: textCol),
            onPressed: () => _showCitySearch(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentWeather(CurrentWeather current, Color textCol) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        children: [
          Icon(
            weatherIcon(current.condition, isNight: _isNight),
            color: textCol,
            size: 96,
          ),
          const SizedBox(height: 8),
          Text(
            '${current.temperature.round()}°C',
            style: TextStyle(
              color: textCol,
              fontSize: 72,
              fontWeight: FontWeight.w200,
              letterSpacing: -2,
            ),
          ),
          Text(
            current.description.toUpperCase(),
            style: TextStyle(
              color: textCol.withOpacity(0.85),
              fontSize: 16,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'H:${current.tempMax.round()}°  L:${current.tempMin.round()}°',
            style: TextStyle(
              color: textCol.withOpacity(0.75),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Updated ${DateFormat('h:mm a').format(current.lastUpdated)}',
            style: TextStyle(
              color: textCol.withOpacity(0.55),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyForecast(Color textCol) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Hourly Forecast', textCol),
        SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _weatherData.hourly.length,
            itemBuilder: (context, index) => HourlyWeatherCard(
              hourly: _weatherData.hourly[index],
              textCol: textCol,
              isNow: index == 0,
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildDetailGrid(CurrentWeather current, Color textCol) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Details', textCol),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.1,
            children: [
              WeatherDetailChip(
                icon: Icons.water_drop,
                label: 'Humidity',
                value: '${current.humidity}%',
                textCol: textCol,
              ),
              WeatherDetailChip(
                icon: Icons.air,
                label: 'Wind',
                value:
                    '${current.windSpeed.round()} km/h\n${windDirection(current.windDegree)}',
                textCol: textCol,
              ),
              WeatherDetailChip(
                icon: Icons.thermostat,
                label: 'Feels Like',
                value: '${current.feelsLike.round()}°C',
                textCol: textCol,
              ),
              WeatherDetailChip(
                icon: Icons.visibility,
                label: 'Visibility',
                value: '${(current.visibility / 1000).toStringAsFixed(1)} km',
                textCol: textCol,
              ),
              WeatherDetailChip(
                icon: Icons.wb_twilight,
                label: 'Sunrise',
                value: DateFormat('h:mm a').format(current.sunrise),
                textCol: textCol,
              ),
              WeatherDetailChip(
                icon: Icons.nights_stay,
                label: 'Sunset',
                value: DateFormat('h:mm a').format(current.sunset),
                textCol: textCol,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDailyForecast(Color textCol) {
    // Compute temperature range across all days for consistent bar scaling.
    final overallMin = _weatherData.daily
        .map((d) => d.tempMin)
        .reduce((a, b) => a < b ? a : b);
    final overallMax = _weatherData.daily
        .map((d) => d.tempMax)
        .reduce((a, b) => a > b ? a : b);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('7-Day Forecast', textCol),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: _weatherData.daily
                  .asMap()
                  .entries
                  .map(
                    (e) => Column(
                      children: [
                        DailyForecastRow(
                          daily: e.value,
                          textCol: textCol,
                          isToday: e.key == 0,
                          overallMin: overallMin,
                          overallMax: overallMax,
                        ),
                        if (e.key < _weatherData.daily.length - 1)
                          Divider(
                            color: Colors.white.withOpacity(0.15),
                            height: 1,
                          ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, Color textCol) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: textCol.withOpacity(0.85),
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  void _showCitySearch(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _CitySearchSheet(
        cities: _weatherService.popularCities,
        currentCity: _selectedCity,
        onCitySelected: (city) {
          Navigator.pop(ctx);
          _loadWeather(city);
        },
      ),
    );
  }
}

/// A bottom sheet that allows the user to pick a city.
class _CitySearchSheet extends StatefulWidget {
  final List<String> cities;
  final String currentCity;
  final ValueChanged<String> onCitySelected;

  const _CitySearchSheet({
    required this.cities,
    required this.currentCity,
    required this.onCitySelected,
  });

  @override
  State<_CitySearchSheet> createState() => _CitySearchSheetState();
}

class _CitySearchSheetState extends State<_CitySearchSheet> {
  String _query = '';
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<String> get _filtered => widget.cities
      .where((c) => c.toLowerCase().contains(_query.toLowerCase()))
      .toList();

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: EdgeInsets.fromLTRB(16, 20, 16, 16 + bottomInset),
      decoration: const BoxDecoration(
        color: Color(0xFF1B263B),
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select City',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search city…',
              hintStyle: TextStyle(color: Colors.white54),
              prefixIcon: const Icon(Icons.search, color: Colors.white54),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 260),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _filtered.length,
              separatorBuilder: (_, __) =>
                  Divider(color: Colors.white.withOpacity(0.1), height: 1),
              itemBuilder: (_, i) {
                final city = _filtered[i];
                return ListTile(
                  title: Text(
                    city,
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: city == widget.currentCity
                      ? const Icon(Icons.check, color: Colors.lightBlueAccent)
                      : null,
                  onTap: () => widget.onCitySelected(city),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
