import 'package:flutter/material.dart';
import 'login_page.dart';
import '../models/official.dart';
import '../models/activity_log.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({Key? key}) : super(key: key);

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  bool isEditMode = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  
  final Official official = Official(
    id: '1',
    name: 'Dr. Rajesh Kumar',
    email: 'rajesh.kumar@incois.gov.in',
    role: 'INCOIS Official',
    profilePhoto: '',
    notificationPrefs: ['citizen_reports', 'critical_alerts'],
  );
  
  final List<ActivityLog> activities = [
    ActivityLog(
      id: '1',
      type: 'validated_report',
      description: 'Flood Report (Chennai)',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    ActivityLog(
      id: '2',
      type: 'sent_alert',
      description: 'Cyclone Warning - Odisha',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    ActivityLog(
      id: '3',
      type: 'false_report',
      description: 'Unusual Tide Report (Goa)',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    nameController.text = official.name;
    emailController.text = official.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF023E8A),
        elevation: 0,
        title: const Text(
          'My Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () => setState(() => isEditMode = !isEditMode),
            child: Text(
              isEditMode ? 'Save' : 'Edit',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildAccountSettings(),
            const SizedBox(height: 24),
            _buildActivityLog(),
            const SizedBox(height: 24),
            _buildQuickActions(context),
            const SizedBox(height: 24),
            _buildLogoutSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF0891B2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Text(
              official.name.split(' ').map((e) => e[0]).take(2).join(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A8A),
              ),
            ),
          ),
          const SizedBox(height: 16),
          isEditMode
              ? TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  ),
                )
              : Text(
                  official.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                official.role,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.verified, color: Colors.green, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          isEditMode
              ? TextField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.white70),
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  ),
                )
              : Text(
                  official.email,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildAccountSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account Settings',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildOptionTile(
          icon: Icons.lock_outline,
          title: 'Change Password',
          onTap: () => _showComingSoon(context),
        ),
        _buildOptionTile(
          icon: Icons.language,
          title: 'Change Language 🌐',
          onTap: () => _showLanguageDialog(context),
        ),
        _buildOptionTile(
          icon: Icons.notifications_outlined,
          title: 'Notification Preferences',
          onTap: () => _showNotificationPrefs(context),
        ),
      ],
    );
  }

  Widget _buildActivityLog() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Activity Log',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          height: 200,
          child: ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              return _buildActivityItem(activity);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(ActivityLog activity) {
    IconData icon;
    Color color;
    String prefix;
    
    switch (activity.type) {
      case 'validated_report':
        icon = Icons.check_circle;
        color = Colors.green;
        prefix = '✅ Validated Report';
        break;
      case 'sent_alert':
        icon = Icons.warning;
        color = Colors.orange;
        prefix = '🚨 Sent Alert';
        break;
      case 'false_report':
        icon = Icons.cancel;
        color = Colors.red;
        prefix = '❌ Marked False';
        break;
      default:
        icon = Icons.info;
        color = Colors.blue;
        prefix = 'Activity';
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$prefix — "${activity.description}"',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  '${activity.timestamp.hour}:${activity.timestamp.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showComingSoon(context),
                icon: const Icon(Icons.campaign),
                label: const Text('View My Alerts'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF023E8A),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showComingSoon(context),
                icon: const Icon(Icons.map),
                label: const Text('Validated Reports'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF023E8A),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLogoutSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _showLogoutDialog(context),
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? Colors.red : const Color(0xFF023E8A),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive ? Colors.red : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        tileColor: Colors.grey[50],
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feature coming soon...')),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('हिंदी (Hindi)'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('தமிழ் (Tamil)'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationPrefs(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notification Preferences'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: const Text('Citizen Reports'),
              value: official.notificationPrefs.contains('citizen_reports'),
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Social Trends'),
              value: official.notificationPrefs.contains('social_trends'),
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Critical Alerts'),
              value: official.notificationPrefs.contains('critical_alerts'),
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}