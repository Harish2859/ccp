import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../components/index.dart'; // Assuming MainLayout, UserRole are here
import '../services/feed_service.dart'; // Assuming this is kept for additional posts
import 'notifications_page.dart';
import 'report_page.dart';

import 'my_reports_page.dart';
import 'social_trends_page.dart';
import 'profile_page.dart';
import 'comments_page.dart';
import 'saved_posts_page.dart';
import 'incois_profile_page.dart';

// --- UI Style Constants for a Modern Look (Slightly Adjusted) ---
class AppStyles {
  // Colors
  static const Color primaryColor = Color(0xFF005A9C); // Deeper Blue for official feel
  static const Color accentColor = Color(0xFF0077B6);
  static const Color backgroundColor = Color(0xFFF0F2F5); // Lighter background for feed
  static const Color cardColor = Colors.white;
  static const Color primaryTextColor = Color(0xFF1C1E21);
  static const Color secondaryTextColor = Color(0xFF606770);
  static const Color errorColor = Color(0xFFC70039); // Stronger Red for Critical
  static const Color warningColor = Color(0xFFFFC300); // Amber/Yellow for Warning
  static const Color safeColor = Color(0xFF38A700); // Green for Safe

  // Spacing & Radius
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double radius = 12.0; // Slightly less aggressive radius
  static const double iconSize = 24.0;

  // Typography
  static final TextStyle baseTextStyle = GoogleFonts.poppins();

  static final TextStyle headingStyle = baseTextStyle.copyWith(
    fontWeight: FontWeight.w700,
    fontSize: 18,
    color: primaryTextColor,
  );

  static final TextStyle bodyStyle = baseTextStyle.copyWith(
    fontWeight: FontWeight.normal,
    fontSize: 14,
    color: primaryTextColor,
    height: 1.5,
  );

  static final TextStyle subtitleStyle = baseTextStyle.copyWith(
    fontSize: 12,
    color: secondaryTextColor,
  );
  
