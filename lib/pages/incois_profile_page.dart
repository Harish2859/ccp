// incois_profile_page.dart (Existing file, modified)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'post_detail_page.dart'; 

// --- UI Style Constants for INCOIS Theme ---
class IncoisStyles {
  static const Color primaryColor = Color(0xFF005A9C); // INCOIS Blue
  static const Color accentColor = Color(0xFF00B4D8);
  static const Color backgroundColor = Color(0xFFF0F2F5);
  static const Color cardColor = Colors.white;
  static const Color primaryTextColor = Color(0xFF1C1E21);
  static const Color secondaryTextColor = Color(0xFF606770);
  static const Color errorColor = Color(0xFFC70039);
  static const Color warningColor = Color(0xFFFFC300);
  static const Color safeColor = Color(0xFF38A700);
  static const double radius = 12.0;

  static final TextStyle headingStyle = GoogleFonts.poppins(
    fontWeight: FontWeight.w700,
    fontSize: 18,
    color: primaryTextColor,
  );

  static final TextStyle bodyStyle = GoogleFonts.poppins(
    fontWeight: FontWeight.normal,
    fontSize: 14,
    color: primaryTextColor,
  );
  
  static final TextStyle statValueStyle = GoogleFonts.poppins(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: primaryColor,
  );
  
  static final TextStyle statLabelStyle = GoogleFonts.poppins(
    fontSize: 12,
    color: secondaryTextColor,
  );
}
// ---------------------------------------------

// Mock data for the posts grid (Including placeholder images)
final List<Map<String, dynamic>> mockIncoisPosts = [
  {
    'id': 1,
    'date': 'Oct 25, 2025',
    'time': '2 hours ago',
    'imagePath': 'assets/images/image 1.jpg',
    'alertType': 'warning',
  },
  {
    'id': 2,
    'date': 'Oct 25, 2025',
    'time': '4 hours ago',
    'imagePath': 'assets/images/image 2.jpg',
    'alertType': 'critical',
  },
  {
    'id': 3,
    'date': 'Oct 25, 2025',
    'time': '6 hours ago',
    'imagePath': 'assets/images/image 3.jpg',
    'alertType': 'safe',
  },
  {
    'id': 4,
    'date': 'Oct 24, 2025',
    'time': 'Yesterday, 8:00 PM',
    'imagePath': 'assets/images/image 4.jpg', // Assuming this path exists
    'alertType': 'warning',
  },
  {
    'id': 5,
    'date': 'Oct 24, 2025',
    'time': 'Yesterday, 3:00 PM',
    'imagePath': 'assets/images/image 5.jpg', // Assuming this path exists
    'alertType': 'safe',
  },
];

class IncoisProfilePage extends StatelessWidget {
  const IncoisProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Map<String, dynamic>>> groupedPosts = _groupPostsByDate(mockIncoisPosts);
    final List<String> dates = groupedPosts.keys.toList();

    return Scaffold(
      backgroundColor: IncoisStyles.backgroundColor,
      appBar: AppBar(
        backgroundColor: IncoisStyles.primaryColor,
        title: Text(
          'INCOIS Official',
          style: IncoisStyles.headingStyle.copyWith(color: Colors.white, fontSize: 20),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.public, color: Colors.white),
            onPressed: () {
              // Action to open INCOIS website
            },
          ),
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildProfileHeader(context),
            ),
            const SizedBox(height: 20),

