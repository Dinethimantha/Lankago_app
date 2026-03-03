import 'package:flutter/material.dart';
import 'package:lanka_go/Sri_lanaka_map.dart';
import 'package:lanka_go/booking_history.dart';
import 'package:lanka_go/constance/colors.dart';
import 'package:lanka_go/setting.dart';
import 'package:lanka_go/weather.dart';
import 'package:lanka_go/widgets/custom_appbar.dart';
import 'footer.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Explore Page'),

      // Footer
      bottomNavigationBar: const Footer(selectedIndex: 1),

      // Gradient background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF3E0), Color(0xFFFFCC80)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildCard(
                context,
                title: "Sri Lanka Map",
                icon: Icons.map,
                page: const SriLankaMapPage(),
              ),

              const SizedBox(height: 16),

              _buildCard(
                context,
                title: "Weather",
                icon: Icons.cloud,
                page: const WeatherPage(),
              ),

              const SizedBox(height: 16),

              _buildCard(
                context,
                title: "Settings",
                icon: Icons.settings,
                page: const SettingsPage(),
              ),

              const SizedBox(height: 16),

              _buildCard(
                context,
                title: "Booking History",
                icon: Icons.history,
                page: const BookingHistoryPage(),
              ),

              const SizedBox(height: 16),

              _buildCard(
                context,
                title: "About Us",
                icon: Icons.info,
                page: const SriLankaMapPage(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget page,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kPrimaryYellowDark, width: 3),
            gradient: const LinearGradient(
              colors: [kMainWhite,kPrimaryYellowLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: kPrimaryYellowDark),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: kBrownDark,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
