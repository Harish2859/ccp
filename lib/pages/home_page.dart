import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../components/index.dart'; // Assuming MainLayout, UserRole are here
import '../services/feed_service.dart';
import 'notifications_page.dart';
import 'report_page.dart';

import 'my_reports_page.dart';
import 'social_trends_page.dart';
import 'profile_page.dart';
import 'comments_page.dart';
import 'saved_posts_page.dart';

// --- UI Style Constants for a Modern Look ---
class AppStyles {
  // Colors
  static const Color primaryColor = Color(0xFF0077B6);
  static const Color accentColor = Color(0xFF00B4D8);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color cardColor = Colors.white;
  static const Color primaryTextColor = Color(0xFF212529);
  static const Color secondaryTextColor = Color(0xFF6C757D);
  static const Color errorColor = Color(0xFFDC2626);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color safeColor = Color(0xFF10B981);

  // Spacing & Radius
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double radius = 16.0;

  // Typography
  static final TextStyle baseTextStyle = GoogleFonts.poppins();

  static final TextStyle headingStyle = baseTextStyle.copyWith(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: primaryTextColor,
  );

  static final TextStyle bodyStyle = baseTextStyle.copyWith(
    fontWeight: FontWeight.normal,
    fontSize: 14,
    color: primaryTextColor,
    height: 1.4,
  );

