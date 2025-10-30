import 'package:flutter/material.dart';

class ForecastCard extends StatelessWidget {
  final String day;
  final String temp;
  final String desc;
  final IconData icon;
  final String? minTemp; // ✅ Min temp qo'shildi
  final String? maxTemp; // ✅ Max temp qo'shildi

  const ForecastCard({
    super.key,
    required this.day,
    required this.temp,
    required this.desc,
    required this.icon,
    this.minTemp,
    this.maxTemp,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: _getIconColor(icon),
                size: 32,
              ),
            ),

            const SizedBox(width: 16),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    day,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  if (minTemp != null && maxTemp != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Min: $minTemp° / Max: $maxTemp°',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Temperature
            Text(
              '$temp°',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getIconColor(IconData icon) {
    if (icon == Icons.wb_sunny) return Colors.amber;
    if (icon == Icons.cloud) return Colors.grey;
    if (icon == Icons.water_drop) return Colors.blue;
    if (icon == Icons.ac_unit) return Colors.lightBlue;
    return Colors.grey;
  }
}