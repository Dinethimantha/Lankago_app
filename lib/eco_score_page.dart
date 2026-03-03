import 'package:flutter/material.dart';
import 'footer.dart'; // ✅ Import your custom footer

class EcoScorePage extends StatefulWidget {
  const EcoScorePage({super.key});

  @override
  State<EcoScorePage> createState() => _EcoScorePageState();
}

class _EcoScorePageState extends State<EcoScorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        iconTheme: const IconThemeData(color: Colors.brown),
        title: const Text(
          'Eco Travel Score',
          style: TextStyle(color: Colors.brown),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Your Eco Score
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFE16B), Color(0xFFE2BD2B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Your Eco Score",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Keep up the great work!",
                      style: TextStyle(color: Colors.black87),
                    ),
                    SizedBox(height: 12),
                    Text("This Week", style: TextStyle(color: Colors.black87)),
                    SizedBox(height: 4),
                    Text(
                      "73",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "vs Last Week +12",
                      style: TextStyle(color: Colors.green),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Recent Activities
              const Text(
                "Recent Activities",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 8),
              _activityItem("Shared Tuk-Tuk", "+5 points", "2 hours ago"),
              _activityItem("Cycling", "+8 points", "5 hours ago"),
              _activityItem("Public Transport", "+6 points", "Yesterday"),
              _activityItem("Walking Tour", "+4 points", "Yesterday"),
              const SizedBox(height: 20),

              // Reward Badges
              const Text(
                "Reward Badges",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _badgeCard("Eco Explorer", "Level 3"),
                  _badgeCard("Green Traveller", "Level 2"),
                  _badgeCard("Eco Warrior", "Level 1"),
                  _badgeCard("Planet Hero", "Locked"),
                ],
              ),
              const SizedBox(height: 20),

              // Eco Tips
              const Text(
                "Eco Tips",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.yellow[100],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Text(
                  "Try carpooling! Share rides with other travelers to reduce your carbon footprint and earn more eco points.",
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ),

      // ✅ Footer at Bottom
      bottomNavigationBar: const Footer(selectedIndex: 0),
    );
  }

  // Recent activity item
  static Widget _activityItem(String activity, String points, String time) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(
          activity,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(time),
        trailing: Text(
          points,
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Badge card
  static Widget _badgeCard(String title, String level) {
    bool locked = level.toLowerCase() == "locked";
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: locked ? Colors.grey[300] : Colors.yellow[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.emoji_events,
            color: locked ? Colors.grey : Colors.brown,
            size: 30,
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              color: locked ? Colors.grey : Colors.brown,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            level,
            style: TextStyle(color: locked ? Colors.grey : Colors.green),
          ),
        ],
      ),
    );
  }
}
