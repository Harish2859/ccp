import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final VoidCallback? onAboutTap;
  final VoidCallback? onHelpTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onMyReportsTap;
  final VoidCallback? onLogoutTap;

  const AppDrawer({
    Key? key,
    this.onAboutTap,
    this.onHelpTap,
    this.onSettingsTap,
    this.onMyReportsTap,
    this.onLogoutTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1E3A8A),
                  Color(0xFF0891B2),
                ],
              ),
            ),
            child: const SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'OceanPulse',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Protecting our oceans together',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.assignment_outlined),
                  title: const Text('My Reports'),
                  onTap: onMyReportsTap ?? () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('About'),
                  onTap: onAboutTap ?? () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('Help'),
                  onTap: onHelpTap ?? () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: const Text('Settings'),
                  onTap: onSettingsTap ?? () => Navigator.pop(context),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('Logout', style: TextStyle(color: Colors.red)),
                  onTap: onLogoutTap ?? () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}