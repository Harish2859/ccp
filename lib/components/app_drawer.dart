import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- UI Style Constants (assumed from the previous enhancement) ---
class AppStyles {
  // Colors
  static const Color primaryColor = Color(0xFF0077B6);
  static const Color accentColor = Color(0xFF00B4D8);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color cardColor = Colors.white;
  static const Color primaryTextColor = Color(0xFF212529);
  static const Color secondaryTextColor = Color(0xFF6C757D);
  static const Color errorColor = Color(0xFFDC2626);

  // Spacing & Radius
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double radius = 16.0;

  // Typography
  static final TextStyle baseTextStyle = GoogleFonts.poppins();
}
// ---------------------------------------------


class AppDrawer extends StatelessWidget {
  // User profile information
  final String userName;
  final String userState;
  final String userEmail;
  final String? userAvatarUrl;

  // Callbacks for menu items
  final VoidCallback? onSettingsTap;
  final VoidCallback? onMyReportsTap;
  final VoidCallback? onSendAlertTap;
  final VoidCallback? onSavedTap; // New callback for Saved
  final VoidCallback? onLogoutTap;

  const AppDrawer({
    Key? key,
    required this.userName,
    required this.userState,
    required this.userEmail,
    this.userAvatarUrl,
    this.onSettingsTap,
    this.onMyReportsTap,
    this.onSendAlertTap,
    this.onSavedTap,
    this.onLogoutTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDrawerHeader(context),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.assignment_outlined,
                  text: 'My Reports',
                  onTap: onMyReportsTap ?? () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  icon: Icons.bookmark_border_outlined, // Icon for Saved
                  text: 'Saved Posts',
                  onTap: onSavedTap ?? () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  icon: Icons.campaign_outlined,
                  text: 'Send Alert',
                  onTap: onSendAlertTap ?? () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  icon: Icons.settings_outlined,
                  text: 'Settings',
                  onTap: onSettingsTap ?? () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          // Pinned to the bottom
          const Divider(height: 1),
          _buildDrawerItem(
            icon: Icons.logout,
            text: 'Logout',
            color: AppStyles.errorColor,
            onTap: onLogoutTap ?? () => Navigator.pop(context),
          ),
          const SizedBox(height: AppStyles.paddingMedium), // Bottom padding
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return Container(
      color: AppStyles.primaryColor,
      padding: EdgeInsets.fromLTRB(
        AppStyles.paddingMedium,
        AppStyles.paddingMedium + MediaQuery.of(context).padding.top, // Respect status bar
        AppStyles.paddingMedium,
        AppStyles.paddingMedium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            backgroundImage: (userAvatarUrl != null ? NetworkImage(userAvatarUrl!) : null) as ImageProvider?,
            child: userAvatarUrl == null
                ? Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                    style: AppStyles.baseTextStyle.copyWith(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: AppStyles.primaryColor,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: AppStyles.paddingMedium),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                userName,
                style: AppStyles.baseTextStyle.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: AppStyles.paddingSmall),
              // State Chip/Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppStyles.accentColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  userState,
                  style: AppStyles.baseTextStyle.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            userEmail,
            style: AppStyles.baseTextStyle.copyWith(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required GestureTapCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppStyles.secondaryTextColor),
      title: Text(
        text,
        style: AppStyles.baseTextStyle.copyWith(
          fontWeight: FontWeight.w500,
          color: color ?? AppStyles.primaryTextColor,
        ),
      ),
      onTap: onTap,
    );
  }
}