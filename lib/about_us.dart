import 'package:flutter/material.dart';
import 'package:lanka_go/constance/colors.dart';
import 'package:lanka_go/widgets/custom_appbar.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "About Us"),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kMainWhite, kBrownLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              // App Logo
              Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(66, 161, 82, 82),
                        blurRadius: 4,
                        offset: const Offset(2, 2),
                      ),
                    ],
                    image: const DecorationImage(
                      image: AssetImage('assets/Logo.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // App Name
              const Center(
                child: Text(
                  "Lanka Go",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: kBrownDark,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              const Center(
                child: Text(
                  "Version 1.0.0",
                  style: TextStyle(color: kBrownLight),
                ),
              ),

              const SizedBox(height: 30),

              // Description
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                    255,
                    210,
                    206,
                    135,
                  ).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      "About the App",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Lanka Go is a smart travel and lifestyle application designed to help users explore Sri Lanka easily. It provides information about locations, services, and useful tools to enhance your daily experience.",
                      style: TextStyle(fontSize: 15, height: 1.5),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),
              // Mission
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                    255,
                    210,
                    183,
                    135,
                  ).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      "Our Mission",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Our mission is to make navigation, discovery, and everyday tasks simpler through a clean and user-friendly mobile experience.",
                      style: TextStyle(fontSize: 15, height: 1.5),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Team
              Column(
                children: [
                  const Text(
                    " Founder",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: kOrangeDark,
                    ),
                  ),

                  Center(
                    child: Container(
                      width: 140,
                      height: 140,
                      padding: const EdgeInsets.all(3), // border thickness
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: kOrangePrimary, // border color
                          width: 3,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          "assets/Dineth.jpeg",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),

                  const Text(
                    " Dineth Nupehewa",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              const SizedBox(height: 25),

              // Contact
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                    255,
                    135,
                    210,
                    143,
                  ).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Center(
                  child: Column(
                    children: [
                      const Text(
                        "Contact Us",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      Row(
                        children: const [
                          Icon(Icons.email, size: 20),
                          SizedBox(width: 10),
                          Text("support@lankago.com"),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: const [
                          Icon(Icons.phone, size: 20),
                          SizedBox(width: 10),
                          Text("+94 77 123 4567"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Footer
              const Center(
                child: Text(
                  "© 2026 Lanka Go. All rights reserved.",
                  style: TextStyle(color: kBrownDark),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
