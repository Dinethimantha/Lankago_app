import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lanka_go/constance/colors.dart';
import 'package:lanka_go/widgets/custom_appbar.dart';
import 'footer.dart'; // Import your Footer widget

class SavePage extends StatefulWidget {
  const SavePage({super.key});

  @override
  State<SavePage> createState() => _SavePageState();
}

class _SavePageState extends State<SavePage> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // ✅ Updated path according to rules
      final snapshot = await FirebaseFirestore.instance
          .collection('userprofile')
          .doc(user.uid)
          .collection('recommendation')
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Take the first document for display
        setState(() {
          userData = snapshot.docs.first.data();
        });
      }
    } catch (e) {
      debugPrint("Error loading itinerary: $e");
    }
  }

  Widget buildListTile(String title, dynamic value) {
    if (value == null) return const SizedBox.shrink();
    String displayText;

    if (value is List) {
      displayText = value.join(", ");
    } else {
      displayText = value.toString();
    }

    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: kBrownDark,
        ),
      ),
      subtitle: Text(
        displayText,
        style: const TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                  vertical: 25.0, horizontal: 14.0),
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  const Text("Your Saved Itinerary",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: kBrownDark)),
                  Image.asset(
                    "assets/itinerary2.jpg",
                    fit: BoxFit.cover,
                    width: 300,
                    height: 300,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: kBrownLight,
                    ),
                    child: Column(
                      children: [
                        buildListTile("Destination District",
                            userData!['district']),
                        buildListTile("Number of People",
                            userData!['numberOfPeople']),
                        buildListTile("Budget Range", userData!['budget']),
                        buildListTile(
                            "Accommodation Type", userData!['accommodation']),
                        buildListTile(
                            "Travel Preferences", userData!['travelType']),
                        buildListTile("Food Preferences", userData!['foodType']),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: const Footer(selectedIndex: 3),
    );
  }
}
