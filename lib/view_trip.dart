import 'package:flutter/material.dart';
import 'package:lanka_go/footer.dart';
import 'package:lanka_go/trips_page.dart';
import 'package:lanka_go/widgets/appbar_without_arrow.dart';
import 'package:lanka_go/widgets/custom_appbar.dart';
import 'package:lanka_go/constance/colors.dart';

class ViewTripPage extends StatelessWidget {
  const ViewTripPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWithoutArrow(title: "View Trip"),
      body: Column(
        children: [
          //image
          Image.asset(
            "assets/viewtrip.jpg",
            width: double.infinity,
            height: 600,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),

          //button
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kOrangeDark,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TripsPage()),
                );
              },
              child: const Text(
                "View Your Current Trip Plan",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const Footer(selectedIndex: 2),
    );
  }
}
