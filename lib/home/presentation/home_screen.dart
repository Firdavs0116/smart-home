import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_home1/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:smart_home1/features/auth/presentation/bloc/auth_event.dart';
import 'package:smart_home1/features/auth/presentation/bloc/auth_state.dart';
import 'package:smart_home1/features/auth/presentation/screens/signin_page.dart';
import 'package:smart_home1/home/presentation/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                // Header Container
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
                      // Top Row (Title + Profile)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              String userName = "Foydalanuvchi";
                              if (state is AuthAuthenticated) {
                                userName = state.user.name;
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
                                    "Xush kelibsiz, $userName",
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
                              // Profile page
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
                                        context.read<AuthBloc>().add(const SignOutEvent());
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

                      // Weather Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.wb_sunny_outlined,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "22°C",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Tashkent",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Rooms Section
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
                            onPressed: () {
                              // Add room logic
                            },
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

                      // Room Cards
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

                      // Active Devices Section
                      const Text(
                        "Active Devices",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Device Cards
                      RoomCard(
                        icon: Icons.lightbulb_outline,
                        iconColor: Colors.amber.shade600,
                        roomName: "Main Light",
                        subtitle: "Living Room",
                        hasSwitch: true,
                        switchValue: true,
                        onSwitchChanged: (value) {
                          // Toggle light
                        },
                      ),
                      const SizedBox(height: 12),
                      RoomCard(
                        icon: Icons.tv_outlined,
                        iconColor: Colors.blue.shade600,
                        roomName: "Smart TV",
                        subtitle: "Living Room",
                        hasSwitch: true,
                        switchValue: true,
                        onSwitchChanged: (value) {
                          // Toggle TV
                        },
                      ),
                      const SizedBox(height: 12),
                      RoomCard(
                        icon: Icons.thermostat_outlined,
                        iconColor: Colors.red.shade600,
                        roomName: "Thermostat",
                        subtitle: "Living Room",
                        hasSwitch: true,
                        switchValue: false,
                        onSwitchChanged: (value) {
                          // Toggle thermostat
                        },
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