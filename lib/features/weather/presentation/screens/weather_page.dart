import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:smart_home1/features/weather/data/weather_remote_datasource/weather_remote_datasource.dart';
import 'package:smart_home1/features/weather/data/weather_repository/weather_repository_impl.dart';
import 'package:smart_home1/features/weather/domain/weather_entities/weather_entity.dart';
import 'package:smart_home1/features/weather/presentation/weather_widget/weather_widget.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  WeatherEntity? current;
  List<WeatherEntity> forecast = [];
  bool loading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    try {
      setState(() {
        loading = true;
        errorMessage = null;
      });

      final position = await Geolocator.getCurrentPosition();
      final repo = WeatherRepositoryImpl(WeatherRemoteDatasource());

      final today = await repo.getCurrentWeather(
        position.latitude,
        position.longitude,
      );
      final weekly = await repo.get7DayForecast(
        position.latitude,
        position.longitude,
      );

      setState(() {
        current = today;
        forecast = weekly;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
        errorMessage = e.toString();
      });

      print('❌ WEATHER PAGE ERROR: $e'); // ✅ DEBUG
    }
  }

  IconData _getIcon(String main) {
    switch (main.toLowerCase()) {
      case 'rain':
        return Icons.water_drop;
      case 'clouds':
        return Icons.cloud;
      case 'snow':
        return Icons.ac_unit;
      case 'clear':
        return Icons.wb_sunny;
      default:
        return Icons.device_thermostat;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("7 Kunlik Ob-havo"),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Xatolik yuz berdi",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _loadWeather,
                      icon: const Icon(Icons.refresh),
                      label: const Text("Qayta urinish"),
                    ),
                  ],
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadWeather,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Current Weather Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade600, Colors.blue.shade400],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade200,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          current!.cityName,
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Icon(
                          _getIcon(current!.main),
                          size: 80,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "${current!.temperature.toStringAsFixed(0)}°C",
                          style: const TextStyle(
                            fontSize: 56,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          current!.description,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildWeatherDetail(
                              Icons.water_drop,
                              "${current!.humidity.toInt()}%",
                              "Namlik",
                            ),
                            _buildWeatherDetail(
                              Icons.air,
                              "${current!.windspeed.toInt()} km/h",
                              "Shamol",
                            ),
                            _buildWeatherDetail(
                              Icons.thermostat,
                              "${current!.minTemp.toInt()}° / ${current!.maxTemp.toInt()}°",
                              "Min / Max",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 7-Day Forecast
                  const Text(
                    "7 Kunlik Prognoz",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  ...forecast.map((item) {
                    final date = DateTime.parse(item.date);
                    final day = DateFormat('EEEE, MMM d').format(date);

                    return ForecastCard(
                      day: day,
                      temp: item.temperature.toStringAsFixed(0),
                      desc: item.description,
                      icon: _getIcon(item.main),
                      minTemp: item.minTemp.toStringAsFixed(0),
                      maxTemp: item.maxTemp.toStringAsFixed(0),
                    );
                  }),
                ],
              ),
            ),
    );
  }

  Widget _buildWeatherDetail(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white60, fontSize: 12),
        ),
      ],
    );
  }
}
