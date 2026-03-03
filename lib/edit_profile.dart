import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lanka_go/constance/colors.dart';
import 'package:lanka_go/widgets/custom_appbar.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _countryController = TextEditingController();

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Load current data
    _loadProfile(); 
  }

  void _loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {

      // Fill email from logged-in user
      _emailController.text = user.email ?? "";

      final uid = user.uid;
      final doc = await FirebaseFirestore.instance.collection('userprofile').doc(uid).get();

      if (doc.exists) {
        _nameController.text = doc['fullName'] ?? "";
        _phoneController.text = doc['phone'] ?? "";
        _countryController.text = doc['country'] ?? "";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: CustomAppBar(title: "Edit Profile"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            
            children: [
              const SizedBox(height: 50),

              //Profile Icon 
              const CircleAvatar(
                radius: 55,
                backgroundColor: kBrownLight,
                child: Icon(
                  FontAwesomeIcons.userEdit,
                  size: 55,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 50),

              _buildField(_nameController, "Full Name", Icons.person),
              _buildField(_emailController, "Email", Icons.email, enabled: false), // read-only
              _buildField(_phoneController, "Mobile Number", Icons.phone),
              _buildField(_countryController, "Country", Icons.public),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kBrownDark,
                    foregroundColor: kMainWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Save Profile",
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //  Reusable Text Field
  Widget _buildField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.yellow[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) => (value == null || value.isEmpty) && enabled ? "Enter $hint" : null,
      ),
    );
  }

  // Save profile to Firebase
  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final uid = user.uid;

        await FirebaseFirestore.instance.collection('userprofile').doc(uid).set({
          'fullName': _nameController.text,
          'email': _emailController.text, 
          'phone': _phoneController.text,
          'country': _countryController.text,
        });

        setState(() => _isSaving = false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile saved successfully!")),
        );

        // Return to ProfilePage

        Navigator.pop(context); 
      }
    }
  }
}
