// custom_appbar.dart
import 'package:flutter/material.dart';
import 'package:lanka_go/constance/colors.dart';
import '../profile_page.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  const Appbar({super.key, this.height = 110});

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        gradient: LinearGradient(
          colors: [kBrownDark, kBrownLight, kBrownDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: kTextDarkGray.withOpacity(0.4),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                // Logo Image
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
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
                const SizedBox(width: 12),

                // Title
                const Expanded(
                  child: Row(
                    children: [
                      Text(
                        "Lanka GO",
                        style: TextStyle(
                          color: Color.fromARGB(255, 233, 226, 186),
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),

                // Profile Icon
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: kOrangePrimary.withOpacity(0.8),
                    boxShadow: [
                      BoxShadow(
                        color: kblack,
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfilePage()),
                      );
                    },
                    icon: const Icon(Icons.person, color: kMainWhite, size: 30),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
