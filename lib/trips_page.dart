import 'package:flutter/material.dart';

class RecommendedTripPage extends StatelessWidget {
  const RecommendedTripPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Recommended Trip"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// HERO SECTION
            Container(
              height: 220,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/destination.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.bottomLeft,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: const Text(
                  "Your 3-Day Trip to Ella",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// USER SELECTION SUMMARY
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  Chip(label: Text("📍 Ella")),
                  Chip(label: Text("📅 3 Days")),
                  Chip(label: Text("💰 Medium Budget")),
                  Chip(label: Text("🏨 Hotel")),
                  Chip(label: Text("🍽 Local Food")),
                  Chip(label: Text("❤️ Nature & Hiking")),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// AI MESSAGE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "✨ Based on your interests and budget, we’ve created a relaxing and adventurous trip with scenic views, local food, and comfortable stays.",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// DAY BY DAY ITINERARY
            _sectionTitle("Day-wise Itinerary"),

            _dayCard(
              day: "Day 1",
              title: "Arrival & City Exploration",
              activities: [
                "Check-in to hotel",
                "Visit Nine Arch Bridge",
                "Sunset at Ella Rock",
              ],
            ),

            _dayCard(
              day: "Day 2",
              title: "Nature & Adventure",
              activities: [
                "Hike Little Adam’s Peak",
                "Local restaurant lunch",
                "Ravana Falls visit",
              ],
            ),

            _dayCard(
              day: "Day 3",
              title: "Leisure & Departure",
              activities: [
                "Breakfast with view",
                "Souvenir shopping",
                "Return journey",
              ],
            ),

            const SizedBox(height: 20),

            /// STAY SECTION
            _sectionTitle("Recommended Stay"),

            _infoCard(
              icon: Icons.hotel,
              title: "Mountain View Hotel",
              description:
                  "Comfortable hotel close to attractions, suitable for medium budget travelers.",
            ),

            /// FOOD SECTION
            _sectionTitle("Food Experience"),

            _infoCard(
              icon: Icons.restaurant,
              title: "Local Cuisine Highlights",
              description:
                  "Traditional Sri Lankan rice & curry, street food, and cozy cafés.",
            ),

            /// BUDGET SECTION
            _sectionTitle("Estimated Budget"),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: const [
                  _budgetRow("Stay", "40%"),
                  _budgetRow("Food", "25%"),
                  _budgetRow("Transport", "20%"),
                  _budgetRow("Activities", "15%"),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// ACTION BUTTONS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    onPressed: () {},
                    child: const Text("Save Trip"),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    onPressed: () {},
                    child: const Text("Modify Preferences"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// SECTION TITLE
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// DAY CARD
  static Widget _dayCard({
    required String day,
    required String title,
    required List<String> activities,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$day – $title",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...activities.map(
                (a) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.circle, size: 6),
                      const SizedBox(width: 8),
                      Expanded(child: Text(a)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// INFO CARD
  static Widget _infoCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
          subtitle: Text(description),
        ),
      ),
    );
  }
}

/// BUDGET ROW
class _budgetRow extends StatelessWidget {
  final String title;
  final String value;

  const _budgetRow(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
