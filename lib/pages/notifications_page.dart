import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  String selectedFilter = 'All';
  
  // Sample notifications data
  final List<Map<String, dynamic>> notifications = [
    {
      'id': 1,
      'type': 'disaster_report',
      'title': 'New Disaster Report',
      'message': 'High waves reported near Kochi Beach by user @fisherman_raj',
      'location': 'Kochi, Kerala',
      'severity': 'high',
      'timeAgo': '5 minutes ago',
      'isRead': false,
      'userData': {
        'username': 'fisherman_raj',
        'avatar': 'FR',
      },
    },
    {
      'id': 2,
      'type': 'map_update',
      'title': 'Hazard Zone Updated',
      'message': 'New hazard zone marked on map: Cyclone warning area expanded in Bay of Bengal',
      'location': 'Bay of Bengal',
      'severity': 'critical',
      'timeAgo': '12 minutes ago',
      'isRead': false,
      'userData': null,
    },
    {
      'id': 3,
      'type': 'official_alert',
      'title': 'INCOIS Alert',
      'message': 'Official tsunami warning issued for eastern coastline. Evacuate immediately.',
      'location': 'Tamil Nadu Coast',
      'severity': 'critical',
      'timeAgo': '25 minutes ago',
      'isRead': true,
      'userData': {
        'username': 'INCOIS_Official',
        'avatar': 'IO',
      },
    },
    {
      'id': 4,
      'type': 'community_update',
      'title': 'Community Report Verified',
      'message': 'Your flood report has been verified and added to the official database',
      'location': 'Chennai, Tamil Nadu',
      'severity': 'medium',
      'timeAgo': '1 hour ago',
      'isRead': true,
      'userData': null,
    },
    {
      'id': 5,
      'type': 'disaster_report',
      'title': 'New Disaster Report',
      'message': 'Landslide blocking highway reported by @local_driver',
      'location': 'Munnar, Kerala',
      'severity': 'high',
      'timeAgo': '2 hours ago',
      'isRead': true,
      'userData': {
        'username': 'local_driver',
        'avatar': 'LD',
      },
    },
    {
      'id': 6,
      'type': 'weather_update',
      'title': 'Weather Alert',
      'message': 'Heavy rainfall expected in next 24 hours. Stay indoors and avoid travel.',
      'location': 'Mumbai, Maharashtra',
      'severity': 'medium',
      'timeAgo': '3 hours ago',
      'isRead': true,
      'userData': null,
    },
    {
      'id': 7,
      'type': 'map_update',
      'title': 'Safe Zone Added',
      'message': 'New evacuation center marked on map: Municipal School Ground',
      'location': 'Visakhapatnam, AP',
      'severity': 'safe',
      'timeAgo': '5 hours ago',
      'isRead': true,
      'userData': null,
    },
  ];

  List<String> filterOptions = ['All', 'Disaster Reports', 'Map Updates', 'Official Alerts', 'Weather'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildFilterTabs(),
          Expanded(
            child: _buildNotificationsList(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    int unreadCount = notifications.where((n) => !n['isRead']).length;
    
    return AppBar(
      backgroundColor: const Color(0xFF023E8A), // Deep Blue
      elevation: 0,
      title: Row(
        children: [
          const Text(
            'Notifications',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (unreadCount > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6F61), // Coral Orange
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$unreadCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.mark_email_read, color: Colors.white),
          onPressed: _markAllAsRead,
          tooltip: 'Mark all as read',
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: _showNotificationSettings,
          tooltip: 'Notification settings',
        ),
      ],
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filterOptions.length,
        itemBuilder: (context, index) {
          String filter = filterOptions[index];
          bool isSelected = selectedFilter == filter;
          
          return GestureDetector(
            onTap: () => setState(() => selectedFilter = filter),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF023E8A) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF023E8A),
                  width: 1,
                ),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF023E8A),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationsList() {
    List<Map<String, dynamic>> filteredNotifications = _getFilteredNotifications();
    
    if (filteredNotifications.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: filteredNotifications.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _buildNotificationCard(filteredNotifications[index]);
      },
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    Color severityColor = _getSeverityColor(notification['severity']);
    IconData typeIcon = _getTypeIcon(notification['type']);
    
    return GestureDetector(
      onTap: () => _handleNotificationTap(notification),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification['isRead'] ? Colors.white : const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: notification['isRead'] 
                ? const Color(0xFFF8F9FA)
                : severityColor.withOpacity(0.3),
            width: notification['isRead'] ? 1 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification icon with severity color
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: severityColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                typeIcon,
                color: severityColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            // Notification content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        notification['title'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF03045E),
                        ),
                      ),
                      if (!notification['isRead'])
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF0096C7),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification['message'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF495057),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: const Color(0xFF0096C7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            notification['location'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF0096C7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        notification['timeAgo'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF495057),
                        ),
                      ),
                    ],
                  ),
                  // User info for community reports
                  if (notification['userData'] != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: const Color(0xFF0096C7),
                          child: Text(
                            notification['userData']['avatar'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'by @${notification['userData']['username']}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF495057),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: const Color(0xFF495057).withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications found',
            style: TextStyle(
              fontSize: 18,
              color: const Color(0xFF495057).withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            selectedFilter == 'All' 
                ? 'You\'re all caught up!' 
                : 'No $selectedFilter notifications',
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xFF495057).withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredNotifications() {
    if (selectedFilter == 'All') return notifications;
    
    String filterType;
    switch (selectedFilter) {
      case 'Disaster Reports':
        filterType = 'disaster_report';
        break;
      case 'Map Updates':
        filterType = 'map_update';
        break;
      case 'Official Alerts':
        filterType = 'official_alert';
        break;
      case 'Weather':
        filterType = 'weather_update';
        break;
      default:
        return notifications;
    }
    
    return notifications.where((n) => n['type'] == filterType).toList();
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'critical':
        return const Color(0xFFD00000); // Red
      case 'high':
        return const Color(0xFFFF6F61); // Coral Orange
      case 'medium':
        return const Color(0xFF0096C7); // Aqua Blue
      case 'safe':
        return const Color(0xFF52B788); // Lime Green
      default:
        return const Color(0xFF495057); // Gray
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'disaster_report':
        return Icons.report_problem;
      case 'map_update':
        return Icons.map;
      case 'official_alert':
        return Icons.warning;
      case 'weather_update':
        return Icons.cloud;
      case 'community_update':
        return Icons.people;
      default:
        return Icons.notifications;
    }
  }

  void _handleNotificationTap(Map<String, dynamic> notification) {
    setState(() {
      notification['isRead'] = true;
    });

    // Handle different notification types
    switch (notification['type']) {
      case 'disaster_report':
        _showDisasterDetails(notification);
        break;
      case 'map_update':
        _navigateToMap(notification);
        break;
      case 'official_alert':
        _showAlertDetails(notification);
        break;
      default:
        _showNotificationDetails(notification);
    }
  }

  void _showDisasterDetails(Map<String, dynamic> notification) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Disaster Report Details',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF03045E),
              ),
            ),
            const SizedBox(height: 16),
            Text(notification['message']),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Navigate to map
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF023E8A),
                  ),
                  child: const Text('View on Map', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToMap(Map<String, dynamic> notification) {
    // Navigate to map page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening map...')),
    );
  }

  void _showAlertDetails(Map<String, dynamic> notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Official Alert'),
        content: Text(notification['message']),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showNotificationDetails(Map<String, dynamic> notification) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening ${notification['title']}...')),
    );
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification['isRead'] = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        backgroundColor: Color(0xFF2EC4B6),
      ),
    );
  }

  void _showNotificationSettings() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Notification Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('Disaster Reports'),
              value: true,
              onChanged: (value) {},
              activeColor: const Color(0xFF023E8A),
            ),
            SwitchListTile(
              title: const Text('Official Alerts'),
              value: true,
              onChanged: (value) {},
              activeColor: const Color(0xFF023E8A),
            ),
            SwitchListTile(
              title: const Text('Weather Updates'),
              value: true,
              onChanged: (value) {},
              activeColor: const Color(0xFF023E8A),
            ),
          ],
        ),
      ),
    );
  }
}