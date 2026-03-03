import 'package:flutter/material.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        iconTheme: const IconThemeData(color: Colors.brown),
        title: const Text(
          'Admin Panel',
          style: TextStyle(
            color: Colors.brown,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
        centerTitle: true,
        elevation: 6,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 12),
            _adminCard(
              icon: Icons.person,
              title: 'Manage Users',
              subtitle: 'View, add or remove users',
              onTap: () {
                // Navigate to Manage Users Page
              },
            ),
            _adminCard(
              icon: Icons.list_alt_rounded,
              title: 'Manage Trips',
              subtitle: 'Add or edit trips and itineraries',
              onTap: () {
                // Navigate to Manage Trips Page
              },
            ),
            _adminCard(
              icon: Icons.bookmark,
              title: 'Manage Bookings',
              subtitle: 'View and manage all bookings',
              onTap: () {
                // Navigate to Manage Bookings Page
              },
            ),
            _adminCard(
              icon: Icons.settings,
              title: 'System Settings',
              subtitle: 'Configure app preferences',
              onTap: () {
                // Navigate to Settings Page
              },
            ),
            _adminCard(
              icon: Icons.analytics,
              title: 'Reports & Analytics',
              subtitle: 'View app usage and stats',
              onTap: () {
                // Navigate to Reports Page
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _adminCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.yellow[600]!, Colors.orange[400]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: onTap,
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
