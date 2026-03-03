import 'package:flutter/material.dart';
import 'package:lanka_go/constance/colors.dart';
import 'package:lanka_go/places_page.dart';
import 'package:lanka_go/widgets/custom_appbar.dart';
import 'footer.dart';
import 'Stays_page.dart';
import 'cafe.dart';

class StaysFoodPlacesPage extends StatelessWidget {
  const StaysFoodPlacesPage({super.key});

  @override
  Widget build(BuildContext context) {
    Color yellowColor = kappbaryellow;

    return Scaffold(
      appBar: CustomAppBar(
        title: "Explore Sri Lanka",
        ),
      

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //plases category card
            _buildCategoryCard(
              context,
              image: 'assets/places.jpg',
              title: 'Recommended Places',
              description:
                  'Explore the most popular tourist attractions and hidden gems across Sri Lanka.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PlacesPage()),
                );
              },
            ),
            const SizedBox(height: 20),

            // hotels category card
            _buildCategoryCard(
              context,
              image: 'assets/hotels.jpg',
              title: 'Recommended Stays',
              description:
                  'Find the best hotels to relax and enjoy your vacation with premium comfort.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StaysPage()),
                );
              },
            ),
            const SizedBox(height: 20),

            // cafes category card
            _buildCategoryCard(
              context,
              image: 'assets/cafe.jpg',
              title: 'Recommended Cafés',
              description:
                  'Discover cozy cafés and experience the best coffee spots nearby.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CafesPage()),
                );
              },
            ),
          ],
        ),
      ),

      // ✅ Footer at Bottom
      bottomNavigationBar: const Footer(selectedIndex: 0),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required String image,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.amberAccent.withOpacity(0.2),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.asset(
                image,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryYellowDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFC107),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      child: const Text(
                        "View Details",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
