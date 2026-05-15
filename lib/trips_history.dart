import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'trips_page.dart';
import 'package:lanka_go/widgets/custom_appbar.dart';
import 'package:lanka_go/constance/colors.dart';

class TripHistoryPage extends StatelessWidget {
  const TripHistoryPage({super.key});

  Future<List<Map<String, dynamic>>> getTrips() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final snap = await FirebaseFirestore.instance
        .collection("user_history") 
        .doc(user.uid)
        .collection("trips")
        .orderBy("savedAt", descending: true) 
        .get();

    return snap.docs.map((doc) {
      return {"id": doc.id, ...doc.data()};
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Trip History"),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [kBtnGray, kBrownLight]),
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: getTrips(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final trips = snapshot.data!;

            if (trips.isEmpty) {
              return const Center(
                child: Text(
                  "No trips found",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: trips.length,
              itemBuilder: (context, index) {
                final trip = trips[index];

                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: kBrownDark, width: 1.5),
                  ),
                  color: Colors.black.withOpacity(0.3),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    leading: const Icon(
                      Icons.card_travel,
                      color: kappbaryellow,
                    ),

                    title: Text(
                      "Trip ${index + 1}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kPrimaryYellowDark,
                      ),
                    ),

                    subtitle: const Text(
                      "Tap to view details",
                      style: TextStyle(color: kBrownLight),
                    ),

                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: kBtnGray,
                    ),

                    // PASS DATA TO TripsPage
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              TripsPage(itinerary: trip), 
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
