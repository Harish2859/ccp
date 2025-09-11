import 'package:flutter/material.dart';
import 'top_app_bar.dart';
import 'bottom_nav_bar.dart';
import 'app_drawer.dart';

class MainLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final int currentNavIndex;
  final UserRole userRole;
  final Function(int) onNavTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onMessageTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onDrawerSettingsTap;
  final VoidCallback? onMyReportsTap;
  final VoidCallback? onSendAlertTap;
  final VoidCallback? onLogoutTap;

  const MainLayout({
    Key? key,
    required this.title,
    required this.body,
    required this.currentNavIndex,
    required this.userRole,
    required this.onNavTap,
    this.onNotificationTap,
    this.onMessageTap,
    this.onSettingsTap,
    this.onDrawerSettingsTap,
    this.onMyReportsTap,
    this.onSendAlertTap,
    this.onLogoutTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(
        title: title,
        isAdmin: userRole == UserRole.official,
        onNotificationTap: onNotificationTap,
        onMessageTap: onMessageTap,
        onSettingsTap: onSettingsTap,
      ),
      drawer: AppDrawer(
        onSettingsTap: onDrawerSettingsTap,
        onMyReportsTap: onMyReportsTap,
        onSendAlertTap: onSendAlertTap,
        onLogoutTap: onLogoutTap,
      ),
      body: body,
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentNavIndex,
        userRole: userRole,
        onTap: onNavTap,
      ),
    );
  }
}