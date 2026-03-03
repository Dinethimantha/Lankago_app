import 'package:flutter/material.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        iconTheme: const IconThemeData(color: Colors.brown),
        title: const Text(
          'Sri Lanka Weather 🌤️',
          style: TextStyle(
            color: Colors.brown,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
        centerTitle: true,
        elevation: 6,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),
            _weatherCard(
              city: 'Colombo',
              temperature: '30°C',
              condition: 'Sunny',
              icon: Icons.wb_sunny_rounded,
            ),
            _weatherCard(
              city: 'Kandy',
              temperature: '25°C',
              condition: 'Cloudy',
              icon: Icons.cloud_rounded,
            ),
            _weatherCard(
              city: 'Galle',
              temperature: '29°C',
              condition: 'Partly Cloudy',
              icon: Icons.wb_cloudy_rounded,
            ),
            _weatherCard(
              city: 'Nuwara Eliya',
              temperature: '18°C',
              condition: 'Rainy',
              icon: Icons.grain_rounded,
            ),
            _weatherCard(
              city: 'Jaffna',
              temperature: '32°C',
              condition: 'Sunny',
              icon: Icons.wb_sunny_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _weatherCard({
    required String city,
    required String temperature,
    required String condition,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.yellow[600]!, Colors.orange[400]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 36),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  city,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  condition,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          Text(
            temperature,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
