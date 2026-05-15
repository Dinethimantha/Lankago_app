import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lanka_go/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lanka_go/widgets/custom_appbar.dart';
import 'package:lanka_go/constance/colors.dart';

class OfflinePage extends StatefulWidget {
  const OfflinePage({super.key});

  @override
  State<OfflinePage> createState() => _OfflinePageState();
}

class _OfflinePageState extends State<OfflinePage> {
  Map<String, dynamic>? cachedTrip;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCachedTrip();
  }

  Future<void> loadCachedTrip() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // DEBUG
      print("Checking cached_trip...");

      final data = prefs.getString("cached_trip");

      print("Saved Data: $data");

      if (data != null && data.trim().isNotEmpty) {
        final decoded = jsonDecode(data);

        if (decoded is Map<String, dynamic>) {
          cachedTrip = decoded;
        } else {
          cachedTrip = null;
        }
      } else {
        cachedTrip = null;
      }
    } catch (e) {
      print("Error loading cached trip: $e");
      cachedTrip = null;
    }

    setState(() {
      isLoading = false;
    });
  }

  // GROUP BY DAY
  Map<int, Map<String, List<String>>> groupByDay() {
    Map<int, Map<String, List<String>>> result = {};

    void addItems(List list, String type) {
      for (var e in list) {
        if (e is Map) {
          final day = e["day"] ?? 1;

          final name = e["item"] is Map
              ? e["item"]["name"] ?? "Unknown"
              : e["item"]?.toString() ?? "Unknown";

          result.putIfAbsent(
            day,
            () => {"places": [], "stays": [], "cafes": []},
          );

          result[day]![type]!.add(name);
        }
      }
    }

    addItems(cachedTrip?["places"] ?? [], "places");
    addItems(cachedTrip?["stays"] ?? [], "stays");
    addItems(cachedTrip?["cafes"] ?? [], "cafes");

    return result;
  }

  // BUILD DAY CARD
  Widget buildDayCard(int day, Map<String, List<String>> data) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Colors.white.withOpacity(0.75),
        margin: const EdgeInsets.only(bottom: 15),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Day $day",
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                ...data["places"]!.map(
                  (e) => Text("• $e", style: const TextStyle(fontSize: 15)),
                ),
                const SizedBox(height: 8),
              ],

              if (data["stays"]!.isNotEmpty) ...[
                const Text(
                  "🏨 Stays",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                ...data["stays"]!.map(
                  (e) => Text("• $e", style: const TextStyle(fontSize: 15)),
                ),
                const SizedBox(height: 8),
              ],

              if (data["cafes"]!.isNotEmpty) ...[
                const Text(
                  "☕ Cafes",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                ...data["cafes"]!.map(
                  (e) => Text("• $e", style: const TextStyle(fontSize: 15)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final grouped = cachedTrip == null ? {} : groupByDay();
    final days = grouped.keys.toList()..sort();

    return Scaffold(
      appBar: const CustomAppBar(title: "Offline Mode"),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kBtnGray, kBrownLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : cachedTrip == null
            ? const Center(
                child: Text(
                  "No offline data found",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Offline Saved Trip",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: kBtnBlue,
                        ),
                      ),

                      const SizedBox(height: 20),

                      ...days.map((day) {
                        return buildDayCard(day, grouped[day]!);
                      }),

                      const SizedBox(height: 20),

                      Center(
                        child: ElevatedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const HomePage()),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kOrangeDark,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          child: const Text(
                            "Back to Home",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
