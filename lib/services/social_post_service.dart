import '../models/social_post.dart';
import '../models/report_model.dart';
import 'report_service.dart';

class SocialPostService {
  static final List<SocialPost> _posts = [
    SocialPost(
      username: '@coastaluser',
      content: 'Huge waves reported in Goa beach area, people moving inland. Stay safe everyone!',
      region: 'Goa',
      sentiment: 'negative',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      location: 'Goa',
      likes: 45,
      retweets: 12,
    ),
    SocialPost(
      username: '@weatherwatch',
      content: 'Cyclone alert issued for Odisha coast. Fishermen advised to return to shore immediately.',
      region: 'Odisha',
      sentiment: 'negative',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      location: 'Odisha',
      likes: 89,
      retweets: 34,
    ),
    SocialPost(
      username: '@chennaiweather',
      content: 'All clear in Chennai today! Perfect weather for beach activities.',
      region: 'Tamil Nadu',
      sentiment: 'positive',
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      location: 'Chennai, Tamil Nadu',
      likes: 23,
      retweets: 5,
    ),
    SocialPost(
      username: '@keralacoast',
      content: 'Moderate waves along Kerala coastline. Normal fishing operations can continue.',
      region: 'Kerala',
      sentiment: 'neutral',
      timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      location: 'Kerala',
      likes: 15,
      retweets: 3,
    ),
    SocialPost(
      username: '@incoisofficial',
      content: 'Tsunami warning lifted for all Indian coastal areas. Situation back to normal.',
      region: 'All India',
      sentiment: 'positive',
      timestamp: DateTime.now().subtract(const Duration(hours: 12)),
      likes: 156,
      retweets: 78,
    ),
    SocialPost(
      username: '@mumbaicoast',
      content: 'Oil spill spotted near Mumbai harbor. Authorities are responding quickly.',
      region: 'Maharashtra',
      sentiment: 'negative',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      location: 'Mumbai, Maharashtra',
      likes: 67,
      retweets: 23,
    ),
    SocialPost(
      username: '@fisherman_joe',
      content: 'Flood waters rising in coastal villages. Need immediate evacuation support!',
      region: 'Tamil Nadu',
      sentiment: 'negative',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      location: 'Cuddalore, Tamil Nadu',
      likes: 89,
      retweets: 45,
    ),
  ];

  static List<SocialPost> getPosts() => _posts;

  static void updatePostStatus(SocialPost post, String status) {
    final index = _posts.indexWhere((p) => p.username == post.username && p.timestamp == post.timestamp);
    if (index != -1) {
      _posts[index].status = status;
    }
  }

  static List<SocialPost> getPostsByKeyword(String keyword) {
    return _posts.where((post) => 
      post.content.toLowerCase().contains(keyword.toLowerCase())
    ).toList();
  }

  static List<Report> getRelatedReports(String keyword) {
    return ReportService.getReports().where((report) =>
      report.hazardType.toLowerCase().contains(keyword.toLowerCase()) ||
      report.description.toLowerCase().contains(keyword.toLowerCase())
    ).toList();
  }

  static Map<String, int> getAnalytics() {
    final today = DateTime.now();
    final todayPosts = _posts.where((post) => 
      post.timestamp.day == today.day &&
      post.timestamp.month == today.month &&
      post.timestamp.year == today.year
    ).length;

    final hazardKeywords = ['tsunami', 'flood', 'cyclone', 'storm', 'oil spill', 'waves'];
    final hazardPosts = _posts.where((post) =>
      hazardKeywords.any((keyword) => post.content.toLowerCase().contains(keyword))
    ).length;

    final negativePosts = _posts.where((post) => post.sentiment == 'negative').length;
    final negativePercentage = _posts.isNotEmpty ? ((negativePosts / _posts.length) * 100).round() : 0;

    return {
      'postsToday': todayPosts,
      'hazardKeywords': hazardPosts,
      'negativePercentage': negativePercentage,
    };
  }
}