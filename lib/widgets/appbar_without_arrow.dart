import 'package:flutter/material.dart';
import 'package:lanka_go/constance/colors.dart';

class AppBarWithoutArrow extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final LinearGradient backgroundGradient;
  final Color textColor;
  final bool showBackArrow;

  const AppBarWithoutArrow({
    super.key,
    required this.title,
    this.backgroundGradient = const LinearGradient(
      colors: [kBrownDark, kBrownLight,kBrownDark],
    ),
    this.textColor = Colors.white,
    this.showBackArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
       automaticallyImplyLeading: false,
      elevation: 2,
      
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 23,
        ),
      ),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: backgroundGradient,
        ),
      ),
      backgroundColor: Colors
          .transparent
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
