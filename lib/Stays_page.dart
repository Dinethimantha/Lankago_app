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

  // ==========================
  // LOAD USER PREFERENCES
  // ==========================
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

      // ✅ Updated Firestore path to match your security rules
      final snapshot = await FirebaseFirestore.instance
          .collection('userprofile')
          .doc(user.uid)
          .collection('recommendation')
          .get();

      if (snapshot.docs.isEmpty) {
        setState(() {
          isLoading = false;
          errorMessage = "No user preferences found in Firestore.";
        });
        return;
      }

      final data = snapshot.docs.first.data();

      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/recommend_stay'), // Emulator URL
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "district": data['district'] ?? "",
          "accommodation_types": data['selectedAccommodation'] ?? "",
          "suitable_for": data['suitableFor'] ?? "",
          "budget_level": data['selectedBudget'] ?? "",
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          recommendedStays = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage =
              "Failed to load recommendations: ${response.statusCode}\n${response.body}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage =
            "Cannot connect to Firestore/API. Make sure your user has permission and the Flask API is running.\nError: $e";
        isLoading = false;
      });
    }
  }

  // ==========================
  // OPEN URL / PHONE
  // ==========================
  Future<void> _openLink(String? contactOrUrl) async {
    if (contactOrUrl == null || contactOrUrl.isEmpty) return;

    contactOrUrl = contactOrUrl.trim();
    Uri uri;

    try {
      if (contactOrUrl.startsWith("http")) {
        uri = Uri.parse(contactOrUrl);
      } else if (contactOrUrl.contains('.') && !contactOrUrl.contains(' ')) {
        uri = Uri.parse("https://$contactOrUrl");
      } else {
        final phone = contactOrUrl.replaceAll(RegExp(r'[^0-9+]'), '');
        uri = Uri(scheme: "tel", path: phone);
      }

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cannot open the link or contact.")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error opening the link or contact.")),
      );
    }
  }

  // ==========================
  // BUILD UI
  // ==========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: "Recommended Stays"),
      body: Stack(
        children: [
          // Background
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
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.center,
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
                                onTap: () =>
                                    _openLink(stay['contact'] ?? ""),
                                child: Card(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  color: Colors.white.withOpacity(0.7),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          stay['name'] ?? "",
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: kOrangeDark),
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
