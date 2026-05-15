import 'package:flutter/material.dart';
import 'package:lanka_go/Sri_lanaka_map.dart';
import 'package:lanka_go/about_us.dart';
import 'package:lanka_go/constance/colors.dart';
import 'package:lanka_go/trips_history.dart';
import 'package:lanka_go/weather.dart';
import 'package:lanka_go/widgets/appbar_without_arrow.dart';
import 'package:lanka_go/widgets/custom_appbar.dart';
import 'footer.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithoutArrow(title: 'Explore Page'),

      // Footer
      bottomNavigationBar: const Footer(selectedIndex: 1),

      // Gradient background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF3E0), Color.fromARGB(161, 255, 204, 128),Color(0xFFFFF3E0),],
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
                imagePath: "assets/Srilanka_map.jpg",
                page: const SriLankaMapPage(),
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(173, 104, 139, 174),
                    Color.fromARGB(255, 1, 1, 54),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),

              const SizedBox(height: 16),

              _buildCard(
                context,
                title: "Weather",
                imagePath: "assets/weather.jpg",
                page: const WeatherPage(),
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(171, 223, 189, 103),
                    Color.fromARGB(255, 198, 139, 0),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),

              const SizedBox(height: 16),

              _buildCard(
                context,
                title: "Trip History",
                imagePath: "assets/history.jpg",
                page: const TripHistoryPage(),
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(174, 136, 230, 144),
                    Color.fromARGB(255, 1, 115, 5),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),

              const SizedBox(height: 16),

              _buildCard(
                context,
                title: "About Us",
                imagePath: "assets/Aboutus.jpg",
                page: const AboutUsPage(),
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(188, 131, 247, 233),
                    Color.fromARGB(255, 5, 130, 120),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
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
    required String imagePath,
    required Widget page,
    required LinearGradient gradient,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          height: 230,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),

            gradient: gradient,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  imagePath,
                  height: 140,
                  width: 300,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: kMainWhite,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(1.5, 1.5),
                      blurRadius: 4,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
