import 'package:flutter/material.dart';
import 'package:lanka_go/home.dart';
import 'package:lanka_go/offline_mode_page.dart';
import 'package:lanka_go/widgets/custom_appbar.dart';
import 'package:lanka_go/constance/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TripsPage extends StatefulWidget {
  final Map<String, dynamic>? itinerary;

  const TripsPage({super.key, this.itinerary});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  Map<String, dynamic>? itinerary;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // If data passed → use it
    if (widget.itinerary != null) {
      itinerary = widget.itinerary;
      isLoading = false;
    } else {
      loadLatestTrip(); // fallback
    }
  }
  //  Load the most recent trip from Firestore

  Future<void> loadLatestTrip() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final snap = await FirebaseFirestore.instance
          .collection("user_itineraries")
          .doc(user.uid)
          .collection("trips")
          .orderBy("createdAt", descending: true)
          .limit(1)
          .get();

      if (snap.docs.isNotEmpty) {
        itinerary = snap.docs.first.data();
      }

      setState(() => isLoading = false);
    } catch (e) {
      debugPrint("Error loading trip: $e");
      setState(() => isLoading = false);
    }
  }

  // Extract a list of items by key
  List<Map<String, dynamic>> _extract(String key) {
    final data = itinerary?[key];
    if (data == null || data is! List) return [];
    return List<Map<String, dynamic>>.from(data);
  }

  Map<int, Map<String, List<String>>> groupAllByDay() {
    Map<int, Map<String, List<String>>> result = {};

    void addItems(List<Map<String, dynamic>> list, String type) {
      for (var item in list) {
        final day = item["day"] ?? 1;

        final name = item["item"] is Map
            ? item["item"]["name"] ?? ""
            : item["item"]?.toString() ?? "";

        result.putIfAbsent(day, () => {"places": [], "stays": [], "cafes": []});

        result[day]![type]!.add(name);
      }
    }

    addItems(_extract("places"), "places");
    addItems(_extract("stays"), "stays");
    addItems(_extract("cafes"), "cafes");

    return result;
  }

  // SAVE TO HISTORY
  Future<void> saveTripToFirestore() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("User not logged in")));
        return;
      }

      if (itinerary == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("No itinerary to save")));
        return;
      }

      // SAVE TO FIRESTORE
      await FirebaseFirestore.instance
          .collection("user_history")
          .doc(user.uid)
          .collection("trips")
          .add({
            "places": itinerary!["places"] ?? [],
            "stays": itinerary!["stays"] ?? [],
            "cafes": itinerary!["cafes"] ?? [],
            "savedAt": FieldValue.serverTimestamp(),
          });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Trip saved to history")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error saving trip: $e")));
    }
  }

  // SAVE OFFLINE
  Future<void> saveTripOffline() async {
    try {
      if (itinerary == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("No itinerary to save")));
        return;
      }

      // SAVE OFFLINE (FIXED)
      final prefs = await SharedPreferences.getInstance();

      final offlineData = {
        "places": itinerary?["places"] ?? [],
        "stays": itinerary?["stays"] ?? [],
        "cafes": itinerary?["cafes"] ?? [],
      };

      debugPrint("Saving Offline Data: ${jsonEncode(offlineData)}");

      await prefs.setString("cached_trip", jsonEncode(offlineData));
    } catch (e) {
      debugPrint("Error saving history: $e");
      debugPrint("SAVING OFFLINE DATA: ${jsonEncode(itinerary)}");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Trip saved + cached offline")),
      );
    }
  }

  //UI for each day card
  Widget buildDayCard(int day, Map<String, List<String>> data) {
    return SizedBox(
      width: double.infinity,

      child: Card(
        color: Colors.white.withOpacity(0.6),
        margin: const EdgeInsets.only(bottom: 15),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Day $day Trip",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kOrangeDark,
                ),
              ),
              const SizedBox(height: 10),

              if (data["places"]!.isNotEmpty) ...[
                const Text(
                  "📍 Places",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...data["places"]!.map((e) => Text("• $e")),
              ],

              if (data["stays"]!.isNotEmpty) ...[
                const Text(
                  "🏨 Stays",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...data["stays"]!.map((e) => Text("• $e")),
              ],

              if (data["cafes"]!.isNotEmpty) ...[
                const Text(
                  "☕ Cafes",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...data["cafes"]!.map((e) => Text("• $e")),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final grouped = itinerary == null ? {} : groupAllByDay();
    final sortedDays = grouped.keys.toList()..sort();

    return Scaffold(
      appBar: const CustomAppBar(title: "My Trips"),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SizedBox.expand(
                  child: Image.asset("assets/trip.jpg", fit: BoxFit.cover),
                ),
                Container(color: Colors.black.withOpacity(0.7)),

                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        "Your Saved Itinerary",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 20),

                      if (itinerary == null)
                        const Text(
                          "No saved trips found",
                          style: TextStyle(color: Colors.white),
                        )
                      else
                        ...sortedDays.map(
                          (day) => buildDayCard(day, grouped[day]!),
                        ),

                      const SizedBox(height: 20),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kOrangeDark,
                        ),
                        onPressed: saveTripToFirestore,
                        child: const Text("Save to History"),
                      ),

                      const SizedBox(height: 10),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                          );
                        },
                        child: const Text("Back to Home"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
