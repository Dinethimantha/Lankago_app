import 'package:flutter/material.dart';
import 'package:lanka_go/app_bar.dart';
import 'package:lanka_go/constance/colors.dart';
import 'package:lanka_go/recommendation_form.dart';
import 'package:lanka_go/stays_food_places_page.dart';

import 'footer.dart';
import 'tuk_service_page.dart';
import 'itinerary_page.dart';
import 'offline_mode_page.dart';
import 'eco_score_page.dart';
import 'suggestions_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 245, 240, 220),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: Appbar(),
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kMainWhite, kPrimaryYellowLight],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGreeting(),
                const SizedBox(height: 20),
                _buildRecommendationFormCard(),
                const SizedBox(height: 25),
                _buildQuickAccess(),
                const SizedBox(height: 25),
                _buildEcoScoreCard(),
                const SizedBox(height: 25),
                _buildRecommendedSection(),
                const SizedBox(height: 25),
                _buildAIAssistantCard(),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: const Footer(selectedIndex: 0),
    );
  }

  //  GREETING

  Widget _buildGreeting() {
    return const Text(
      "Welcome! , Dineth 👋",
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: kOrangePrimary,
        height: 1.3,
        letterSpacing: 0.5,
      ),
    );
  }

  // RECOMMENDATION FORM CARD
  Widget _buildRecommendationFormCard() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RecommendationForm()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: kPrimaryYellowLight, width: 1.5),
          gradient: const LinearGradient(
            colors: [kPrimaryYellowLight, kBrownLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: kPrimaryYellowLight.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              "Plan Your Trip 🧳",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 8),

            // Subtitle
            const Text(
              "Get personalized recommendations based on your preferences.",
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),

            // Instruction 
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: kBtnBlue.withOpacity(0.5),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Text(
                "Please fill this form first!",
                style: TextStyle(
                  color: kMainWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Call to action
            Row(
              children: const [
                Text(
                  "Tap to start planning",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: kBtnGreen,
                  ),
                ),
                SizedBox(width: 5),
                Icon(Icons.arrow_forward, color: kBtnGreen, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //  QUICK ACCESS CARDS

  Widget _buildQuickAccess() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Quick Access",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: kappbaryellow,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            // Tuk Service Button
            _quickAccessButton('assets/tuk_service.jpg', "Tuk Service", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TukServicePage()),
              );
            }),
            _quickAccessButton(
              'assets/stays_food_places.jpg',
              " Stays |Food | places",
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => StaysFoodPlacesPage()),
                );
              },
            ),
            _quickAccessButton('assets/my_itinerary.jpg', "My Itinerary", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ItineraryPage()),
              );
            }),
            _quickAccessButton('assets/offline_mode.jpg', "Offline Mode", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => OfflineModePage()),
              );
            }),
          ],
        ),
      ],
    );
  }

  // QUICK ACCESS BUTTON (Image Version)
  Widget _quickAccessButton(
    String imagePath,
    String label,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: Colors.black.withOpacity(
              0.25,
            ), // slight dark overlay for readability
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 90),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ECO SCORE
  Widget _buildEcoScoreCard() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => EcoScorePage()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFF176), Color(0xFFFFD54F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Eco Score 🌿",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.brown,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "85",
              style: TextStyle(
                fontSize: 42,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Track sustainability | Green Level",
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  // RECOMMENDED
  Widget _buildRecommendedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recommended for You",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.brown,
          ),
        ),
        const SizedBox(height: 12),
        _recommendCard(
          "Temple of Tooth",
          "Sacred Buddhist temple in Kandy",
          "Free Entry",
          "4.8",
          Colors.orangeAccent,
        ),
        _recommendCard(
          "Mirissa Beach",
          "Perfect for whale watching",
          "\$25/day",
          "4.9",
          Colors.blueAccent,
        ),
        _recommendCard(
          "Pettah Market",
          "Bustling local market experience",
          "Free Visit",
          "4.6",
          Colors.greenAccent,
        ),
      ],
    );
  }

  Widget _recommendCard(
    String title,
    String desc,
    String price,
    String rating,
    Color color,
  ) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.only(bottom: 14),
      shadowColor: color.withOpacity(0.3),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: CircleAvatar(
          backgroundColor: color,
          radius: 26,
          child: const Icon(Icons.location_on, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.brown,
          ),
        ),
        subtitle: Text(desc, style: const TextStyle(color: Colors.black87)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              price,
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                Text(rating),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIAssistantCard() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SuggestionsPage()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFE0B2), Color(0xFFFFCC80)],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "LAK BOT ASSISTANT 🤖",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.brown,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Personalized suggestions based on your preferences for cultural sites and beaches.",
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
            SizedBox(height: 10),
            Text(
              "Tap to get suggestions →",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
