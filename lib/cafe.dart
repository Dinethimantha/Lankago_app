import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:lanka_go/constance/colors.dart';
import 'dart:convert';
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

      // ✅ Updated Firestore path to match rules
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

      final data = snapshot.docs.first.data(); // Take first preference

      final district = data['district'] ?? '';
      final foodTypes = List<String>.from(data['foodType'] ?? []);
      final suitableFor = [data['numberOfPeople'] ?? ''];
      final budget = data['budget'] ?? '';

      final uri = Uri.parse('http://192.168.1.5:5000/recommend_cafe');

      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "district": district,
          "foodType": foodTypes,
          "numberOfPeople": suitableFor,
          "budget": budget,
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> cafes = jsonDecode(response.body);
        setState(() {
          recommendedCafes =
              cafes.map((c) => Map<String, dynamic>.from(c)).toList();
          loading = false;
          if (recommendedCafes.isEmpty) {
            errorMessage = "No recommendations found.";
          }
        });
      } else {
        setState(() {
          loading = false;
          errorMessage = "Server error ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        loading = false;
        errorMessage =
            "Cannot connect to Firestore/API. Make sure your user has permission and the Flask API is running.\nError: $e";
      });
    }
  }

  Future<void> handleCardTap(String? contactOrUrl) async {
    if (contactOrUrl == null || contactOrUrl.isEmpty) {
      _showMessage("Search on Google for better experience");
      return;
    }

    contactOrUrl = contactOrUrl.trim();

    try {
      Uri uri;
      if (contactOrUrl.startsWith("http")) {
        uri = Uri.parse(contactOrUrl);
      } else if (contactOrUrl.contains('.') && !contactOrUrl.contains(' ')) {
        uri = Uri.parse("https://$contactOrUrl");
      } else {
        final phone = contactOrUrl.replaceAll(RegExp(r'[^0-9+]'), '');
        if (phone.isEmpty) {
          _showMessage("Search on Google for better experience");
          return;
        }
        uri = Uri(scheme: "tel", path: phone);
      }

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showMessage("Cannot open the link or contact.");
      }
    } catch (e) {
      _showMessage("Search on Google for better experience");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        itemCount: recommendedCafes.length,
                        itemBuilder: (context, index) {
                          final cafe = recommendedCafes[index];
                          final name = cafe['name'] ?? 'Unnamed Cafe';
                          final description = cafe['description'] ?? '';
                          final contact = cafe['url/contact number'] ?? '';

                          return GestureDetector(
                            onTap: () => handleCardTap(contact),
                            child: Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              color: kMainWhite.withOpacity(0.7),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: kOrangeDark,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      description,
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
