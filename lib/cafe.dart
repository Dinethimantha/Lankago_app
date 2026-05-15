import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:lanka_go/constance/colors.dart';
import 'package:lanka_go/widgets/custom_appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class CafesPage extends StatefulWidget {
  const CafesPage({super.key});

  @override
  State<CafesPage> createState() => _CafesPageState();
}

class _CafesPageState extends State<CafesPage> {
  List<Map<String, dynamic>> recommendedCafes = [];
  bool loading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadCafes();
  }

 
  //save cafes to firestore with duplicate prevention 

  Future<void> saveCafesToFirestore(List<Map<String, dynamic>> cafes) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || cafes.isEmpty) return;

      final collection = FirebaseFirestore.instance
          .collection('user_recommendations')
          .doc(user.uid)
          .collection('data');

      // Check last saved cafes
      final snapshot = await collection
          .where("type", isEqualTo: "cafe")
          .orderBy("timestamp", descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final lastData = snapshot.docs.first.data()['data'];

        // Prevent duplicate save
        if (jsonEncode(lastData) == jsonEncode(cafes)) {
          debugPrint("Duplicate cafes - not saving");
          return;
        }
      }

      await collection.add({
        "type": "cafe",
        "timestamp": FieldValue.serverTimestamp(),
        "data": cafes,
      });

      debugPrint("Cafes saved to Firestore");
    } catch (e) {
      debugPrint("Error saving cafes: $e");
    }
  }

  // load cafes from backend and handle errors
  Future<void> loadCafes() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          loading = false;
          errorMessage = "You must be logged in.";
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
          loading = false;
          errorMessage = "No preferences found for your account.";
        });
        return;
      }

      final data = snapshot.docs.first.data();

      final uri = Uri.parse('http://10.0.2.2:5000/recommend_cafe');

      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "district": data['district'] ?? '',
          "foodType": List<String>.from(data['foodType'] ?? []),
          "numberOfPeople": [data['numberOfPeople'] ?? ''],
          "budget": data['budget'] ?? '',
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> cafes = jsonDecode(response.body);

        final mapped = cafes.map((c) => Map<String, dynamic>.from(c)).toList();

        setState(() {
          recommendedCafes = mapped;
          loading = false;

          if (mapped.isEmpty) {
            errorMessage = "No recommendations found.";
          }
        });

        //  Save only if not empty
        if (mapped.isNotEmpty) {
          await saveCafesToFirestore(mapped);
        }
      } else {
        setState(() {
          loading = false;
          errorMessage = "Failed to load cafes: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        loading = false;
        errorMessage = "Error loading cafes: $e";
      });
    }
  }

  // open URL or dial number based on card tap, with error handling

  Future<void> handleCardTap(String? value) async {
    if (value == null || value.trim().isEmpty) {
      _showMessage("No link or contact available");
      return;
    }

    try {
      value = value.trim();

      Uri uri;

      //  URL handling
      if (value.startsWith("http")) {
        uri = Uri.parse(value);
      }
      //  domain without https
      else if (value.contains(".") && !value.contains(" ")) {
        uri = Uri.parse("https://$value");
      }
      // phone number
      else {
        final phone = value.replaceAll(RegExp(r'[^0-9+]'), '');
        uri = Uri.parse("tel:$phone");
      }

      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint("Launch error: $e");
      _showMessage("Cannot open this link");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: const CustomAppBar(title: "Recommended Cafes"),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              "assets/cafe_rec.jpg",
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.5),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          SafeArea(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage != null
                ? Center(
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: recommendedCafes.length,
                    itemBuilder: (context, index) {
                      final cafe = recommendedCafes[index];

                      return GestureDetector(
                        onTap: () => handleCardTap(
                          cafe['url/contact number']?.toString(),
                        ),
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          color: kMainWhite.withOpacity(0.7),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cafe['name'] ?? 'Unnamed Cafe',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: kOrangeDark,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  cafe['description'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
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
