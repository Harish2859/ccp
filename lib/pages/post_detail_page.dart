import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Reusing styles for consistency
class PostStyles {
  static const Color primaryColor = Color(0xFF005A9C);
  static const Color accentColor = Color(0xFF00B4D8);
  static const Color backgroundColor = Color(0xFFF0F2F5);
  static const Color cardColor = Colors.white;
  static const Color primaryTextColor = Color(0xFF1C1E21);
  static const Color secondaryTextColor = Color(0xFF606770);
  static const Color errorColor = Color(0xFFC70039);
  static const Color warningColor = Color(0xFFFFC300);
  static const Color safeColor = Color(0xFF38A700);
  static const double radius = 12.0;

  static final TextStyle bodyStyle = GoogleFonts.poppins(
    fontSize: 14,
    color: primaryTextColor,
    height: 1.5,
  );
  static final TextStyle titleStyle = GoogleFonts.poppins(
    fontWeight: FontWeight.w700,
    fontSize: 18,
    color: primaryTextColor,
  );
}

// Mock data: This list must be passed from the IncoisProfilePage
final List<Map<String, dynamic>> mockIncoisPosts = [
  {
    'id': 1,
    'date': 'Oct 25, 2025',
    'time': '2 hours ago',
    'imagePath': 'assets/images/image 1.jpg',
    'alertType': 'warning',
    'title': 'High Waves Alert - Kerala Coast',
  },
  {
    'id': 2,
    'date': 'Oct 25, 2025',
    'time': '4 hours ago',
    'imagePath': 'assets/images/image 2.jpg',
    'alertType': 'critical',
    'title': 'Cyclone Update - Bay of Bengal',
  },
  {
    'id': 3,
    'date': 'Oct 25, 2025',
    'time': '6 hours ago',
    'imagePath': 'assets/images/image 3.jpg',
    'alertType': 'safe',
    'title': 'All Clear - Mumbai Coast',
  },
];


class PostDetailPage extends StatefulWidget {
  final List<Map<String, dynamic>> allPosts;
  final int initialIndex;

  const PostDetailPage({
    Key? key,
    required this.allPosts,
    required this.initialIndex,
  }) : super(key: key);

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Color _getAlertColor(String alertType) {
    switch (alertType) {
      case 'critical': return PostStyles.errorColor;
      case 'warning': return PostStyles.warningColor;
      case 'safe': return PostStyles.safeColor;
      default: return PostStyles.secondaryTextColor;
    }
  }

  Widget _buildPostContent(Map<String, dynamic> post) {
    final Color alertColor = _getAlertColor(post['alertType'] ?? '');
    
    final String mockDescription = post['alertType'] == 'critical'
        ? "⚠️ **CRITICAL WARNING:** This is an urgent alert from INCOIS. Expect severe conditions in the designated coastal area. Residents are advised to seek immediate shelter and follow local authority instructions. Tides are abnormally high. Mandatory evacuation is in effect."
        : "Advisory: Normal weather patterns are observed along the coast. Standard safety measures are advised for fishing and maritime activities. INCOIS continues to monitor the situation for any changes.";
    
    final String mockLocation = post['id'] == 2 ? 'Bay of Bengal' : 'Coastal Region A';
    final int mockLikes = post['id'] == 1 ? 520 : 1200;
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.2,
            child: Image.asset(
              post['imagePath'] ?? 'assets/images/default.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: PostStyles.secondaryTextColor.withOpacity(0.1),
                child: const Center(child: Icon(Icons.image_not_supported, size: 60, color: PostStyles.secondaryTextColor)),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: PostStyles.cardColor,
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: PostStyles.primaryColor,
                          child: Text('🇮🇳', style: TextStyle(fontSize: 16)),
                        ),
                        const SizedBox(width: 10),
                        Text('INCOIS Official', style: PostStyles.bodyStyle.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 4),
                        const Icon(Icons.verified, size: 18, color: PostStyles.primaryColor),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: alertColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: alertColor, width: 1),
                      ),
                      child: Text(
                        (post['alertType'] ?? 'INFO').toUpperCase(),
                        style: PostStyles.bodyStyle.copyWith(color: alertColor, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 30, thickness: 0.5),
                Text('Tsunami Warning & Coastal Alert', style: PostStyles.titleStyle),
                const SizedBox(height: 10),
                Text(mockDescription, style: PostStyles.bodyStyle),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: PostStyles.secondaryTextColor),
                    const SizedBox(width: 5),
                    Text(mockLocation, style: PostStyles.bodyStyle.copyWith(color: PostStyles.secondaryTextColor)),
                    const SizedBox(width: 15),
                    const Icon(Icons.access_time, size: 16, color: PostStyles.secondaryTextColor),
                    const SizedBox(width: 5),
                    Text(post['time'] ?? 'Just now', style: PostStyles.bodyStyle.copyWith(color: PostStyles.secondaryTextColor)),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.favorite_border, color: PostStyles.secondaryTextColor, size: 28),
                    const SizedBox(width: 8),
                    Text('$mockLikes Likes', style: PostStyles.bodyStyle.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(width: 20),
                    const Icon(Icons.chat_bubble_outline, color: PostStyles.secondaryTextColor, size: 28),
                    const SizedBox(width: 8),
                    Text('45 Comments', style: PostStyles.bodyStyle.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
                const Icon(Icons.bookmark_border, color: PostStyles.secondaryTextColor, size: 28),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PostStyles.backgroundColor,
      appBar: AppBar(
        backgroundColor: PostStyles.cardColor,
        elevation: 1,
        title: Text(
          'INCOIS Alert',
          style: PostStyles.titleStyle.copyWith(fontSize: 16),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: PostStyles.primaryTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: PostStyles.primaryTextColor),
            onPressed: () {},
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: widget.allPosts.length,
        itemBuilder: (context, index) {
          return _buildPostContent(widget.allPosts[index]);
        },
      ),
    );
  }
}