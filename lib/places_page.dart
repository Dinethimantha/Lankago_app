import 'dart:async'; 
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

  Timer? _debounce; 

  @override
  void initState() {
    super.initState();
    loadUserPreferences();

    // debounce search (prevents API spam)
    _searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();

      _debounce = Timer(const Duration(milliseconds: 600), () {
        setState(() {
          userQuery = _searchController.text.trim();
        });

        if (district != null && categories.isNotEmpty) {
          fetchRecommendations();
        }
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel(); 
    super.dispose();
  }

  
  // SAVE TO FIRESTORE

  Future<void> savePlacesToFirestore(List<Map<String, dynamic>> places) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || places.isEmpty) return;

      // PREVENT DUPLICATES (check last saved)
      final snapshot = await FirebaseFirestore.instance
          .collection('user_recommendations')
          .doc(user.uid)
          .collection('data')
          .where("type", isEqualTo: "place")
          .orderBy("timestamp", descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final lastData = snapshot.docs.first.data()['data'];

        if (jsonEncode(lastData) == jsonEncode(places)) {
          debugPrint("Duplicate data - not saving");
          return;
        }
      }

      await FirebaseFirestore.instance
          .collection('user_recommendations')
          .doc(user.uid)
          .collection('data')
          .add({
            "type": "place",
            "timestamp": FieldValue.serverTimestamp(),
            "data": places,
          });

      debugPrint("Saved places to Firestore");
    } catch (e) {
      debugPrint("Error saving places: $e");
    }
  }

  // load user preferences with error handling

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

      final data = snapshot.docs.first.data();

      district = data['district']?.toString();

      if (data['travelType'] != null &&
          (data['travelType'] as List).isNotEmpty) {
        categories = List<String>.from(
          data['travelType'].map((e) => e.toString().trim().toLowerCase()),
        );
      }

      if (district == null || categories.isEmpty) {
        setState(() {
          isLoading = false;
          errorMessage =
              "Preferences incomplete. Please fill the recommendation form.";
        });
        return;
      }

      await fetchRecommendations();
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Error loading preferences: $e";
      });
    }
  }

  // fetch recommendations from backend with error handling

  Future<void> fetchRecommendations() async {
    if (district == null || categories.isEmpty) return;

    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    try {
      final uri = Uri.http('10.0.2.2:5000', '/recommend_place');

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'district': district?.trim() ?? "",
          'categories': categories,
          'query': userQuery,
        }),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(utf8.decode(response.bodyBytes));

        final mapped = data.map((e) => Map<String, dynamic>.from(e)).toList();

        setState(() {
          recommendedPlaces = mapped;
          isLoading = false;
        });

        // SAVE ONLY IF NOT EMPTY
        if (mapped.isNotEmpty) {
          await savePlacesToFirestore(mapped);
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage =
              "Failed to fetch recommendations: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Error fetching recommendations: $e";
      });
    }
  }

  // lunch URL with error handling
  Future<void> _launchUrl(String url) async {
  if (url.trim().isEmpty) return;

  try {
    String finalUrl = url.trim();

    // add https if missing
    if (!finalUrl.startsWith("http")) {
      finalUrl = "https://$finalUrl";
    }

    final uri = Uri.parse(finalUrl);

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  } catch (e) {
    debugPrint("Launch error: $e");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Cannot open this link")),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Recommended Places"),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset("assets/places_rec.jpg", fit: BoxFit.cover),
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
                      style: const TextStyle(color: Colors.white, fontSize: 16),
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

                      return GestureDetector(
                        onTap: () => _launchUrl(
                          place['url'] ??
                              place['URL'] ??
                              place['link'] ??
                              place['website'] ??
                              "",
                        ),
                        child: Card(
                          color: Colors.white.withOpacity(0.7),
                          margin: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 12,
                          ),
                          child: ListTile(
                            title: Text(
                              place['name'] ?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kOrangeDark,
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Text(place['description'] ?? ""),
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