  static final TextStyle alertTitleStyle = baseTextStyle.copyWith(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: primaryTextColor,
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
  
  // All posts are now from the single official source
  final String _officialUsername = 'INCOIS Official';
  final String _officialAvatar = '🇮🇳';
  
  final List<Map<String, dynamic>> _incoisPosts = [
    {
      'id': 1,
      'username': 'INCOIS Official',
      'userAvatar': '🇮🇳',
      'isVerified': true,
      'timeAgo': '2 hours ago',
      'imagePath': 'assets/images/image 1.jpg',
      'title': 'High Waves Alert - Kerala Coast',
      'description': 'Wave heights of 2.5-3.5m expected along Kerala coast. Fishermen advised to avoid venturing into the sea. **Stay safe!**',
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
      'username': 'INCOIS Official',
      'userAvatar': '🇮🇳',
      'isVerified': true,
      'timeAgo': '4 hours ago',
      'imagePath': 'assets/images/image 2.jpg',
      'title': 'Cyclone Update - Bay of Bengal',
      'description': 'Low pressure area in Bay of Bengal likely to intensify into a severe cyclonic storm. Coastal areas of Andhra Pradesh and Odisha on **HIGH ALERT**.',
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
      'username': 'INCOIS Official',
      'userAvatar': '🇮🇳',
      'isVerified': true,
      'timeAgo': '6 hours ago',
      'imagePath': 'assets/images/image 3.jpg',
      'title': 'All Clear - Mumbai Coast',
      'description': 'Weather conditions normal along Mumbai coastline. All maritime restrictions are lifted. Safe for all maritime activities with usual precautions.',
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
    // Initialize the combined list of posts (Using the official posts only)
    _allPosts = [..._incoisPosts]; 
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
      title: 'INCOIS Alert Feed', // More specific title
      currentNavIndex: _currentNavIndex,
      userRole: UserRole.citizen, 
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
                    horizontal: AppStyles.paddingMedium, // Increased padding
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
    
    // Using push replacement for navigation to main sections
    Navigator.pushReplacement( 
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void _navigateTo(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppStyles.paddingMedium),
      decoration: BoxDecoration(
        color: AppStyles.cardColor,
        borderRadius: BorderRadius.circular(AppStyles.radius),
        boxShadow: [
          BoxShadow(
            color: AppStyles.primaryTextColor.withOpacity(0.08), // Softer shadow
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPostHeader(post),
          _buildImageSection(post),
          Padding(
            padding: const EdgeInsets.all(AppStyles.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Alert Title (New Element)
                Text(
                  post['title'].toString().toUpperCase(), 
                  style: AppStyles.alertTitleStyle.copyWith(
                    color: _getAlertColor(post['alertType']),
                  ),
                ),
                const SizedBox(height: AppStyles.paddingSmall / 2),
                _buildCaptionSection(post),
                const SizedBox(height: AppStyles.paddingMedium),
                _buildActionBar(post),
                const Divider(height: 20, thickness: 0.5),
                _buildCommentsPreview(post),
                const SizedBox(height: AppStyles.paddingSmall),
                Text(post['timeAgo'].toString().toUpperCase(), style: AppStyles.subtitleStyle.copyWith(fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostHeader(Map<String, dynamic> post) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppStyles.paddingMedium, AppStyles.paddingMedium, AppStyles.paddingSmall, AppStyles.paddingSmall),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const IncoisProfilePage()),
            ),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: AppStyles.primaryColor,
              child: Text(
                _officialAvatar,
                style: AppStyles.baseTextStyle.copyWith(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const IncoisProfilePage()),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(_officialUsername, style: AppStyles.headingStyle.copyWith(fontSize: 16)),
                      const SizedBox(width: 4),
                      const Icon(Icons.verified, size: 18, color: AppStyles.primaryColor),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: AppStyles.secondaryTextColor),
                      const SizedBox(width: 4),
                      Text(post['location'], style: AppStyles.subtitleStyle),
                    ],
                  ),
                ],
              ),
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
    return Stack(
      alignment: Alignment.topRight,
      children: [
        AspectRatio(
          aspectRatio: 1.6, // Using a more cinematic aspect ratio
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
        ),
        // Alert Badge Overlay
        _buildAlertBadge(post['alertType']),
      ],
    );
  }
  
  Widget _buildAlertBadge(String alertType) {
    String text;
    IconData icon;
    Color color = _getAlertColor(alertType);
    
    switch (alertType) {
      case 'critical': 
        text = 'CRITICAL ALERT';
        icon = Icons.error;
        break;
      case 'warning': 
        text = 'WARNING';
        icon = Icons.warning;
        break;
      case 'safe': 
        text = 'ALL CLEAR';
        icon = Icons.check_circle;
        break;
      default: return const SizedBox.shrink();
    }
    
    return Container(
      margin: const EdgeInsets.all(AppStyles.paddingSmall),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 4)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            text,
            style: AppStyles.subtitleStyle.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildActionBar(Map<String, dynamic> post) {
    return Row(
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
                  color: post['isLiked'] ? AppStyles.errorColor : AppStyles.secondaryTextColor,
                  size: AppStyles.iconSize,
                ),
              ),
            ),
            IconButton(
              onPressed: () => _openComments(post),
              icon: const Icon(Icons.chat_bubble_outline, color: AppStyles.secondaryTextColor, size: AppStyles.iconSize),
            ),
            IconButton(
              onPressed: () => _sharePost(post),
              icon: const Icon(Icons.share_outlined, color: AppStyles.secondaryTextColor, size: AppStyles.iconSize),
            ),
          ],
        ),
        // Display likes count prominently
        Text('${post['likes']} likes', style: AppStyles.bodyStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 13)),
        
