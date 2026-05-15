import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lanka_go/constance/colors.dart';
import 'package:lanka_go/onboard.dart';
import 'package:lanka_go/widgets/appbar_without_arrow.dart';
import 'package:lanka_go/widgets/custom_appbar.dart';
import 'edit_profile.dart';
import 'home.dart';
import 'footer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Profile data
  String fullName = " ";
  String email = " ";
  String phone = " ";
  String country = " ";

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // Load profile from Firebase
  void _loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      email = user.email ?? "-";
      final uid = user.uid;
      final doc = await FirebaseFirestore.instance
          .collection('userprofile')
          .doc(uid)
          .get();

      if (doc.exists) {
        setState(() {
          fullName = doc['fullName'] ?? " ";
          phone = doc['phone'] ?? " ";
          country = doc['country'] ?? " ";
        });
      } else {
        setState(() {}); // only email updated
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithoutArrow(title: "Profile"),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              kMainWhite,
              const Color.fromARGB(127, 161, 136, 127),
              kMainWhite,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.asset(
                  "assets/profile.png",
                  height: 150,
                  width: 150,
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 40,
                  ),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          "User Name:",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.brown[800],
                          ),
                        ),
                        Text(
                          fullName,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 25),
                    
                        Text(
                          "Country:",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.brown[800],
                          ),
                        ),
                        Text(
                          country,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 25),
                    
                        Text(
                          "Email:",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.brown[800],
                          ),
                        ),
                        Text(
                          email,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 25),
                    
                        Text(
                          "Phone:",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.brown[800],
                          ),
                        ),
                        Text(
                          phone,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 90),
                    
                        // Buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kOrangePrimary,
                                  foregroundColor: kMainWhite,
                                  minimumSize: const Size(double.infinity, 50),
                                ),
                                onPressed: _editProfile,
                                child: const Text(
                                  "Edit Profile",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                            const SizedBox(width: 18),
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: kBtnRed,
                                    width: 2.5,
                                  ),
                                  minimumSize: const Size(double.infinity, 50),
                                ),
                                onPressed: () => _confirmLogout(context),
                    
                                child: const Text(
                                  "Logout",
                                  style: TextStyle(color: kBtnRed, fontSize: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const Footer(selectedIndex: 4),
    );
  }

  // Navigate to EditProfilePage and reload
  Future<void> _editProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditProfilePage()),
    );
    _loadProfile();
  }

  // Logout confirmation
  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx); // close dialog
              _logout(context);
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  // Logout
  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const OnboardPage()),
    );
  }
}
