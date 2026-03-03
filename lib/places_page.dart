import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:lanka_go/constance/colors.dart';
import 'package:lanka_go/widgets/custom_appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class PlacesPage extends StatefulWidget {
  const PlacesPage({super.key});

  @override
  State<PlacesPage> createState() => _PlacesPageState();
}

class _PlacesPageState extends State<PlacesPage> {
  List<Map<String, dynamic>> recommendedPlaces = [];
  bool isLoading = true;
  String? district;
  List<String> categories = [];
  String userQuery = "";
  String errorMessage = "";

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserPreferences();

    // Listen to search input
    _searchController.addListener(() {
      setState(() {
        userQuery = _searchController.text.trim();
      });
      if (district != null && categories.isNotEmpty) {
        fetchRecommendations();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ===========================
  // LOAD USER PREFERENCES
  // ===========================
  Future<void> loadUserPreferences() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          isLoading = false;
          errorMessage = "User not logged in.";
        });
        return;
      }

      // ✅ Updated Firestore path to match your rules
      final snapshot = await FirebaseFirestore.instance
          .collection('userprofile')
          .doc(user.uid)
          .collection('recommendation')
          .get();

      if (snapshot.docs.isEmpty) {
        setState(() {
          isLoading = false;
          errorMessage =
              "No user preferences found. Please fill the recommendation form.";
        });
        return;
      }

      // Take first recommendation document
      final data = snapshot.docs.first.data();

      district = data['district']?.toString();
      if (data['travelType'] != null && (data['travelType'] as List).isNotEmpty) {
        categories = List<String>.from(
            data['travelType'].map((e) => e.toString().trim().toLowerCase()));
      }

      if (district == null || categories.isEmpty) {
        setState(() {
          isLoading = false;
          errorMessage =
              "Preferences incomplete: district or category missing.\nPlease fill the recommendation form.";
        });
        return;
      }

      await fetchRecommendations();
    } catch (e) {
      debugPrint("Error loading user preferences: $e");
      setState(() {
        isLoading = false;
        errorMessage =
            "Error loading preferences: $e\nCheck Firestore permissions.";
      });
    }
  }

  // ===========================
  // FETCH RECOMMENDATIONS
  // ===========================
  Future<void> fetchRecommendations() async {
    if (district == null || categories.isEmpty) return;

    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    try {
      final uri = Uri.http('10.0.2.2:5000', '/recommend_place');

      final body = jsonEncode({
        'district': district?.trim() ?? "",
        'categories': categories,
        'query': userQuery,
      });

      debugPrint("Sending request to API: $body");

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      debugPrint("API response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final List data = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          recommendedPlaces =
              data.map((e) => Map<String, dynamic>.from(e)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage =
              "API returned status ${response.statusCode}. Check Flask server.";
        });
      }
    } catch (e) {
      debugPrint("Error fetching places: $e");
      setState(() {
        isLoading = false;
        errorMessage =
            "Cannot connect to server. Make sure Flask API is running and network is correct.";
      });
    }
  }

  // ===========================
  // LAUNCH URL
  // ===========================
  Future<void> _launchUrl(String url) async {
    if (url.isEmpty) return;

    url = url.trim();
    final Uri? uri = Uri.tryParse(url);

    if (uri == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid URL: $url")),
      );
      return;
    }

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Cannot open URL: $url")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error opening URL: $url")),
      );
    }
  }

  // ===========================
  // BUILD UI
  // ===========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Recommended Places"),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              "assets/places_rec.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Container(color: Colors.black.withOpacity(0.6)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                    : recommendedPlaces.isEmpty
                        ? const Center(
                            child: Text(
                              "No recommendations found",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : ListView.builder(
                            itemCount: recommendedPlaces.length,
                            itemBuilder: (context, index) {
                              final place = recommendedPlaces[index];
                              final url = place['URL'] ?? "";

                              return GestureDetector(
                                onTap: () => _launchUrl(url),
                                child: Card(
                                  color: Colors.white.withOpacity(0.7),
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 12),
                                  elevation: 3,
                                  child: ListTile(
                                    title: Text(
                                      place['name'] ?? "",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: kOrangeDark,
                                          fontSize: 20),
                                    ),
                                    subtitle: Text(
                                      place['description'] ?? "",
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.black),
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