        IconButton(
          onPressed: () => _toggleSave(post),
          icon: Icon(
            post['isSaved'] ? Icons.bookmark : Icons.bookmark_border,
            color: post['isSaved'] ? AppStyles.primaryColor : AppStyles.secondaryTextColor,
            size: AppStyles.iconSize,
          ),
        ),
      ],
    );
  }
  
  Widget _buildCaptionSection(Map<String, dynamic> post) {
    return Text(
      post['description'],
      style: AppStyles.bodyStyle,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildCommentsPreview(Map<String, dynamic> post) {
    return GestureDetector(
      onTap: () => _openComments(post),
      child: Text(
        'View all ${post['comments']} comments',
        style: AppStyles.subtitleStyle.copyWith(fontWeight: FontWeight.w600),
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
    // Run animation only if it was liked
    if (post['isLiked']) {
      _likeAnimationController.forward(from: 0.0).then((_) => _likeAnimationController.reverse());
    }
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
    
    _showSnackBar(post['isSaved'] ? 'Alert saved for later reference.' : 'Alert removed from saved.');
  }

  void _openComments(Map<String, dynamic> post) {
    // ... (unchanged _openComments logic) ...
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
    final text = "INCOIS Alert: ${post['title']} - ${post['location']}\n\n${post['description']}\n\n#INCOIS #WeatherAlert";
    Share.share(text, subject: post['title']);
    setState(() {
      post['shares'] = (post['shares'] as int) + 1;
    });
  }

  void _showMoreOptions(Map<String, dynamic> post) {
    // ... (unchanged _showMoreOptions logic, except for SnackBar message) ...
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
                title: Text(post['isSaved'] ? 'Remove from saved' : 'Save Alert', style: AppStyles.bodyStyle),
                onTap: () {
                  Navigator.pop(context);
                  _toggleSave(post);
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications_outlined, color: AppStyles.primaryTextColor),
                title: Text('Subscribe to ${post['location']} alerts', style: AppStyles.bodyStyle),
                onTap: () {
                  Navigator.pop(context);
                  _subscribeToLocation(post['location']);
                },
              ),
              ListTile(
                leading: const Icon(Icons.flag_outlined, color: AppStyles.errorColor),
                title: const Text('Report/Verify Alert Status', style: TextStyle(color: AppStyles.errorColor)),
                onTap: () {
                  Navigator.pop(context);
                  _showSnackBar('Alert flagged for review/verification.');
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
      color: AppStyles.cardColor, // White background for the filter bar
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
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppStyles.primaryColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isSelected ? AppStyles.primaryColor : AppStyles.secondaryTextColor.withOpacity(0.5)),
                      ),
                      child: Center( // Center the text within the button
                        child: Text(
                          filter.replaceAll('🚨', '').replaceAll('⚠️', '').replaceAll('✅', '').trim(), // Cleaned up text for a professional look
                          style: AppStyles.bodyStyle.copyWith(
                            color: isSelected ? Colors.white : AppStyles.primaryTextColor,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Language Selector
          PopupMenuButton<String>(
            icon: Row(
              children: [
                const Icon(Icons.language, color: AppStyles.secondaryTextColor, size: 20),
                const SizedBox(width: 4),
                Text(_selectedLanguage, style: AppStyles.subtitleStyle.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            onSelected: (language) {
              setState(() => _selectedLanguage = language);
              _showSnackBar('Language changed to $language');
            },
            itemBuilder: (context) => _languages
                .map((lang) => PopupMenuItem(value: lang, child: Text(lang, style: AppStyles.bodyStyle)))
                .toList(),
          ),
          const SizedBox(width: AppStyles.paddingMedium),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _filterPosts(List<Map<String, dynamic>> posts) {
    if (_selectedFilter == 'All') return posts;
    return posts.where((post) {
      // Use the actual alertType value for filtering
      String? postAlertType = post['alertType'];
      if (postAlertType == null) return false;

      switch (_selectedFilter) {
        case 'Critical 🚨': return postAlertType == 'critical';
        case 'Warning ⚠️': return postAlertType == 'warning';
        case 'Safe ✅': return postAlertType == 'safe';
        default: return true;
      }
    }).toList();
  }

  Future<void> _refreshFeed() async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // Refresh logic: In a real app, you'd fetch new data.
      _allPosts.shuffle(); 
      _showSnackBar('Feed refreshed!');
    });
  }

  void _subscribeToLocation(String? location) {
    if (location != null) {
      _showSnackBar('Subscribed to real-time alerts for $location.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: AppStyles.baseTextStyle.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
        backgroundColor: AppStyles.accentColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(AppStyles.paddingMedium),
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }
}