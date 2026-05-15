import 'package:flutter/material.dart';
import 'package:lanka_go/widgets/app_bar.dart';
import 'package:lanka_go/constance/colors.dart';
import 'package:lanka_go/recommendation_form.dart';
import 'package:lanka_go/stays_food_places_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'footer.dart';
import 'tuk_service_page.dart';
import 'itinerary_page.dart';
import 'offline_mode_page.dart';
import 'eco_score_page.dart';
import 'Lak_bot_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double ecoScore = 0;

  @override
  void initState() {
    super.initState();
    loadEcoScore();
  }

  Future<void> loadEcoScore() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      ecoScore = prefs.getDouble("eco_score") ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: Appbar(),
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              kMainWhite,
              Color.fromARGB(255, 236, 232, 205),
              Color.fromARGB(255, 236, 232, 205),
              kMainWhite,
            ],
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
                const SizedBox(height: 5),
                _buildGreeting(),
                const SizedBox(height: 15),
                _buildRecommendationFormCard(),
                const SizedBox(height: 15),
                Divider(color: Colors.brown.withOpacity(0.5), thickness: 1.5),
                const SizedBox(height: 10),
                _buildQuickAccess(),
                const SizedBox(height: 25),
                Divider(color: Colors.brown.withOpacity(0.5), thickness: 1.5),
                const SizedBox(height: 10),
                _buildEcoScoreCard(),
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
    final hour = DateTime.now().hour;

    String greeting;
    IconData icon;

    if (hour < 12) {
      greeting = "Good Morning ";
      icon = Icons.wb_sunny; 
    } else if (hour < 17) {
      greeting = "Good Afternoon";
      icon = Icons.wb_twighlight; 
    } else {
      greeting = "Good Evening";
      icon = Icons.nightlight_round; 
    }

    return Row(
      children: [
        Text(
          "$greeting!",
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: kOrangePrimary,
            height: 1.3,
            letterSpacing: 0.5,
            shadows: [
              BoxShadow(
                offset: const Offset(1, 2),
                blurRadius: 4,
                color: Colors.black26,
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        Icon(
          icon,
          color: kOrangePrimary,
          size: 28,
          shadows: [
            BoxShadow(
              offset: const Offset(1, 2),
              blurRadius: 4,
              color: Colors.black26,
            ),
          ],
        ),
      ],
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
          gradient: const LinearGradient(
            colors: [
              kOrangePrimary,
              Color.fromARGB(255, 246, 227, 101),
              Color.fromARGB(255, 224, 207, 99),
              kBrownLight,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: kTextDarkGray.withOpacity(0.4),
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
                MaterialPageRoute(
                  builder: (_) =>
                      ItineraryPage(places: [], stays: [], cafes: []),
                ),
              );
            }),
            _quickAccessButton('assets/offline_mode.jpg', "Offline Mode", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => OfflinePage()),
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

  // ECO SCORE CARD

  Widget _buildEcoScoreCard() {
    return Column(
     crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Calculate Your Eco Score ",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: kBtnGreen,
          ),
        ),
        const SizedBox(height: 12),

        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EcoScorePage()),
            ).then((_) {
              loadEcoScore(); // refresh after returning
            });
          },
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(143, 161, 234, 133),
                  Color.fromARGB(227, 33, 133, 2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 33, 45, 27).withOpacity(0.7),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Eco Score 🌿",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Color.fromARGB(255, 73, 71, 71),
                  ),
                ),
                const SizedBox(height: 10),
        
                Text(
                  ecoScore.toStringAsFixed(0),
                  style: const TextStyle(
                    fontSize: 42,
                    color: Color.fromARGB(255, 2, 86, 7),
                    fontWeight: FontWeight.bold,
                  ),
                ),
        
                const SizedBox(height: 5),
        
                Text(
                  ecoScore >= 70
                      ? "Excellent 🌱 Green Traveler"
                      : ecoScore >= 40
                      ? "Moderat   🌿 Improve choices"
                      : "Low Score 🌍  Try eco-friendly options",
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAIAssistantCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Chat with LAK BOT",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: kpurple
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) =>   LakBot()),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(142, 117, 141, 188),
                  kpurple,
                ],
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 34, 29, 84).withOpacity(0.7),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Row(
              children: [
                //lak bot image
                ClipOval(
                  child: Image(
                    image: AssetImage('assets/lakbot.jpg'),
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
        
                SizedBox(width: 16),
                //Text
                Column(
                  children: [
                    
        
                    Text(
                      "Your AI Travel Assistant",
                      style: TextStyle(
                        fontSize: 22,
                        color: kTextGray,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
        
                    Text(
                      "Ask me anything about your trip!",
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
