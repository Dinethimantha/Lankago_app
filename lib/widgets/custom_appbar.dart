import 'package:flutter/material.dart';
import 'package:lanka_go/constance/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final LinearGradient backgroundGradient;
  final Color textColor;
  final bool showBackArrow;

  const CustomAppBar({
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
      elevation: 2,
      leading: showBackArrow
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: textColor),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          : null,
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
          .transparent, // Important! Otherwise gradient won't show on AppBar
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
