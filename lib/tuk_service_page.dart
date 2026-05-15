import 'package:flutter/material.dart';
import 'package:lanka_go/constance/colors.dart';
import 'package:lanka_go/widgets/custom_appbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'footer.dart';

class TukServicePage extends StatelessWidget {
  const TukServicePage({super.key});

  // app connection card with URL launcher

  Future<void> _launchApp(
    BuildContext context, {
    required String appUrl,
    required String playStoreUrl,
    required String appStoreUrl,
  }) async {
    final Uri appUri = Uri.parse(appUrl);

    if (await canLaunchUrl(appUri)) {
      await launchUrl(appUri);
    } else {
      final Uri storeUri = Uri.parse(
        Theme.of(context).platform == TargetPlatform.iOS
            ? appStoreUrl
            : playStoreUrl,
      );

      await launchUrl(storeUri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradient = const LinearGradient(
      colors: [kMainWhite,kPrimaryYellowLight],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    return Scaffold(
      appBar: CustomAppBar(title: "Tuk Services"),
      body: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                

                const SizedBox(height: 30),

                //  PickMe
                _buildServiceCard(
                  context,
                  imagePath: "assets/pick_me_logo.png",
                  title: "PickMe Sri Lanka",
                  description:
                      "Book tuk rides instantly across Sri Lanka with PickMe — fast, affordable and trusted.",
                  buttonText: "Connect",
                  onPressed: () {
                    _launchApp(
                      context,
                      appUrl: "pickme://",
                      playStoreUrl:
                          "https://play.google.com/store/apps/details?id=com.pickme.passenger",
                      appStoreUrl:
                          "https://apps.apple.com/lk/app/pickme/id995536093",
                    );
                  },
                ),

                const SizedBox(height: 25),

                // Uber
                _buildServiceCard(
                  context,
                  imagePath: "assets/uber.png",
                  title: "Uber Sri Lanka",
                  description:
                      "Ride safely with Uber — available in Colombo and major cities for tuk and car rides.",
                  buttonText: "Connect",
                  onPressed: () {
                    _launchApp(
                      context,
                      appUrl: "uber://",
                      playStoreUrl:
                          "https://play.google.com/store/apps/details?id=com.ubercab",
                      appStoreUrl:
                          "https://apps.apple.com/lk/app/uber/id368677368",
                    );
                  },
                ),

                const SizedBox(height: 25),

                //  HelaGo
                _buildServiceCard(
                  context,
                  imagePath: "assets/helago.png",
                  title: "HelaGo",
                  description:
                      "HelaGo is a Sri Lankan ride-hailing service offering tuk and taxi services in selected cities.",
                  buttonText: "Connect",
                  onPressed: () {
                    _launchApp(
                      context,
                      appUrl: "helago://",
                      playStoreUrl:
                          "https://play.google.com/store/apps/details?id=lk.bhasha.helago.passenger",
                      appStoreUrl:
                          "https://apps.apple.com/lk/app/go-by-helago-passenger-rides/id6755774618",
                    );
                  },
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const Footer(selectedIndex: 0),
    );
  }

  // reusable card widget for each tuk service

  Widget _buildServiceCard(
    BuildContext context, {
    required String imagePath,
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: const Color.fromARGB(110, 121, 85, 72),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.brown.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // App Image
            Image.asset(
              imagePath,
              height: 100,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 16),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: kBtnPrimary,
                foregroundColor: kBrownLight,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              icon: const Icon(Icons.link),
              label: Text(
                buttonText,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //  Circle Button
  static Widget _circleButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.9),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          color: const Color.fromARGB(255, 121, 85, 72),
          size: 26,
        ),
      ),
    );
  }
}
