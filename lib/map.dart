import 'package:flutter/material.dart';
import 'package:lanka_go/Sri_lanaka_map.dart';
import 'package:lanka_go/widgets/custom_appbar.dart';
import 'home.dart';
import 'footer.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    Color yellowColor = const Color(0xFFFFC107);

    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: CustomAppBar(title: 'Map'),

      //  Body
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/map.jpg', fit: BoxFit.cover),
          ),

          Container(color: Colors.black.withOpacity(0.3)),

          // center button
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      //go to map page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SriLankaMapPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.map, color: Colors.white, size: 28),
                    label: const Text(
                      'Open in Google Maps',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 39, 119, 5),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // 🟡 Footer navigation
      bottomNavigationBar: const Footer(selectedIndex: 1),
    );
  }
}

// 🧭 Fake “loading page” placeholder for when map button is clicked
class MapLoadingPage extends StatelessWidget {
  const MapLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        title: const Text('Opening Google Maps...'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.brown),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Colors.brown),
            const SizedBox(height: 20),
            const Text(
              'Connecting to Google Maps...',
              style: TextStyle(
                color: Colors.brown,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Back',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
