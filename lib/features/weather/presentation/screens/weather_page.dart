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
    print('🚀 WeatherPage initState');
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    print('🔄 ===== LOADING WEATHER =====');
    
    try {
      setState(() {
        loading = true;
        errorMessage = null;
      });

      // Location permission
      print('📍 Checking location permission...');
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location xizmati o\'chirilgan');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location ruxsat berilmadi');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location ruxsat butunlay rad qilingan');
      }

      print('✅ Location permission granted');

      // Get position
      print('📍 Getting current position...');
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print('✅ Position: ${position.latitude}, ${position.longitude}');

      // Fetch weather
      print('🌤️  Fetching weather data...');
      final repo = WeatherRepositoryImpl(WeatherRemoteDatasource());

      print('🌤️  Getting current weather...');
      final today = await repo.getCurrentWeather(
        position.latitude,
        position.longitude,
      );
      print('✅ Current weather loaded: ${today.cityName} ${today.temperature}°C');

      print('📅 Getting 7-day forecast...');
      final weekly = await repo.get7DayForecast(
        position.latitude,
        position.longitude,
      );
      print('✅ Forecast loaded: ${weekly.length} days');

      setState(() {
        current = today;
        forecast = weekly;
        loading = false;
      });

      print('✅ ===== WEATHER LOADED SUCCESSFULLY =====');
    } catch (e, stackTrace) {
      print('❌ ===== ERROR IN _loadWeather =====');
      print('Error: $e');
      print('StackTrace: $stackTrace');

      setState(() {
        loading = false;
        errorMessage = e.toString();
      });
    }
  }

  // weather_page.dart ichida

IconData _getIcon(String main) {
  final lowerMain = main.toLowerCase();

  if (lowerMain.contains('clear') || lowerMain.contains('ochiq')) {
    return Icons.wb_sunny;
  } else if (lowerMain.contains('cloud') || lowerMain.contains('bulut')) {
    return Icons.cloud;
  } else if (lowerMain.contains('rain') || lowerMain.contains('yomg\'ir') || lowerMain.contains('jala')) {
    return Icons.water_drop;
  } else if (lowerMain.contains('snow') || lowerMain.contains('qor')) {
    return Icons.ac_unit;
  } else if (lowerMain.contains('thunder') || lowerMain.contains('momaqaldiroq') || lowerMain.contains('do\'l')) {
    return Icons.flash_on;
  } else if (lowerMain.contains('mist') || lowerMain.contains('fog') || lowerMain.contains('tuman')) {
    return Icons.cloud_queue;
  } else if (lowerMain.contains('drizzle') || lowerMain.contains('mayda')) {
    return Icons.grain;
  } else {
    return Icons.wb_cloudy;
  }
}
  // ✅ Safe date formatting
  String _formatDate(String dateStr) {
    try {
      // WeatherAPI.com format: "2025-01-27" yoki "2025-01-27 12:00"
      DateTime date;
      
      if (dateStr.contains(' ')) {
        // Full datetime
        date = DateTime.parse(dateStr);
      } else {
        // Date only
        date = DateTime.parse(dateStr);
      }
      
      // Format: "Dushanba, 27-yan"
      return DateFormat('EEEE, d MMM', 'uz_UZ').format(date);
    } catch (e) {
      print('⚠️  Date parsing error: $e');
      return dateStr; // Fallback: original string
    }
  }

  @override
  Widget build(BuildContext context) {
    print('🎨 Building WeatherPage - loading: $loading, error: $errorMessage');

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("7 Kunlik Ob-havo"),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadWeather,
            tooltip: 'Yangilash',
          ),
        ],
      ),
      body: loading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    "Ob-havo yuklanmoqda...",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red.shade400,
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
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            errorMessage!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _loadWeather,
                          icon: const Icon(Icons.refresh),
                          label: const Text("Qayta urinish"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
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
                            colors: [
                              Colors.blue.shade600,
                              Colors.blue.shade400,
                            ],
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
                              "${current!.temperature.toStringAsFixed(1)}°C",
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
                                  "${current!.windspeed.toStringAsFixed(1)} km/h",
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
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      if (forecast.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text("Prognoz ma'lumoti yo'q"),
                          ),
                        )
                      else
                        ...forecast.map((item) {
                          // ✅ Safe date formatting
                          final day = _formatDate(item.date);

                          return ForecastCard(
                            day: day,
                            temp: item.temperature.toStringAsFixed(0),
                            desc: item.description,
                            icon: _getIcon(item.main),
                            minTemp: item.minTemp.toStringAsFixed(0),
                            maxTemp: item.maxTemp.toStringAsFixed(0),
                          );
                        }).toList(),
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
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}