import 'package:flutter/material.dart';
import '../components/index.dart';
import '../services/feed_service.dart';
import 'notifications_page.dart';
import 'report_page.dart';
import 'hazard_map_page.dart';
import 'my_reports_page.dart';
import 'social_trends_page.dart';
import 'profile_page.dart';
import 'comments_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _currentNavIndex = 0;
  late AnimationController _likeAnimationController;
  
  // Sample climate posts data
  final List<Map<String, dynamic>> climatePosts = [
    {
      'id': 1,
      'username': 'INCOIS Official',
      'userAvatar': 'I',
      'timeAgo': '2 hours ago',
      'imagePath': 'assets/images/image 1.jpg',
      'title': 'High Waves Alert - Kerala Coast',
      'description': 'Wave heights of 2.5-3.5m expected along Kerala coast. Fishermen advised to avoid venturing into the sea.',
      'location': 'Kerala, India',
      'likes': 245,
      'comments': 18,
      'shares': 32,
      'isLiked': false,
      'isSaved': false,
      'alertType': 'warning',
      'commentsList': [
        {'username': 'fisherman_kerala', 'text': 'Thank you for the update! Staying safe.', 'time': '1h'},
        {'username': 'coastal_guard', 'text': 'All boats have been alerted. Safety first!', 'time': '45m'}
      ]
    },
    {
      'id': 2,
      'username': 'Weather India',
      'userAvatar': 'W',
      'timeAgo': '4 hours ago',
      'imagePath': 'assets/images/image 2.jpg',
      'title': 'Cyclone Update - Bay of Bengal',
      'description': 'Low pressure area in Bay of Bengal likely to intensify. Coastal areas of Andhra Pradesh and Odisha on alert.',
      'location': 'Bay of Bengal',
      'likes': 892,
      'comments': 67,
      'shares': 156,
      'isLiked': true,
      'isSaved': true,
      'alertType': 'critical',
      'commentsList': [
        {'username': 'odisha_resident', 'text': 'We are prepared. Thanks for the early warning!', 'time': '2h'},
        {'username': 'emergency_ap', 'text': 'Evacuation procedures activated in vulnerable areas.', 'time': '1h'}
      ]
    },
    {
      'id': 3,
      'username': 'Coast Guard India',
      'userAvatar': 'C',
      'timeAgo': '6 hours ago',
      'imagePath': 'assets/images/image 3.jpg',
      'title': 'All Clear - Mumbai Coast',
      'description': 'Weather conditions normal along Mumbai coastline. Safe for maritime activities with usual precautions.',
      'location': 'Mumbai, Maharashtra',
      'likes': 156,
      'comments': 23,
      'shares': 12,
      'isLiked': false,
      'isSaved': false,
      'alertType': 'safe',
      'commentsList': [
        {'username': 'mumbai_sailor', 'text': 'Great news! Perfect weather for sailing today.', 'time': '3h'},
        {'username': 'fishing_crew', 'text': 'Setting out for the day. Thank you!', 'time': '2h'}
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _likeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _likeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Combine static posts with dynamic alerts from FeedService
    final allPosts = [...FeedService.getAll(), ...climatePosts];
    
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
            MaterialPageRoute(builder: (context) => const HazardMapPage(isOfficial: false)),
          );
        } else if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SocialTrendsPage()),
          );
        } else if (index == 4) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfilePage()),
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
      onMyReportsTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyReportsPage()),
        );
      },
      body: Container(
        color: const Color(0xFFFFFFFF),
        child: ListView.builder(
          padding: const EdgeInsets.all(0),
          itemCount: allPosts.length,
          itemBuilder: (context, index) {
            return _buildInstagramPost(allPosts[index]);
          },
        ),
      ),
    );
  }

  Widget _buildInstagramPost(Map<String, dynamic> post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post header (Instagram style)
          _buildInstagramPostHeader(post),
          
          // Image with alert overlay
          _buildInstagramImageSection(post),
          
          // Action buttons (Instagram style)
          _buildInstagramActionBar(post),
          
          // Likes count
          _buildLikesSection(post),
          
          // Caption
          _buildCaptionSection(post),
          
          // Comments preview
          _buildCommentsPreview(post),
          
          // Time posted
          _buildTimeSection(post),
        ],
      ),
    );
  }

  Widget _buildInstagramPostHeader(Map<String, dynamic> post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Profile picture
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFF0096C7),
            child: Text(
              post['userAvatar'] ?? post['username'][0],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Username and location
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post['username'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                if (post['location'] != null) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 12,
                        color: Color(0xFF8E8E93),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        post['location'],
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF8E8E93),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          // More options
          IconButton(
            onPressed: () => _showMoreOptions(post),
            icon: const Icon(
              Icons.more_horiz,
              color: Colors.black,
              size: 24,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildInstagramImageSection(Map<String, dynamic> post) {
    return Stack(
      children: [
        // Main image
        AspectRatio(
          aspectRatio: 1.0, // Square aspect ratio like Instagram
          child: Container(
            width: double.infinity,
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
                      color: Color(0xFF8E8E93),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        // Alert badge (top-left)
        Positioned(
          top: 12,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: _getAlertColor(post['alertType']),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _getAlertEmoji(post['alertType']),
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(width: 4),
                Text(
                  post['alertType'].toString().toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInstagramActionBar(Map<String, dynamic> post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Like button
          GestureDetector(
            onTap: () => _toggleLike(post),
            child: AnimatedBuilder(
              animation: _likeAnimationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + (_likeAnimationController.value * 0.2),
                  child: Icon(
                    post['isLiked'] ? Icons.favorite : Icons.favorite_border,
                    color: post['isLiked'] ? Colors.red : Colors.black,
                    size: 28,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          // Comment button
          GestureDetector(
            onTap: () => _openComments(post),
            child: const Icon(
              Icons.chat_bubble_outline,
              color: Colors.black,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          // Share button
          GestureDetector(
            onTap: () => _sharePost(post),
            child: Transform.rotate(
              angle: -0.3, // Slight rotation like Instagram
              child: const Icon(
                Icons.send,
                color: Colors.black,
                size: 28,
              ),
            ),
          ),
          const Spacer(),
          // Bookmark button
          GestureDetector(
            onTap: () => _toggleSave(post),
            child: Icon(
              post['isSaved'] ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.black,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLikesSection(Map<String, dynamic> post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Text(
        '${post['likes']} likes',
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildCaptionSection(Map<String, dynamic> post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
            height: 1.3,
          ),
          children: [
            TextSpan(
              text: post['username'],
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const TextSpan(text: ' '),
            TextSpan(
              text: post['description'],
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentsPreview(Map<String, dynamic> post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // View all comments button
          GestureDetector(
            onTap: () => _openComments(post),
            child: Text(
              'View all ${post['comments']} comments',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF8E8E93),
              ),
            ),
          ),
          // Show latest comment if exists
          if (post['commentsList'] != null && post['commentsList'].isNotEmpty) ...[
            const SizedBox(height: 4),
            ...post['commentsList'].take(1).map<Widget>((comment) => 
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: comment['username'],
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const TextSpan(text: ' '),
                    TextSpan(
                      text: comment['text'],
                      style: const TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              )
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeSection(Map<String, dynamic> post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Text(
        post['timeAgo'].toString().toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFF8E8E93),
          fontWeight: FontWeight.w400,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Color _getAlertColor(String alertType) {
    switch (alertType) {
      case 'critical':
        return const Color(0xFFDC2626); // Red
      case 'warning':
        return const Color(0xFFF59E0B); // Orange
      case 'safe':
        return const Color(0xFF059669); // Green
      default:
        return const Color(0xFF3B82F6); // Blue
    }
  }

  String _getAlertEmoji(String alertType) {
    switch (alertType) {
      case 'critical':
        return '🚨';
      case 'warning':
        return '⚠️';
      case 'safe':
        return '✅';
      default:
        return 'ℹ️';
    }
  }

  void _toggleLike(Map<String, dynamic> post) {
    setState(() {
      post['isLiked'] = !post['isLiked'];
      post['likes'] += post['isLiked'] ? 1 : -1;
    });
    
    // Trigger like animation
    _likeAnimationController.forward().then((_) {
      _likeAnimationController.reverse();
    });
  }

  void _toggleSave(Map<String, dynamic> post) {
    setState(() {
      post['isSaved'] = !post['isSaved'];
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          post['isSaved'] ? 'Post saved!' : 'Post removed from saved',
        ),
        backgroundColor: const Color(0xFF2EC4B6),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openComments(Map<String, dynamic> post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommentsPage(
          post: post,
          onCommentAdded: (updatedPost) {
            setState(() {
              // Update the post in the list
              final index = climatePosts.indexWhere((p) => p['id'] == updatedPost['id']);
              if (index != -1) {
                climatePosts[index] = updatedPost;
              }
            });
          },
        ),
      ),
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.bookmark_border),
                title: Text(post['isSaved'] ? 'Remove from saved' : 'Save Post'),
                onTap: () {
                  Navigator.pop(context);
                  _toggleSave(post);
                },
              ),
              ListTile(
                leading: const Icon(Icons.link),
                title: const Text('Copy Link'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Link copied to clipboard!')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.flag_outlined, color: Colors.red),
                title: const Text('Report', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Post reported!')),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}