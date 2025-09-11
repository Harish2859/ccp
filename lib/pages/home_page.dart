import 'package:flutter/material.dart';
import '../components/index.dart';
import 'notifications_page.dart';
import 'report_page.dart';
import 'hazard_map_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentNavIndex = 0;

  // Sample climate posts data
  final List<Map<String, dynamic>> climatePosts = [
    {
      'id': 1,
      'username': 'INCOIS Official',
      'userAvatar': 'avatar1',
      'timeAgo': '2 hours ago',
      'imagePath': 'assets/images/image 1.jpg',
      'title': 'High Waves Alert - Kerala Coast',
      'description': 'Wave heights of 2.5-3.5m expected along Kerala coast. Fishermen advised to avoid venturing into the sea.',
      'location': 'Kerala, India',
      'likes': 245,
      'comments': 18,
      'shares': 32,
      'isLiked': false,
      'alertType': 'warning',
    },
    {
      'id': 2,
      'username': 'Weather India',
      'userAvatar': 'avatar2',
      'timeAgo': '4 hours ago',
      'imagePath': 'assets/images/image 2.jpg',
      'title': 'Cyclone Update - Bay of Bengal',
      'description': 'Low pressure area in Bay of Bengal likely to intensify. Coastal areas of Andhra Pradesh and Odisha on alert.',
      'location': 'Bay of Bengal',
      'likes': 892,
      'comments': 67,
      'shares': 156,
      'isLiked': true,
      'alertType': 'critical',
    },
    {
      'id': 3,
      'username': 'Coast Guard India',
      'userAvatar': 'avatar3',
      'timeAgo': '6 hours ago',
      'imagePath': 'assets/images/image 3.jpg',
      'title': 'All Clear - Mumbai Coast',
      'description': 'Weather conditions normal along Mumbai coastline. Safe for maritime activities with usual precautions.',
      'location': 'Mumbai, Maharashtra',
      'likes': 156,
      'comments': 23,
      'shares': 12,
      'isLiked': false,
      'alertType': 'safe',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Home',
      currentNavIndex: _currentNavIndex,
      userRole: UserRole.citizen,
      onNavTap: (index) {
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ReportPage()),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HazardMapPage()),
          );
        } else {
          setState(() {
            _currentNavIndex = index;
          });
        }
      },
      onNotificationTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NotificationsPage()),
        );
      },
      body: Container(
        color: const Color(0xFFFFFFFF),
        child: ListView.builder(
          padding: const EdgeInsets.all(0),
          itemCount: climatePosts.length,
          itemBuilder: (context, index) {
            return _buildClimatePost(climatePosts[index]);
          },
        ),
      ),
    );
  }

  Widget _buildClimatePost(Map<String, dynamic> post) {
    Color alertColor = _getAlertColor(post['alertType']);
    IconData alertIcon = _getAlertIcon(post['alertType']);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFFF8F9FA),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post header
          _buildPostHeader(post),
          
          // Image placeholder with climate info
          _buildImageSection(post, alertColor, alertIcon),
          
          // Action buttons (like, comment, share)
          _buildActionButtons(post),
          
          // Post content
          _buildPostContent(post),
        ],
      ),
    );
  }

  Widget _buildPostHeader(Map<String, dynamic> post) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // User avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFF0096C7),
            child: Text(
              post['username'][0],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Username and time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post['username'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF03045E),
                    fontSize: 16,
                  ),
                ),
                Text(
                  post['timeAgo'],
                  style: const TextStyle(
                    color: Color(0xFF495057),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // More options
          IconButton(
            onPressed: () => _showMoreOptions(post),
            icon: const Icon(
              Icons.more_vert,
              color: Color(0xFF495057),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(Map<String, dynamic> post, Color alertColor, IconData alertIcon) {
    return Stack(
      children: [
        // Actual image
        Container(
          width: double.infinity,
          height: 300,
          child: Image.asset(
            post['imagePath'],
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: const Color(0xFFF8F9FA),
                child: const Center(
                  child: Icon(
                    Icons.image,
                    size: 80,
                    color: Color(0xFF495057),
                  ),
                ),
              );
            },
          ),
        ),
        // Alert badge
        Positioned(
          top: 12,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: alertColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  alertIcon,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  post['alertType'].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Location badge
        Positioned(
          bottom: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 12,
                ),
                const SizedBox(width: 2),
                Text(
                  post['location'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Like button
          GestureDetector(
            onTap: () => _toggleLike(post),
            child: Row(
              children: [
                Icon(
                  post['isLiked'] ? Icons.favorite : Icons.favorite_border,
                  color: post['isLiked'] ? Colors.red : const Color(0xFF495057),
                  size: 24,
                ),
                const SizedBox(width: 4),
                Text(
                  '${post['likes']}',
                  style: const TextStyle(
                    color: Color(0xFF495057),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          // Comment button
          GestureDetector(
            onTap: () => _showComments(post),
            child: Row(
              children: [
                const Icon(
                  Icons.chat_bubble_outline,
                  color: Color(0xFF495057),
                  size: 24,
                ),
                const SizedBox(width: 4),
                Text(
                  '${post['comments']}',
                  style: const TextStyle(
                    color: Color(0xFF495057),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          // Share button
          GestureDetector(
            onTap: () => _sharePost(post),
            child: Row(
              children: [
                const Icon(
                  Icons.share_outlined,
                  color: Color(0xFF495057),
                  size: 24,
                ),
                const SizedBox(width: 4),
                Text(
                  '${post['shares']}',
                  style: const TextStyle(
                    color: Color(0xFF495057),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostContent(Map<String, dynamic> post) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            post['title'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF03045E),
            ),
          ),
          const SizedBox(height: 8),
          // Description
          Text(
            post['description'],
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF495057),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Color _getAlertColor(String alertType) {
    switch (alertType) {
      case 'critical':
        return const Color(0xFFD00000); // Red
      case 'warning':
        return const Color(0xFFFF6F61); // Coral Orange
      case 'safe':
        return const Color(0xFF52B788); // Lime Green
      default:
        return const Color(0xFF0096C7); // Aqua Blue
    }
  }

  IconData _getAlertIcon(String alertType) {
    switch (alertType) {
      case 'critical':
        return Icons.warning;
      case 'warning':
        return Icons.info;
      case 'safe':
        return Icons.check_circle;
      default:
        return Icons.info_outline;
    }
  }

  void _toggleLike(Map<String, dynamic> post) {
    setState(() {
      post['isLiked'] = !post['isLiked'];
      post['likes'] += post['isLiked'] ? 1 : -1;
    });
  }

  void _showComments(Map<String, dynamic> post) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Comments',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF03045E),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Comments feature coming soon...',
                style: TextStyle(
                  color: Color(0xFF495057),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF023E8A),
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _sharePost(Map<String, dynamic> post) {
    setState(() {
      post['shares'] += 1;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Post shared successfully!'),
        backgroundColor: Color(0xFF2EC4B6),
      ),
    );
  }

  void _showMoreOptions(Map<String, dynamic> post) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.bookmark_border),
                title: const Text('Save Post'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Post saved!')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.flag_outlined),
                title: const Text('Report'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Post reported!')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}