            // Service Highlights Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Key Services', style: IncoisStyles.headingStyle),
            ),
            const SizedBox(height: 12),
            _buildServiceHighlights(),
            const SizedBox(height: 24),

            // Posts Grid Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Recent Alerts & Advisories', style: IncoisStyles.headingStyle),
            ),
            const SizedBox(height: 12),

            // Dynamically build the posts list with date headers
            ...dates.map((date) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Text(
                      date == 'Oct 25, 2025' ? 'TODAY' : date.toUpperCase(),
                      style: IncoisStyles.statLabelStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: IncoisStyles.primaryColor,
                      ),
                    ),
                  ),
                  _buildPostsGrid(context, groupedPosts[date]!), // Pass context here
                ],
              );
            }).toList(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildProfileHeader(BuildContext context) {
    // ... (No change) ...
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IncoisStyles.cardColor,
        borderRadius: BorderRadius.circular(IncoisStyles.radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: IncoisStyles.primaryColor,
            child: const Text('🇮🇳', style: TextStyle(fontSize: 32)),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'INCOIS Official',
                style: IncoisStyles.headingStyle.copyWith(fontSize: 22),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.verified, color: IncoisStyles.primaryColor, size: 24),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Indian National Centre for Ocean Information Services',
            style: TextStyle(fontSize: 14, color: IncoisStyles.secondaryTextColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            'Official account providing real-time ocean and weather alerts, including Tsunami warnings, for coastal safety.',
            style: TextStyle(fontSize: 14, height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoItem(Icons.location_on, 'Hyderabad, India', Colors.grey),
              _buildInfoItem(Icons.link, 'incois.gov.in', IncoisStyles.primaryColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text, Color color) {
    // ... (No change) ...
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          text,
          style: IncoisStyles.bodyStyle.copyWith(color: color, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildServiceHighlights() {
    // ... (No change) ...
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          _buildServiceCard('Tsunami', Icons.tsunami, IncoisStyles.errorColor),
          const SizedBox(width: 12),
          _buildServiceCard('High Waves', Icons.waves, IncoisStyles.warningColor),
          const SizedBox(width: 12),
          _buildServiceCard('Fishermen', Icons.sailing, IncoisStyles.primaryColor),
          const SizedBox(width: 12),
          _buildServiceCard('Data Portal', Icons.cloud_download, IncoisStyles.accentColor),
        ],
      ),
    );
  }

  Widget _buildServiceCard(String title, IconData icon, Color color) {
    // ... (No change) ...
    return Container(
      width: 90,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: IncoisStyles.cardColor,
        borderRadius: BorderRadius.circular(IncoisStyles.radius),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 4),
          Text(
            title,
            style: IncoisStyles.bodyStyle.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPostsGrid(BuildContext context, List<Map<String, dynamic>> posts) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.0, // Square posts
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return _buildPostGridItem(context, posts[index]);
      },
    );
  }

  Widget _buildPostGridItem(BuildContext context, Map<String, dynamic> post) {
    Color alertColor;
    String alertIcon;

    switch (post['alertType']) {
      case 'critical':
        alertColor = IncoisStyles.errorColor;
        alertIcon = '🚨';
        break;
      case 'warning':
        alertColor = IncoisStyles.warningColor;
        alertIcon = '⚠️';
        break;
      case 'safe':
        alertColor = IncoisStyles.safeColor;
        alertIcon = '✅';
        break;
      default:
        alertColor = Colors.transparent;
        alertIcon = '';
    }

    return GestureDetector(
      onTap: () {
        final allPosts = mockIncoisPosts;
        final currentIndex = allPosts.indexWhere((p) => p['id'] == post['id']);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailPage(
              allPosts: allPosts,
              initialIndex: currentIndex >= 0 ? currentIndex : 0,
            ),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(IncoisStyles.radius - 4),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image
            Image.asset(
              post['imagePath'],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: IncoisStyles.secondaryTextColor.withOpacity(0.1),
                  child: Center(
                    child: Icon(Icons.broken_image, size: 40, color: IncoisStyles.secondaryTextColor.withOpacity(0.5)),
                  ),
                );
              },
            ),

            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.0), Colors.black.withOpacity(0.5)],
                ),
              ),
            ),

            // Alert Type & Time
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: alertColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '$alertIcon ${post['alertType'].toString().toUpperCase()}',
                      style: IncoisStyles.statLabelStyle.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    post['time'],
                    style: IncoisStyles.statLabelStyle.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Utility function to group posts
  Map<String, List<Map<String, dynamic>>> _groupPostsByDate(List<Map<String, dynamic>> posts) {
    Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var post in posts) {
      String date = post['date'];
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(post);
    }
    return grouped;
  }
}