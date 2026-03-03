import 'package:flutter/material.dart';
import 'package:lanka_go/constance/colors.dart';
import 'package:lanka_go/trips_page.dart';

class GenerateItineraryPage extends StatelessWidget {
  final int days;
  final String budget;
  final List<String> interests;
  final String district;
  final String foodType;
  final String stayType;

  const GenerateItineraryPage({
    super.key,
    required this.days,
    required this.budget,
    required this.interests,
    required this.district,
    required this.foodType,
    required this.stayType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Itinerary"),
        backgroundColor: kOrangePrimary,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kMainWhite, kPrimaryYellowLight],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Here is your generated itinerary",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[800],
                  ),
                ),
                const SizedBox(height: 20),

                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      "assets/itinerary.jpg",
                      height: 270,
                      width: 220,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Detail cards
                _buildDetailCard("Area / District", district),
                _buildDetailCard("Number of Days", days.toString()),
                _buildDetailCard("Budget", budget),
                _buildDetailCard("Interests", interests.join(", ")),
                _buildDetailCard("Preferred Food", foodType),
                _buildDetailCard("Stay Type", stayType),

                const SizedBox(height: 30),

                // Button to navigate to TripsPage
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kBtnPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RecommendedTripPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Go to Trip Page",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(String title, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
