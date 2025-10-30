import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_home1/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:smart_home1/features/auth/presentation/bloc/auth_event.dart';
import 'package:smart_home1/features/auth/presentation/bloc/auth_state.dart';
import 'package:smart_home1/features/auth/presentation/screens/signin_page.dart';
import 'package:smart_home1/features/home/presentation/widgets.dart';
import 'package:smart_home1/features/weather/presentation/screens/weather_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smart_home1/features/weather/data/weather_repository/weather_repository_impl.dart';
import 'package:smart_home1/features/weather/data/weather_remote_datasource/weather_remote_datasource.dart';
import 'package:smart_home1/features/weather/domain/weather_entities/weather_entity.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  WeatherEntity? currentWeather;
  bool isWeatherLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition();
    final repo = WeatherRepositoryImpl(WeatherRemoteDatasource());
    final weather = await repo.getCurrentWeather(
      position.latitude,
      position.longitude,
    );

    print('🌍 [Home] Weather fetched successfully');
    print('🌡️ Temperature: ${weather.temperature}');
    print('🌤️ Description: ${weather.description}');

    setState(() {
      print("Latitude: ${position.latitude}, Longitude: ${position.longitude}");
      currentWeather = weather;
      isWeatherLoading = false;

      print('🎯 [UI] Weather updated on screen');
    });
  }

  // home_screen.dart ichida

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
  } else if (lowerMain.contains('mist') || lowerMain.contains('tuman') || lowerMain.contains('tuman')) {
    return Icons.cloud_queue;
  } else if (lowerMain.contains('drizzle') || lowerMain.contains('mayda')) {
    return Icons.grain;
  } else {
    return Icons.wb_cloudy;
  }
}
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const SignInPage()),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade600, Colors.blue.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // HEADER TITLE + PROFILE
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              String userName = "Foydalanuvchi";
                              if (state is AuthAuthenticated) {
                                userName = state.user.name.isNotEmpty
                                    ? state.user.name
                                    : "Foydalanuvchi";
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "My Home",
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Xush kelibsiz, $userName 👋",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Profil"),
                                  content: const Text("Chiqishni xohlaysizmi?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Yo'q"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        context.read<AuthBloc>().add(
                                          const SignOutEvent(),
                                        );
                                      },
                                      child: const Text("Ha"),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.person_outline,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // WEATHER CARD (HomeScreen ichida)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const WeatherPage(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: isWeatherLoading
                              ? const Center(
                                  child: SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                              : currentWeather == null
                              ? const Center(
                                  child: Text(
                                    "Ob-havo ma'lumoti yo'q",
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                )
                              : Row(
                                  children: [
                                    // Icon
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        _getIcon(currentWeather!.main),
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                    ),

                                    const SizedBox(width: 16),

                                    // Info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${currentWeather!.temperature.toStringAsFixed(0)}°C",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            currentWeather!.description,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            currentWeather!.cityName,
                                            style: const TextStyle(
                                              color: Colors.white60,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Arrow icon
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white70,
                                      size: 16,
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ROOMS SECTION
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Rooms",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text("Add Room"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      RoomCard(
                        icon: Icons.chair_outlined,
                        iconColor: Colors.blue.shade600,
                        roomName: "Living Room",
                        temperature: 22,
                        activeDevices: 3,
                      ),
                      const SizedBox(height: 12),
                      RoomCard(
                        icon: Icons.countertops_outlined,
                        iconColor: Colors.orange.shade600,
                        roomName: "Kitchen",
                        temperature: 21,
                        activeDevices: 0,
                      ),
                      const SizedBox(height: 12),
                      RoomCard(
                        icon: Icons.bed_outlined,
                        iconColor: Colors.purple.shade600,
                        roomName: "Bedroom",
                        temperature: 20,
                        activeDevices: 1,
                      ),
                      const SizedBox(height: 24),

                      const Text(
                        "Active Devices",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),

                      RoomCard(
                        icon: Icons.lightbulb_outline,
                        iconColor: Colors.amber.shade600,
                        roomName: "Main Light",
                        subtitle: "Living Room",
                        hasSwitch: true,
                        switchValue: true,
                        onSwitchChanged: (value) {},
                      ),
                      const SizedBox(height: 12),
                      RoomCard(
                        icon: Icons.tv_outlined,
                        iconColor: Colors.blue.shade600,
                        roomName: "Smart TV",
                        subtitle: "Living Room",
                        hasSwitch: true,
                        switchValue: true,
                        onSwitchChanged: (value) {},
                      ),
                      const SizedBox(height: 12),
                      RoomCard(
                        icon: Icons.thermostat_outlined,
                        iconColor: Colors.red.shade600,
                        roomName: "Thermostat",
                        subtitle: "Living Room",
                        hasSwitch: true,
                        switchValue: false,
                        onSwitchChanged: (value) {},
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
