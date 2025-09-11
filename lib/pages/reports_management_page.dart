import 'package:flutter/material.dart';
import '../components/main_layout.dart';
import '../components/bottom_nav_bar.dart';

class ActivityLog {
  final String action;
  final String timestamp;
  final String type;
  final IconData icon;
  final Color iconColor;

  ActivityLog({
    required this.action,
    required this.timestamp,
    required this.type,
    required this.icon,
    required this.iconColor,
  });
}

class ReportsManagementPage extends StatefulWidget {
  const ReportsManagementPage({super.key});

  @override
  State<ReportsManagementPage> createState() => _ReportsManagementPageState();
}

class _ReportsManagementPageState extends State<ReportsManagementPage> {
  int _currentNavIndex = 3; // Reports tab
  late List<ActivityLog> _activityLogs;

  // OceanPulse Color Palette
  static const Color deepBlue = Color(0xFF023E8A);
  static const Color aquaBlue = Color(0xFF0096C7);
  static const Color turquoise = Color(0xFF00B4D8);
  static const Color lightGray = Color(0xFFF8F9FA);
  static const Color darkNavy = Color(0xFF03045E);
  static const Color gray700 = Color(0xFF495057);
  static const Color coralOrange = Color(0xFFFF6F61);
  static const Color seaGreen = Color(0xFF2EC4B6);

  @override
  void initState() {
    super.initState();
    _loadActivityLogs();
  }

  void _loadActivityLogs() {
    _activityLogs = [
      ActivityLog(
        action: "Report #156 validated (Oil Spill, Mumbai)",
        timestamp: "5 minutes ago",
        type: "validated",
        icon: Icons.check_circle,
        iconColor: seaGreen,
      ),
      ActivityLog(
        action: "High Severity Alert issued (Cyclone, Odisha)",
        timestamp: "12 minutes ago",
        type: "alert",
        icon: Icons.warning,
        iconColor: coralOrange,
      ),
      ActivityLog(
        action: "8 new reports submitted in the last hour",
        timestamp: "25 minutes ago",
        type: "report",
        icon: Icons.assignment,
        iconColor: turquoise,
      ),
      ActivityLog(
        action: "Marine life report verified (Dolphins, Goa)",
        timestamp: "1 hour ago",
        type: "validated",
        icon: Icons.check_circle,
        iconColor: seaGreen,
      ),
      ActivityLog(
        action: "Water quality alert cleared (Chennai Coast)",
        timestamp: "2 hours ago",
        type: "cleared",
        icon: Icons.done_all,
        iconColor: const Color(0xFF52B788),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Reports Management',
      currentNavIndex: _currentNavIndex,
      userRole: UserRole.official,
      onNavTap: (index) {
        setState(() {
          _currentNavIndex = index;
        });
      },
      body: Container(
        color: lightGray,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRecentActivitySection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Activity',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: darkNavy,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _activityLogs.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final activity = _activityLogs[index];
              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: activity.iconColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(activity.icon, color: activity.iconColor, size: 16),
                ),
                title: Text(
                  activity.action,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: darkNavy,
                  ),
                ),
                subtitle: Text(
                  activity.timestamp,
                  style: const TextStyle(
                    fontSize: 12,
                    color: gray700,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: gray700),
                onTap: () => _viewActivityDetails(activity),
              );
            },
          ),
        ),
      ],
    );
  }

  void _viewActivityDetails(ActivityLog activity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Activity Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Action: ${activity.action}'),
            const SizedBox(height: 8),
            Text('Type: ${activity.type}'),
            const SizedBox(height: 8),
            Text('Time: ${activity.timestamp}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}