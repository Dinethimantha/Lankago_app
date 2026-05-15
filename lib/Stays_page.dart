import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lanka_go/constance/colors.dart';
import 'package:lanka_go/widgets/custom_appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class StaysPage extends StatefulWidget {
  const StaysPage({super.key});

  @override
  State<StaysPage> createState() => _StaysPageState();
}

class _StaysPageState extends State<StaysPage> {
  List<dynamic> recommendedStays = [];
  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    loadRecommendations();
  }

  // submit stays to firestore with duplicate prevention

  Future<void> saveStaysToFirestore(List<dynamic> stays) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || stays.isEmpty) return;

      final collection = FirebaseFirestore.instance
          .collection('user_recommendations')
          .doc(user.uid)
          .collection('data');

      // Check last saved stay
      final snapshot = await collection
          .where("type", isEqualTo: "stay")
          .orderBy("timestamp", descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final lastData = snapshot.docs.first.data()['data'];

        // Prevent duplicate save
        if (jsonEncode(lastData) == jsonEncode(stays)) {
          debugPrint("Duplicate stays - not saving");
          return;
        }
      }

      await collection.add({
        "type": "stay",
        "timestamp": FieldValue.serverTimestamp(),
        "data": stays,
      });

      debugPrint("Stays saved to Firestore");
    } catch (e) {
      debugPrint("Error saving stays: $e");
    }
  }

  // load user preferences and get recommendations from API with error handling

  Future<void> loadRecommendations() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          isLoading = false;
          errorMessage = "User not logged in.";
        });
        return;
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('userprofile')
          .doc(user.uid)
          .collection('recommendation')
          .get();

      if (snapshot.docs.isEmpty) {
        setState(() {
          isLoading = false;
          errorMessage = "No user preferences found.";
        });
        return;
      }

      final data = snapshot.docs.first.data();

      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/recommend_stay'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "district": data['district'] ?? "",
          "accommodation_types": data['selectedAccommodation'] ?? "",
          "suitable_for": data['suitableFor'] ?? "",
          "budget_level": data['selectedBudget'] ?? "",
        }),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        setState(() {
          recommendedStays = decoded;
          isLoading = false;
        });

        // Save only if not empty
        if (decoded.isNotEmpty) {
          await saveStaysToFirestore(decoded);
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage =
              "Failed to load recommendations (${response.statusCode})";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Error loading recommendations: $e";
      });
    }
  }

  // open link with error handling (supports URL, domain, phone)

  Future<void> _openLink(String? value) async {
    if (value == null || value.trim().isEmpty) {
      _show("No link available");
      return;
    }

    try {
      String input = value.trim();

      Uri uri;

      //  full URL
      if (input.startsWith("http")) {
        uri = Uri.parse(input);
      }
      //  domain without https
      else if (input.contains(".") && !input.contains(" ")) {
        uri = Uri.parse("https://$input");
      }
      //  phone number
      else {
        final phone = input.replaceAll(RegExp(r'[^0-9+]'), '');
        if (phone.isEmpty) {
          _show("Invalid contact");
          return;
        }
        uri = Uri.parse("tel:$phone");
      }

      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint("Launch error: $e");
      _show("Cannot open link");
    }
  }

  void _show(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: "Recommended Stays"),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              "assets/stays_rec.jpg",
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.4),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          SafeArea(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                ? Center(
                    child: Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                : recommendedStays.isEmpty
                ? const Center(
                    child: Text(
                      "No recommendations found",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: recommendedStays.length,
                    itemBuilder: (context, index) {
                      final stay = recommendedStays[index];

                      return GestureDetector(
                        onTap: () => _openLink(
                          stay['url'] ??
                              stay['URL'] ??
                              stay['website'] ??
                              stay['contact'] ??
                              stay['phone'] ??
                              "",
                        ),
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: Colors.white.withOpacity(0.7),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  stay['name'] ?? "",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: kOrangeDark,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  stay['description'] ?? "",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
