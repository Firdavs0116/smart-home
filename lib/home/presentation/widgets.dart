import 'package:flutter/material.dart';

class RoomCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String roomName;
  final String? subtitle;
  final int? temperature;
  final int? activeDevices;
  final bool hasSwitch;
  final bool switchValue;
  final Function(bool)? onSwitchChanged;

  const RoomCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.roomName,
    this.subtitle,
    this.temperature,
    this.activeDevices,
    this.hasSwitch = false,
    this.switchValue = false,
    this.onSwitchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Container
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),

          // Room Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  roomName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                if (temperature != null || activeDevices != null)
                  Row(
                    children: [
                      if (temperature != null) ...[
                        Icon(
                          Icons.thermostat_outlined,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "$temperature°C",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                      if (temperature != null && activeDevices != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Container(
                            height: 4,
                            width: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      if (activeDevices != null) ...[
                        Icon(
                          Icons.power_outlined,
                          size: 14,
                          color: activeDevices! > 0
                              ? Colors.green.shade600
                              : Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "$activeDevices active",
                          style: TextStyle(
                            fontSize: 13,
                            color: activeDevices! > 0
                                ? Colors.green.shade600
                                : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ],
                  ),
              ],
            ),
          ),

          // Switch or Arrow
          if (hasSwitch)
            Switch(
              value: switchValue,
              onChanged: onSwitchChanged,
              activeThumbColor: Colors.blue.shade600,
            )
          else
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey.shade400,
              size: 28,
            ),
        ],
      ),
    );
  }
}