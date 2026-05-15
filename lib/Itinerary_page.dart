import 'package:flutter/material.dart';
import 'package:lanka_go/trips_page.dart';
import 'package:lanka_go/view_trip.dart';
import 'package:lanka_go/widgets/custom_appbar.dart';
import 'package:lanka_go/constance/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ItineraryPage extends StatefulWidget {
  final List<Map<String, dynamic>> places;
  final List<dynamic> stays;
  final List<Map<String, dynamic>> cafes;

  const ItineraryPage({
    super.key,
    required this.places,
    required this.stays,
    required this.cafes,
  });

  @override
  State<ItineraryPage> createState() => _ItineraryPageState();
}

class _ItineraryPageState extends State<ItineraryPage>
    with AutomaticKeepAliveClientMixin {
  List<Map<String, dynamic>> firestorePlaces = [];
  List<dynamic> firestoreStays = [];
  List<Map<String, dynamic>> firestoreCafes = [];

  bool isLoadingFirestore = true;

  // User selections
  List<Map<String, dynamic>> selectedPlaces = [];
  List<Map<String, dynamic>> selectedStays = [];
  List<Map<String, dynamic>> selectedCafes = [];

  @override
  void initState() {
    super.initState();
    loadSavedRecommendations();
  }

  @override
  bool get wantKeepAlive => true;

  // Load previous trip from Firestore and navigate to TripsPage

  Future<void> viewPreviousTrip() async {
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

      if (snap.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No previous trips found")),
        );
        return;
      }

      final data = snap.docs.first.data();

      final itinerary = {
        "places": data["places"] ?? [],
        "stays": data["stays"] ?? [],
        "cafes": data["cafes"] ?? [],
      };

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TripsPage()),
      );
    } catch (e) {
      debugPrint("Error loading trip: $e");
    }
  }

  //load saved recommendations from Firestore
  Future<void> loadSavedRecommendations() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() => isLoadingFirestore = false);
        return;
      }

      final collection = FirebaseFirestore.instance
          .collection('user_recommendations')
          .doc(user.uid)
          .collection('data');

      final placeSnap = await collection
          .where("type", isEqualTo: "place")
          .orderBy("timestamp", descending: true)
          .limit(1)
          .get();

      if (placeSnap.docs.isNotEmpty) {
        firestorePlaces = List<Map<String, dynamic>>.from(
          placeSnap.docs.first.data()['data'] ?? [],
        );
      }

      final staySnap = await collection
          .where("type", isEqualTo: "stay")
          .orderBy("timestamp", descending: true)
          .limit(1)
          .get();

      if (staySnap.docs.isNotEmpty) {
        firestoreStays = List.from(staySnap.docs.first.data()['data'] ?? []);
      }

      final cafeSnap = await collection
          .where("type", isEqualTo: "cafe")
          .orderBy("timestamp", descending: true)
          .limit(1)
          .get();

      if (cafeSnap.docs.isNotEmpty) {
        firestoreCafes = List<Map<String, dynamic>>.from(
          cafeSnap.docs.first.data()['data'] ?? [],
        );
      }

      setState(() => isLoadingFirestore = false);
    } catch (e) {
      debugPrint("Firestore load error: $e");
      setState(() => isLoadingFirestore = false);
    }
  }

  // Save itinerary and navigate to TripsPage
  Future<void> saveItinerary() async {
    if (selectedPlaces.isEmpty &&
        selectedStays.isEmpty &&
        selectedCafes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one item.")),
      );
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final itinerary = {
        "places": selectedPlaces,
        "stays": selectedStays,
        "cafes": selectedCafes,
        "createdAt": FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection("user_itineraries")
          .doc(user.uid)
          .collection("trips")
          .add(itinerary);

      // Navigate AFTER saving
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TripsPage()),
      );
    } catch (e) {
      debugPrint("Error saving itinerary: $e");
    }
  }

  // Helper functions for selection logic
  bool isSelected(List list, item) {
    return list.any((e) => e["item"] == item);
  }

  int getDay(List list, item) {
    final found = list.firstWhere(
      (e) => e["item"] == item,
      orElse: () => {"day": 1},
    );
    return found["day"] ?? 1;
  }

  void toggleItem(List list, item) {
    setState(() {
      if (isSelected(list, item)) {
        list.removeWhere((e) => e["item"] == item);
      } else {
        list.add({"item": item, "day": 1});
      }
    });
  }

  void updateDay(List list, item, int day) {
    setState(() {
      final index = list.indexWhere((e) => e["item"] == item);
      if (index != -1) {
        list[index]["day"] = day;
      }
    });
  }

  // Build list UI for places, stays, cafes
  Widget buildList({
    required String title,
    required List items,
    required List selectedList,
  }) {
    if (items.isEmpty) {
      return const Text(
        "No data available",
        style: TextStyle(color: Colors.white70),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final selected = isSelected(selectedList, item);
            final day = getDay(selectedList, item);

            return Card(
              color: Colors.white.withOpacity(0.7),
              child: Column(
                children: [
                  CheckboxListTile(
                    value: selected,
                    onChanged: (_) => toggleItem(selectedList, item),
                    title: Text(
                      item['name'] ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  // Day dropdown (only if selected)
                  if (selected)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 10,
                      ),
                      child: Row(
                        children: [
                          const Text("Select Day: "),
                          const SizedBox(width: 10),
                          DropdownButton<int>(
                            value: day,
                            items: List.generate(3, (i) {
                              final d = i + 1;
                              return DropdownMenuItem(
                                value: d,
                                child: Text("Day $d"),
                              );
                            }),
                            onChanged: (val) {
                              if (val != null) {
                                updateDay(selectedList, item, val);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // Main page UI

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final placesData = firestorePlaces.isNotEmpty
        ? firestorePlaces
        : widget.places;

    final staysData = firestoreStays.isNotEmpty ? firestoreStays : widget.stays;

    final cafesData = firestoreCafes.isNotEmpty ? firestoreCafes : widget.cafes;

    return Scaffold(
      appBar: const CustomAppBar(title: " My Itinerary"),
      body: Container(
         width: double.infinity,
         height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              kBrownLight,
              Color.fromARGB(255, 220, 167, 104),
              kBrownLight,
              kBrownDark,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            isLoadingFirestore
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Icon(
                          Icons.map,
                          size: 60,
                          color: kOrangeDark,
                          shadows: [
                            Shadow(
                              color: Colors.black45,
                              offset: Offset(1, 4),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        const Text(
                          "Maximum trip plan 3 days. Please select your preferred places, stays, and cafes for each day.",
                          style: TextStyle(
                            color: kOrangeDark,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black45,
                                offset: Offset(1, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 20),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 15,
                            ),
                          ),
                          onPressed: viewPreviousTrip,
                          child: const Text(
                            "View Previous Selected Trip",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),

                        const SizedBox(height: 20),

                        buildList(
                          title: "Recommended Places",
                          items: placesData,
                          selectedList: selectedPlaces,
                        ),

                        const SizedBox(height: 20),

                        buildList(
                          title: "Recommended Stays",
                          items: staysData,
                          selectedList: selectedStays,
                        ),

                        const SizedBox(height: 20),

                        buildList(
                          title: "Recommended Cafes",
                          items: cafesData,
                          selectedList: selectedCafes,
                        ),

                        const SizedBox(height: 30),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kOrangeDark,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 15,
                            ),
                          ),
                          onPressed: saveItinerary,

                          child: const Text(
                            "Save Itinerary",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),

                        //add button see previous saved itinerary goto trips page
                        const SizedBox(height: 20),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
