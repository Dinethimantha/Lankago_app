import 'package:flutter/material.dart';
import 'package:lanka_go/constance/colors.dart';
import 'package:lanka_go/widgets/custom_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EcoScorePage extends StatefulWidget {
  const EcoScorePage({super.key});

  @override
  State<EcoScorePage> createState() => _EcoScorePageState();
}

class _EcoScorePageState extends State<EcoScorePage> {
  String? transport;
  String? food;
  String? stay;

  double score = 0;
  List<String> history = [];

  @override
  void initState() {
    super.initState();
    loadHistory(); // LOAD HISTORY
    loadCurrentScore(); // LOAD CURRENT SCORE
  }

  // LOAD HISTORY
  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      history = prefs.getStringList("eco_history") ?? [];
    });
  }

  // SAVE HISTORY
  Future<void> saveScore(double value) async {
    final prefs = await SharedPreferences.getInstance();
    history.insert(0, "Eco Score: ${value.toStringAsFixed(1)}%");
    await prefs.setStringList("eco_history", history);
  }

  // SAVE CURRENT SCORE
  Future<void> saveCurrentScore(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("eco_score", value); // FIXED KEY
  }

  // LOAD CURRENT SCORE (THIS FIXES YOUR ISSUE)
  Future<void> loadCurrentScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      score = prefs.getDouble("eco_score") ?? 0;
    });
  }

  void calculateScore() {
    int total = 0;

    // Transport
    switch (transport) {
      case "walk":
      case "bike":
        total += 25;
        break;
      case "bus":
      case "train":
        total += 20;
        break;
      case "tuk":
        total += 10;
        break;
      case "car":
        total += 0;
        break;
    }

    // Food
    switch (food) {
      case "vegan":
        total += 25;
        break;
      case "vegetarian":
        total += 20;
        break;
      case "mixed":
        total += 10;
        break;
      case "meat":
        total += 0;
        break;
    }

    // Stay
    switch (stay) {
      case "villa":
      case "resort":
        total += 5;
        break;
      case "standard":
        total += 15;
        break;
      case "luxury":
        total += 0;
        break;
    }

    double finalScore = (total / 75) * 100;

    setState(() {
      score = finalScore;
    });

    saveScore(finalScore);
    saveCurrentScore(finalScore);
    loadHistory();
  }

  Widget buildRadio(
    String title,
    String value,
    String? group,
    Function(String?) onChanged,
  ) {
    return RadioListTile<String>(
      title: Text(title),
      value: value,
      groupValue: group,
      onChanged: onChanged,
    );
  }

  Widget buildSection(String title, Widget child) {
    return Card(
      color: kBrownLight.withOpacity(0.3),
      margin: const EdgeInsets.all(5),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kBrownDark,
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Eco Score Calculator"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset("assets/eco.jpg", height: 200, fit: BoxFit.cover),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Calculate your Eco Score based on your  choices!",
                style: const TextStyle(
                  fontSize: 20,
                  color: kBrownDark,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              "You can calculator one day eco score at a time.",
              style: const TextStyle(
                fontSize: 18,
                color: kBtnGreen,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            buildSection(
              "Transportation Preference ",
              Column(
                children: [
                  buildRadio(
                    "Car",
                    "car",
                    transport,
                    (v) => setState(() => transport = v),
                  ),
                  buildRadio(
                    "Tuk",
                    "tuk",
                    transport,
                    (v) => setState(() => transport = v),
                  ),
                  buildRadio(
                    "Bus",
                    "bus",
                    transport,
                    (v) => setState(() => transport = v),
                  ),
                  buildRadio(
                    "Train",
                    "train",
                    transport,
                    (v) => setState(() => transport = v),
                  ),
                  buildRadio(
                    "Walk",
                    "walk",
                    transport,
                    (v) => setState(() => transport = v),
                  ),
                  buildRadio(
                    "Bike",
                    "bike",
                    transport,
                    (v) => setState(() => transport = v),
                  ),
                ],
              ),
            ),

            buildSection(
              "Food Preference",
              Column(
                children: [
                  buildRadio(
                    "Meat Based",
                    "meat",
                    food,
                    (v) => setState(() => food = v),
                  ),
                  buildRadio(
                    "Mixed Diet",
                    "mixed",
                    food,
                    (v) => setState(() => food = v),
                  ),
                  buildRadio(
                    "Vegetarian",
                    "vegetarian",
                    food,
                    (v) => setState(() => food = v),
                  ),
                  buildRadio(
                    "Vegan",
                    "vegan",
                    food,
                    (v) => setState(() => food = v),
                  ),
                ],
              ),
            ),

            buildSection(
              "Preferred Stay Type",
              Column(
                children: [
                  buildRadio(
                    "Luxury Hotel",
                    "luxury",
                    stay,
                    (v) => setState(() => stay = v),
                  ),
                  buildRadio(
                    "Standard Hotel",
                    "standard",
                    stay,
                    (v) => setState(() => stay = v),
                  ),
                  buildRadio(
                    "Villa",
                    "villa",
                    stay,
                    (v) => setState(() => stay = v),
                  ),
                  buildRadio(
                    "Resort",
                    "resort",
                    stay,
                    (v) => setState(() => stay = v),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kBtnGreen,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
              ),
              onPressed: calculateScore,
              child: const Text(
                "Calculate Eco Score",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Eco Score: ${score.toStringAsFixed(1)}%",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: LinearProgressIndicator(value: score / 100, minHeight: 10, color: const Color.fromARGB(255, 107, 196, 112),),
            ),

            const Divider(),

            const Text(
              "Previous Scores",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kBrownDark),
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: history.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(history[index]),
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