  static final TextStyle subtitleStyle = baseTextStyle.copyWith(
    fontSize: 12,
    color: secondaryTextColor,
  );
}
// ---------------------------------------------


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _currentNavIndex = 0;
  late AnimationController _likeAnimationController;
  String _selectedFilter = 'All';
  String _selectedLanguage = 'English';
  final List<Map<String, dynamic>> _savedPosts = [];
  
  // Combine static and dynamic posts into a single list
  late List<Map<String, dynamic>> _allPosts;

  final List<String> _filterOptions = ['All', 'Critical 🚨', 'Warning ⚠️', 'Safe ✅'];
  final List<String> _languages = ['English', 'Hindi', 'Tamil', 'Telugu', 'Malayalam'];
  
  final List<Map<String, dynamic>> climatePosts = [
     {
      'id': 1,
      'username': 'INCOIS Official',
      'userAvatar': 'I',
      'isVerified': true,
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
      'isVerified': true,
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
      'isVerified': true,
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
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    // Initialize the combined list of posts
    _allPosts = [...FeedService.getAll(), ...climatePosts];
    // Populate saved posts initially
    _savedPosts.addAll(_allPosts.where((p) => p['isSaved'] == true));
  }

  @override
  void dispose() {
    _likeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredPosts = _filterPosts(_allPosts);
    
    return MainLayout(
      title: 'Home',
      currentNavIndex: _currentNavIndex,
      userRole: UserRole.citizen, // Example role
      onNavTap: _onNavTap,
      onNotificationTap: () => _navigateTo(const NotificationsPage()),
      onMyReportsTap: () => _navigateTo(const MyReportsPage()),
      onSavedTap: () => _navigateTo(SavedPostsPage(savedPosts: _savedPosts)),
      body: Container(
        color: AppStyles.backgroundColor,
        child: Column(
          children: [
            _buildFilterBar(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshFeed,
                color: AppStyles.primaryColor,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppStyles.paddingSmall, 
                    vertical: AppStyles.paddingMedium,
                  ),
                  itemCount: filteredPosts.length,
                  itemBuilder: (context, index) {
                    return _buildPostCard(filteredPosts[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _onNavTap(int index) {
    if (index == 0) {
      setState(() => _currentNavIndex = index);
      return;
    }
    
    Widget page;
    switch (index) {
      case 1:
        page = const ReportPage();
        break;
      case 2:
        page = const SocialTrendsPage();
        break;
      case 3:
        page = const ProfilePage();
        break;
      default:
        return;
    }
    
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => page),
      (route) => false,
    );
  }

  void _navigateTo(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    return Card(
      elevation: 4,
      shadowColor: AppStyles.primaryColor.withOpacity(0.1),
      margin: const EdgeInsets.only(bottom: AppStyles.paddingMedium),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppStyles.radius)),
      clipBehavior: Clip.antiAlias, // Ensures content respects the rounded corners
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPostHeader(post),
          _buildImageSection(post),
          _buildActionBar(post),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppStyles.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${post['likes']} likes', style: AppStyles.headingStyle.copyWith(fontSize: 14)),
                const SizedBox(height: AppStyles.paddingSmall),
                _buildCaptionSection(post),
                const SizedBox(height: AppStyles.paddingSmall),
                _buildCommentsPreview(post),
                const SizedBox(height: AppStyles.paddingSmall),
                Text(post['timeAgo'].toString().toUpperCase(), style: AppStyles.subtitleStyle.copyWith(fontSize: 10)),
                const SizedBox(height: AppStyles.paddingMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostHeader(Map<String, dynamic> post) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppStyles.paddingMedium, AppStyles.paddingMedium, AppStyles.paddingSmall, AppStyles.paddingMedium),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppStyles.primaryColor.withOpacity(0.8),
            child: Text(
              post['userAvatar'] ?? post['username'][0],
              style: AppStyles.baseTextStyle.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(post['username'], style: AppStyles.headingStyle),
                    if (post['isVerified'] == true) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.verified, size: 18, color: AppStyles.primaryColor),
                    ],
                  ],
                ),
                if (post['location'] != null) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: AppStyles.secondaryTextColor),
                      const SizedBox(width: 4),
                      Text(post['location'], style: AppStyles.subtitleStyle),
                    ],
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: () => _showMoreOptions(post),
            icon: const Icon(Icons.more_horiz, color: AppStyles.secondaryTextColor),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(Map<String, dynamic> post) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Image.asset(
        post['imagePath'],
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: AppStyles.backgroundColor,
            child: const Center(child: Icon(Icons.image_not_supported, size: 50, color: AppStyles.secondaryTextColor)),
          );
        },
      ),
    );
  }

  Widget _buildActionBar(Map<String, dynamic> post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppStyles.paddingSmall, vertical: AppStyles.paddingSmall / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ScaleTransition(
                scale: Tween(begin: 1.0, end: 1.2).animate(
                  CurvedAnimation(parent: _likeAnimationController, curve: Curves.elasticOut)
                ),
                child: IconButton(
                  onPressed: () => _toggleLike(post),
                  icon: Icon(
                    post['isLiked'] ? Icons.favorite : Icons.favorite_border,
                    color: post['isLiked'] ? AppStyles.errorColor : AppStyles.primaryTextColor,
                    size: 28,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _openComments(post),
                icon: const Icon(Icons.chat_bubble_outline, color: AppStyles.primaryTextColor, size: 28),
              ),
              IconButton(
                onPressed: () => _sharePost(post),
                icon: const Icon(Icons.send_outlined, color: AppStyles.primaryTextColor, size: 28),
              ),
            ],
          ),
          IconButton(
            onPressed: () => _toggleSave(post),
            icon: Icon(
              post['isSaved'] ? Icons.bookmark : Icons.bookmark_border,
              color: AppStyles.primaryTextColor,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCaptionSection(Map<String, dynamic> post) {
    return RichText(
      text: TextSpan(
        style: AppStyles.bodyStyle,
        children: [
          TextSpan(text: post['username'], style: const TextStyle(fontWeight: FontWeight.bold)),
          const TextSpan(text: ' '),
          TextSpan(text: post['description']),
        ],
      ),
    );
  }

  Widget _buildCommentsPreview(Map<String, dynamic> post) {
    return GestureDetector(
      onTap: () => _openComments(post),
      child: Text(
        'View all ${post['comments']} comments',
        style: AppStyles.subtitleStyle,
      ),
    );
  }

  Color _getAlertColor(String alertType) {
    switch (alertType) {
      case 'critical': return AppStyles.errorColor;
      case 'warning': return AppStyles.warningColor;
      case 'safe': return AppStyles.safeColor;
      default: return AppStyles.secondaryTextColor;
    }
  }

  void _toggleLike(Map<String, dynamic> post) {
    setState(() {
      post['isLiked'] = !post['isLiked'];
      post['likes'] += post['isLiked'] ? 1 : -1;
    });
    _likeAnimationController.forward().then((_) => _likeAnimationController.reverse());
  }

  void _toggleSave(Map<String, dynamic> post) {
    setState(() {
      post['isSaved'] = !post['isSaved'];
      if (post['isSaved']) {
        _savedPosts.add(post);
      } else {
        _savedPosts.removeWhere((p) => p['id'] == post['id']);
      }
    });
    
    _showSnackBar(post['isSaved'] ? 'Post saved!' : 'Post removed from saved');
  }

  void _openComments(Map<String, dynamic> post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.3,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppStyles.backgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppStyles.radius)),
          ),
          child: CommentsPage(
            post: post,
            onCommentAdded: (updatedPost) {
              setState(() {
                final index = _allPosts.indexWhere((p) => p['id'] == updatedPost['id']);
                if (index != -1) {
                  _allPosts[index] = updatedPost;
                }
              });
            },
          ),
        ),
      ),
    );
  }

  void _sharePost(Map<String, dynamic> post) {
    final text = "${post['title']}\n\n${post['description']}\n\nShared from my app!";
    Share.share(text);
    setState(() {
      post['shares'] += 1; // Optionally update share count locally
    });
  }

  void _showMoreOptions(Map<String, dynamic> post) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppStyles.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppStyles.radius)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(AppStyles.paddingSmall),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: AppStyles.paddingMedium),
              ListTile(
                leading: Icon(post['isSaved'] ? Icons.bookmark : Icons.bookmark_border, color: AppStyles.primaryTextColor),
                title: Text(post['isSaved'] ? 'Remove from saved' : 'Save Post', style: AppStyles.bodyStyle),
                onTap: () {
                  Navigator.pop(context);
                  _toggleSave(post);
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications_outlined, color: AppStyles.primaryTextColor),
                title: Text('Subscribe to location alerts', style: AppStyles.bodyStyle),
                onTap: () {
                  Navigator.pop(context);
                  _subscribeToLocation(post['location']);
                },
              ),
              ListTile(
                leading: const Icon(Icons.flag_outlined, color: AppStyles.errorColor),
                title: const Text('Report', style: TextStyle(color: AppStyles.errorColor)),
                onTap: () {
                  Navigator.pop(context);
                  _showSnackBar('Post reported!');
                },
              ),
              const SizedBox(height: AppStyles.paddingSmall),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterBar() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: AppStyles.paddingSmall),
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppStyles.paddingMedium),
              itemCount: _filterOptions.length,
              itemBuilder: (context, index) {
                final filter = _filterOptions[index];
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: AppStyles.paddingSmall),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedFilter = filter),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppStyles.primaryColor : AppStyles.cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isSelected ? AppStyles.primaryColor : Colors.grey[300]!),
                      ),
                      child: Text(
                        filter,
                        style: AppStyles.bodyStyle.copyWith(
                          color: isSelected ? Colors.white : AppStyles.primaryTextColor,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.language, color: AppStyles.secondaryTextColor),
            onSelected: (language) {
              setState(() => _selectedLanguage = language);
              _showSnackBar('Language changed to $language');
            },
            itemBuilder: (context) => _languages
                .map((lang) => PopupMenuItem(value: lang, child: Text(lang, style: AppStyles.bodyStyle)))
                .toList(),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _filterPosts(List<Map<String, dynamic>> posts) {
    if (_selectedFilter == 'All') return posts;
    return posts.where((post) {
      switch (_selectedFilter) {
        case 'Critical 🚨': return post['alertType'] == 'critical';
        case 'Warning ⚠️': return post['alertType'] == 'warning';
        case 'Safe ✅': return post['alertType'] == 'safe';
        default: return true;
      }
    }).toList();
  }

  Future<void> _refreshFeed() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // In a real app, you would fetch new data here.
      // For demonstration, we'll just shuffle the existing posts.
      _allPosts.shuffle();
    });
  }

  void _subscribeToLocation(String? location) {
    if (location != null) {
      _showSnackBar('Subscribed to alerts for $location');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: AppStyles.baseTextStyle.copyWith(color: Colors.white)),
        backgroundColor: AppStyles.accentColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(AppStyles.paddingMedium),
      ),
    );
  }
}