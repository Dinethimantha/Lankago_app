import 'package:flutter/material.dart';

class NotificationSettingPage extends StatefulWidget {
  const NotificationSettingPage({super.key});

  @override
  State<NotificationSettingPage> createState() =>
      _NotificationSettingPageState();
}

class _NotificationSettingPageState extends State<NotificationSettingPage> {
  bool _muteNotifications = false;
  bool _emailAlerts = true;
  bool _pushAlerts = true;

  // Example error messages
  final List<String> _errors = [
    '⚠️ Cannot enable Push Notifications: Permission denied.',
    '⚠️ Email Alerts not sent: Invalid email.',
    '⚠️ Network error: Unable to update settings.',
    '⚠️ Notifications service temporarily unavailable.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        iconTheme: const IconThemeData(color: Colors.brown),
        title: const Text(
          'Notification Settings',
          style: TextStyle(
            color: Colors.brown,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
        centerTitle: true,
        elevation: 6,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Manage Notifications',
              style: TextStyle(
                color: Colors.brown,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),

            // 🔶 Show Errors
            Column(
              children: _errors
                  .map(
                    (e) => Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange[700]!),
                      ),
                      child: Text(
                        e,
                        style: const TextStyle(
                          color: Colors.brown,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 10),

            // 🔕 Mute Notifications
            _notificationTile(
              icon: Icons.notifications_off_rounded,
              title: 'Mute Notifications',
              subtitle: 'Turn off all notifications',
              value: _muteNotifications,
              onChanged: (val) {
                setState(() {
                  _muteNotifications = val!;
                  if (val) {
                    _emailAlerts = false;
                    _pushAlerts = false;
                  }
                });
              },
            ),

            const SizedBox(height: 10),

            // 📧 Email Alerts
            _notificationTile(
              icon: Icons.email_rounded,
              title: 'Email Alerts',
              subtitle: 'Receive notifications via email',
              value: _emailAlerts,
              onChanged: _muteNotifications
                  ? null
                  : (val) {
                      setState(() => _emailAlerts = val!);
                    },
            ),

            const SizedBox(height: 10),

            // 📲 Push Alerts
            _notificationTile(
              icon: Icons.notifications_active_rounded,
              title: 'Push Notifications',
              subtitle: 'Receive notifications on your device',
              value: _pushAlerts,
              onChanged: _muteNotifications
                  ? null
                  : (val) {
                      setState(() => _pushAlerts = val!);
                    },
            ),

            const Spacer(),

            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[700],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                label: const Text(
                  'Back',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _notificationTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool?>? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber[600]!, Colors.orange[400]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.4),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        value: value,
        onChanged: onChanged,
        activeThumbColor: Colors.white,
        inactiveThumbColor: Colors.white,
        inactiveTrackColor: Colors.white54,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
        secondary: Icon(icon, color: Colors.white, size: 26),
      ),
    );
  }
}
