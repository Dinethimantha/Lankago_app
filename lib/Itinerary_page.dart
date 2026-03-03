import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lanka_go/widgets/custom_appbar.dart';
import 'package:lanka_go/constance/colors.dart';

class ItineraryPage extends StatefulWidget {
  const ItineraryPage({super.key});

  @override
  State<ItineraryPage> createState() => _ItineraryPageState();
}

class _ItineraryPageState extends State<ItineraryPage> {
  bool loading = true;

  List<Map<String, dynamic>> allItems = [];
  Map<String, bool> selectedItems = {};
  Map<String, String> selectedDays = {};

  final List<String> days = ["Day 1", "Day 2", "Day 3"];

  @override
  void initState() {
    super.initState();
    loadAllRecommendations();
  }

  // =============================
  // LOAD ALL RECOMMENDATIONS
  // =============================
  Future<void> loadAllRecommendations() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // 🔹 Updated Firestore path according to rules
      final prefsSnapshot = await FirebaseFirestore.instance
          .collection('userprofile')
          .doc(user.uid)
          .collection('recommendation')
          .get();

      if (prefsSnapshot.docs.isEmpty) {
        setState(() => loading = false);
        return;
      }

      final data = prefsSnapshot.docs.first.data();

      // --------- PLACES ----------
      final placeRes = await http.post(
        Uri.parse('http://10.0.2.2:5000/recommend_place'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "district": data['district'] ?? "",
          "categories": data['travelType'] ?? [],
          "query": ""
        }),
      );

      if (placeRes.statusCode == 200) {
        final List places = jsonDecode(placeRes.body);
        for (var p in places) {
          allItems.add({"name": p['name'], "type": "place"});
        }
      }

      // --------- STAYS ----------
      final stayRes = await http.post(
        Uri.parse('http://10.0.2.2:5000/recommend_stay'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "district": data['district'] ?? "",
          "accommodation_types": data['accommodation'] ?? [],
          "budget_level": data['budget'] ?? "",
        }),
      );

      if (stayRes.statusCode == 200) {
        final List stays = jsonDecode(stayRes.body);
        for (var s in stays) {
          allItems.add({"name": s['name'], "type": "stay"});
        }
      }

      // --------- CAFES ----------
      final cafeRes = await http.post(
        Uri.parse('http://10.0.2.2:5000/recommend_cafe'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "district": data['district'] ?? "",
          "foodType": data['foodType'] ?? [],
          "numberOfPeople": [data['numberOfPeople'] ?? 1],
          "budget": data['budget'] ?? "",
        }),
      );

      if (cafeRes.statusCode == 200) {
        final List cafes = jsonDecode(cafeRes.body);
        for (var c in cafes) {
          allItems.add({"name": c['name'], "type": "cafe"});
        }
      }

      setState(() => loading = false);
    } catch (e) {
      debugPrint("Error loading recommendations: $e");
      setState(() => loading = false);
    }
  }

  // =============================
  // SAVE ITINERARY
  // =============================
  Future<void> saveItinerary() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    List<Map<String, dynamic>> selectedData = [];

    for (var item in allItems) {
      final name = item['name'];

      if (selectedItems[name] == true && selectedDays.containsKey(name)) {
        selectedData.add({
          "name": name,
          "type": item['type'],
          "day": selectedDays[name],
        });
      }
    }

    if (selectedData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select at least one item with a day.")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('user_itinerary')
          .doc(user.uid)
          .set({
        "items": selectedData,
        "createdAt": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Itinerary Saved Successfully")),
      );
    } catch (e) {
      debugPrint("Error saving itinerary: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save itinerary")),
      );
    }
  }

  // =============================
  // UI
  // =============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Build Your Itinerary"),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : allItems.isEmpty
              ? const Center(child: Text("No recommendations found"))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: allItems.length,
                        itemBuilder: (context, index) {
                          final item = allItems[index];
                          final name = item['name'];
                          final type = item['type'];

                          return Card(
                            margin: const EdgeInsets.all(8),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  CheckboxListTile(
                                    value: selectedItems[name] ?? false,
                                    title: Text(
                                      "$name (${type.toUpperCase()})",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        selectedItems[name] = val ?? false;
                                        if (val == false) {
                                          selectedDays.remove(name);
                                        }
                                      });
                                    },
                                  ),

                                  if (selectedItems[name] == true)
                                    DropdownButtonFormField<String>(
                                      value: selectedDays[name],
                                      hint: const Text("Select Day"),
                                      items: days
                                          .map((day) => DropdownMenuItem(
                                                value: day,
                                                child: Text(day),
                                              ))
                                          .toList(),
                                      onChanged: (val) {
                                        setState(() {
                                          selectedDays[name] = val!;
                                        });
                                      },
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: saveItinerary,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: kOrangeDark),
                          child: const Text("Save Itinerary"),
                        ),
                      ),
                    )
                  ],
                ),
    );
  }
}
