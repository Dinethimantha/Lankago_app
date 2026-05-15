import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lanka_go/constance/colors.dart';
import 'package:lanka_go/stays_food_places_page.dart';
import 'package:lanka_go/widgets/custom_appbar.dart';

class RecommendationForm extends StatefulWidget {
  const RecommendationForm({super.key});

  @override
  State<RecommendationForm> createState() => _RecommendationFormState();
}

class _RecommendationFormState extends State<RecommendationForm> {
  final _formKey = GlobalKey<FormState>();

  String? selectedDistrict;
  String? numberOfPeople;
  String? selectedBudget;

  List<String> selectedAccommodation = [];
  List<String> selectedTravelType = [];
  List<String> selectedFoodType = [];

  final List<String> districts = [
    "Colombo", "Gampaha", "Kalutara", "Kandy", "Matale", "Nuwara Eliya",
    "Galle", "Matara", "Hambantota", "Jaffna", "Kilinochchi", "Mannar",
    "Vavuniya", "Mullaitivu", "Batticaloa", "Ampara", "Trincomalee",
    "Kurunegala", "Puttalam", "Anuradhapura", "Polonnaruwa",
    "Badulla", "Moneragala", "Ratnapura", "Kegalle",
  ];

  final List<String> peopleOptions = ["Solo", "Couple", "Family"];
  final List<String> budgets = ["Low", "Medium", "High"];
  final List<String> travelOptions = ["Nature", "Adventure", "Historical", "Beaches"];
  final List<String> accommodationTypes = ["Hotel", "Villa", "Resort"];
  final List<String> foodTypes = ["Sri Lankan", "Indian", "Chinese", "English"];

  @override
  void initState() {
    super.initState();
    loadUserPreferences();
  }

  // load user preferences from firestore
  
  Future<void> loadUserPreferences() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('userprofile')
          .doc(user.uid)
          .collection('recommendation')
          .doc('formData')
          .get();

      if (doc.exists) {
        final data = doc.data();
        if (data != null) {
          setState(() {
            selectedDistrict = data['district'];
            numberOfPeople = data['numberOfPeople'];
            selectedBudget = data['budget'];
            selectedAccommodation =
                List<String>.from(data['accommodation'] ?? []);
            selectedTravelType =
                List<String>.from(data['travelType'] ?? []);
            selectedFoodType =
                List<String>.from(data['foodType'] ?? []);
          });
        }
      }
    } catch (e) {
      debugPrint("Error loading preferences: $e");
    }
  }

  // submit form and save to firestore with error handling

  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You must be logged in.")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('userprofile')
          .doc(user.uid)
          .collection('recommendation')
          .doc('formData')
          .set({
        "district": selectedDistrict,
        "numberOfPeople": numberOfPeople,
        "budget": selectedBudget,
        "accommodation": selectedAccommodation,
        "travelType": selectedTravelType,
        "foodType": selectedFoodType,
        "submittedAt": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preferences Saved Successfully!")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => const StaysFoodPlacesPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving data: $e")),
      );
    }
  }

  // dropdown builder
  Widget buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: kOrangeDark)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.black12.withOpacity(0.5),
            contentPadding: const EdgeInsets.symmetric(
                vertical: 12, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: kOrangeDark),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: kOrangeDark, width: 2),
            ),
          ),
          dropdownColor: Colors.black.withOpacity(0.8),
          style:
              const TextStyle(color: kTextWhite, fontSize: 16),
          items: items
              .map((item) =>
                  DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
          validator: (value) =>
              value == null ? "Please select ${label.toLowerCase()}" : null,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // checkbox list builder

  Widget buildCheckboxList({
    required String label,
    required List<String> options,
    required List<String> selectedValues,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: kOrangeDark)),
        ...options.map((option) {
          final isSelected =
              selectedValues.contains(option);
          return CheckboxListTile(
            value: isSelected,
            title: Text(option,
                style: const TextStyle(color: kTextWhite)),
            controlAffinity:
                ListTileControlAffinity.leading,
            activeColor: kOrangeDark,
            onChanged: (bool? value) {
              setState(() {
                if (value == true) {
                  selectedValues.add(option);
                } else {
                  selectedValues.remove(option);
                }
              });
            },
          );
        }),
        const SizedBox(height: 16),
      ],
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          const CustomAppBar(title: "Set Your Preferences"),
      body: Stack(
        children: [
          Image.asset(
            "assets/preferences.jpg",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(color: Colors.black.withOpacity(0.6)),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  buildDropdown(
                    label: "Destination District",
                    value: selectedDistrict,
                    items: districts,
                    onChanged: (val) =>
                        setState(() => selectedDistrict = val),
                  ),
                  buildDropdown(
                    label: "Number of People",
                    value: numberOfPeople,
                    items: peopleOptions,
                    onChanged: (val) =>
                        setState(() => numberOfPeople = val),
                  ),
                  buildDropdown(
                    label: "Budget Range",
                    value: selectedBudget,
                    items: budgets,
                    onChanged: (val) =>
                        setState(() => selectedBudget = val),
                  ),
                  buildCheckboxList(
                      label: "Accommodation Type",
                      options: accommodationTypes,
                      selectedValues:
                          selectedAccommodation),
                  buildCheckboxList(
                      label: "Travel Preferences",
                      options: travelOptions,
                      selectedValues:
                          selectedTravelType),
                  buildCheckboxList(
                      label: "Food Preferences",
                      options: foodTypes,
                      selectedValues:
                          selectedFoodType),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kOrangeDark,
                        foregroundColor: kMainWhite,
                        padding: const EdgeInsets.symmetric(
                            vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8)),
                      ),
                      child: const Text(
                          "Find Recommendations",
                          style:
                              TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
