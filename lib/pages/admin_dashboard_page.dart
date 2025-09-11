import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../components/main_layout.dart';
import '../components/bottom_nav_bar.dart';
import 'reports_management_page.dart';

// Data Models
class DashboardStats {
  final int totalReportsToday;
  final int pendingValidations;
  final int highSeverityAlerts;
  final int activeAlerts;
  final double reportsPercentChange;
  final double validationsPercentChange;
  final double alertsPercentChange;

  DashboardStats({
    required this.totalReportsToday,
    required this.pendingValidations,
    required this.highSeverityAlerts,
    required this.activeAlerts,
    required this.reportsPercentChange,
    required this.validationsPercentChange,
    required this.alertsPercentChange,
  });
}

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

// Mock Data Provider
class DashboardDataProvider {
  static DashboardStats getMockStats() {
    return DashboardStats(
      totalReportsToday: 127,
      pendingValidations: 23,
      highSeverityAlerts: 5,
      activeAlerts: 12,
      reportsPercentChange: 15.2,
      validationsPercentChange: -8.1,
      alertsPercentChange: 45.7,
    );
  }

  static List<ActivityLog> getMockActivityLogs() {
    return [
      ActivityLog(
        action: "Report #156 validated (Oil Spill, Mumbai)",
        timestamp: "5 minutes ago",
        type: "validated",
        icon: Icons.check_circle,
        iconColor: const Color(0xFF2EC4B6),
      ),
      ActivityLog(
        action: "High Severity Alert issued (Cyclone, Odisha)",
        timestamp: "12 minutes ago",
        type: "alert",
        icon: Icons.warning,
        iconColor: const Color(0xFFFF6F61),
      ),
      ActivityLog(
        action: "8 new reports submitted in the last hour",
        timestamp: "25 minutes ago",
        type: "report",
        icon: Icons.assignment,
        iconColor: const Color(0xFF00B4D8),
      ),
      ActivityLog(
        action: "Marine life report verified (Dolphins, Goa)",
        timestamp: "1 hour ago",
        type: "validated",
        icon: Icons.check_circle,
        iconColor: const Color(0xFF2EC4B6),
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
}

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage>
    with TickerProviderStateMixin {
  late DashboardStats _stats;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  int _currentNavIndex = 0;

  // OceanPulse Color Palette
  static const Color deepBlue = Color(0xFF023E8A);
  static const Color aquaBlue = Color(0xFF0096C7);
  static const Color turquoise = Color(0xFF00B4D8);
  static const Color lightGray = Color(0xFFF8F9FA);
  static const Color darkNavy = Color(0xFF03045E);
  static const Color gray700 = Color(0xFF495057);
  static const Color coralOrange = Color(0xFFFF6F61);
  static const Color seaGreen = Color(0xFF2EC4B6);
  static const Color limeGreen = Color(0xFF52B788);

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadDashboardData() {
    _stats = DashboardDataProvider.getMockStats();
  }

  @override
  Widget build(BuildContext context) {
    final currentTime = DateFormat('MMM dd, yyyy • hh:mm a').format(DateTime.now());
    
    return MainLayout(
      title: 'Admin Dashboard',
      currentNavIndex: _currentNavIndex,
      userRole: UserRole.official,
      onNavTap: (index) {
        setState(() {
          _currentNavIndex = index;
        });
      },
      onNotificationTap: () => _showNotifications(),
      body: Container(
        color: lightGray,
        child: RefreshIndicator(
          onRefresh: () async => _refreshDashboard(),
          color: turquoise,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                _buildWelcomeSection(currentTime),
                const SizedBox(height: 20),
                
                // Overview Cards Grid
                _buildOverviewCardsGrid(),
                const SizedBox(height: 24),
                
                // Quick Access Shortcuts
                _buildQuickAccessSection(),
                const SizedBox(height: 24),
                
                // Bottom CTA
                _buildSendAlertCTA(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(String currentTime) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [deepBlue.withOpacity(0.1), turquoise.withOpacity(0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.waves, color: turquoise, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome back, Admin!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: darkNavy,
                  ),
                ),
                Text(
                  currentTime,
                  style: const TextStyle(
                    color: gray700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCardsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildOverviewCard(
          title: 'Total Reports Today',
          count: _stats.totalReportsToday.toString(),
          icon: Icons.assessment,
          backgroundColor: turquoise.withOpacity(0.1),
          iconColor: turquoise,
          percentChange: _stats.reportsPercentChange,
          onTap: () => _navigateToReportsManagement(),
        ),
        _buildOverviewCard(
          title: 'Pending Validations',
          count: _stats.pendingValidations.toString(),
          icon: Icons.hourglass_empty,
          backgroundColor: Colors.orange.withOpacity(0.1),
          iconColor: Colors.orange,
          percentChange: _stats.validationsPercentChange,
          onTap: () => _navigateToPendingValidations(),
        ),
        _buildOverviewCard(
          title: 'High Severity Alerts',
          count: _stats.highSeverityAlerts.toString(),
          icon: Icons.warning,
          backgroundColor: coralOrange.withOpacity(0.1),
          iconColor: coralOrange,
          percentChange: _stats.alertsPercentChange,
          onTap: () => _navigateToHighSeverityAlerts(),
        ),
        _buildOverviewCard(
          title: 'Active Alerts Sent',
          count: _stats.activeAlerts.toString(),
          icon: Icons.campaign,
          backgroundColor: seaGreen.withOpacity(0.1),
          iconColor: seaGreen,
          percentChange: 12.3,
          onTap: () => _navigateToActiveAlerts(),
        ),
      ],
    );
  }

  Widget _buildOverviewCard({
    required String title,
    required String count,
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
    required double percentChange,
    required VoidCallback onTap,
  }) {
    final isPositive = percentChange >= 0;
    
    return GestureDetector(
      onTap: () {
        _animationController.forward().then((_) {
          _animationController.reverse();
          onTap();
        });
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: iconColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(icon, color: iconColor, size: 20),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isPositive ? seaGreen.withOpacity(0.2) : coralOrange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isPositive ? Icons.trending_up : Icons.trending_down,
                              size: 12,
                              color: isPositive ? seaGreen : coralOrange,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${percentChange.abs().toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isPositive ? seaGreen : coralOrange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    count,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: darkNavy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      color: gray700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAccessSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Access',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: darkNavy,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildQuickAccessButton(
              icon: Icons.map,
              label: 'Hazard Map',
              color: turquoise,
              onTap: () => Navigator.pushNamed(context, '/hazard_map'),
            ),
            _buildQuickAccessButton(
              icon: Icons.trending_up,
              label: 'Social Trends',
              color: seaGreen,
              onTap: () => Navigator.pushNamed(context, '/social_trends'),
            ),
            _buildQuickAccessButton(
              icon: Icons.assignment,
              label: 'Citizen Reports',
              color: aquaBlue,
              onTap: () => Navigator.pushNamed(context, '/reports_management'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAccessButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: gray700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }



  Widget _buildSendAlertCTA() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => Navigator.pushNamed(context, '/alerts'),
        icon: const Icon(Icons.campaign, color: Colors.white),
        label: const Text(
          'Send New Alert 🚨',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: coralOrange,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
      ),
    );
  }

  // Navigation Methods
  void _navigateToReportsManagement() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ReportsManagementPage()),
    );
  }

  void _navigateToPendingValidations() {
    Navigator.pushNamed(context, '/pending_validations');
  }

  void _navigateToHighSeverityAlerts() {
    Navigator.pushNamed(context, '/high_severity_alerts');
  }

  void _navigateToActiveAlerts() {
    Navigator.pushNamed(context, '/active_alerts');
  }



  // Utility Methods
  void _refreshDashboard() {
    setState(() {
      _loadDashboardData();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dashboard refreshed'),
        backgroundColor: seaGreen,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications'),
        content: const Text('You have 3 new notifications:\n\n• New high-priority report\n• System maintenance scheduled\n• Weekly report ready'),
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