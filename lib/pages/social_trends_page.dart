import 'package:flutter/material.dart';
import '../models/social_post.dart';

class SocialTrendsPage extends StatefulWidget {
  const SocialTrendsPage({super.key});

  @override
  State<SocialTrendsPage> createState() => _SocialTrendsPageState();
}

class _SocialTrendsPageState extends State<SocialTrendsPage> {
  String selectedRegion = 'All India';
  String selectedTimeRange = 'Last 24h';
  String? selectedKeyword;

  final List<String> regions = ['All India', 'Tamil Nadu', 'Kerala', 'Goa', 'Andhra Pradesh', 'Odisha'];
  final List<String> timeRanges = ['Last 1h', 'Last 6h', 'Last 24h', 'Last 7d'];

  final Map<String, int> keywordFrequency = {
    'Tsunami': 45,
    'Flood': 32,
    'High Waves': 28,
    'Storm': 25,
    'Cyclone': 18,
    'Alert': 15,
    'Emergency': 12,
    'Rescue': 8,
  };

  final Map<String, double> sentimentData = {
    'positive': 25.0,
    'neutral': 45.0,
    'negative': 30.0,
  };

  List<SocialPost> get filteredPosts {
    var posts = mockPosts;
    if (selectedRegion != 'All India') {
      posts = posts.where((p) => p.region == selectedRegion).toList();
    }
    if (selectedKeyword != null) {
      posts = posts.where((p) => p.content.toLowerCase().contains(selectedKeyword!.toLowerCase())).toList();
    }
    return posts;
  }

  final List<SocialPost> mockPosts = [
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Social Trends'),
        backgroundColor: const Color(0xFF023E8A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFiltersSection(),
            const SizedBox(height: 20),
            _buildKeywordCloud(),
            const SizedBox(height: 20),
            _buildSentimentBar(),
            const SizedBox(height: 20),
            _buildTrendingPostsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Filters', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedRegion,
                  decoration: const InputDecoration(
                    labelText: 'Region',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: regions.map((region) => DropdownMenuItem(value: region, child: Text(region))).toList(),
                  onChanged: (value) => setState(() => selectedRegion = value!),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedTimeRange,
                  decoration: const InputDecoration(
                    labelText: 'Time Range',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: timeRanges.map((range) => DropdownMenuItem(value: range, child: Text(range))).toList(),
                  onChanged: (value) => setState(() => selectedTimeRange = value!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => setState(() {}),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00B4D8)),
            child: const Text('Apply Filters', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildKeywordCloud() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Trending Keywords', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: keywordFrequency.entries.map((entry) {
              final isSelected = selectedKeyword == entry.key;
              final fontSize = (12.0 + (entry.value / 5)).clamp(12.0, 20.0);
              final opacity = (0.3 + (entry.value / 60)).clamp(0.3, 1.0);
              
              return GestureDetector(
                onTap: () => setState(() => selectedKeyword = isSelected ? null : entry.key),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF00B4D8) : const Color(0xFF00B4D8).withOpacity(opacity),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${entry.key} (${entry.value})',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSentimentBar() {
    final positive = sentimentData['positive']!.toInt().clamp(1, 100);
    final neutral = sentimentData['neutral']!.toInt().clamp(1, 100);
    final negative = sentimentData['negative']!.toInt().clamp(1, 100);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Sentiment Analysis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            height: 40,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                Expanded(
                  flex: positive,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF2EC4B6),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                    ),
                    child: Center(
                      child: Text('${sentimentData['positive']!.toInt()}%', 
                           style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ),
                ),
                Expanded(
                  flex: neutral,
                  child: Container(
                    color: Colors.grey,
                    child: Center(
                      child: Text('${sentimentData['neutral']!.toInt()}%', 
                           style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ),
                ),
                Expanded(
                  flex: negative,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF6F61),
                      borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                    ),
                    child: Center(
                      child: Text('${sentimentData['negative']!.toInt()}%', 
                           style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSentimentLabel('Positive', const Color(0xFF2EC4B6)),
              _buildSentimentLabel('Neutral', Colors.grey),
              _buildSentimentLabel('Negative', const Color(0xFFFF6F61)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSentimentLabel(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildTrendingPostsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Trending Posts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredPosts.length,
          itemBuilder: (context, index) => _buildPostCard(filteredPosts[index]),
        ),
      ],
    );
  }

  Widget _buildPostCard(SocialPost post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF00B4D8),
                child: Text(post.username[1], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(post.username, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        Text(_formatTimestamp(post.timestamp), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                    if (post.location != null)
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 12, color: Colors.grey),
                          Text(post.location!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                  ],
                ),
              ),
              _getSentimentIcon(post.sentiment),
            ],
          ),
          const SizedBox(height: 12),
          Text(post.content, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.favorite_border, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text('${post.likes}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              const SizedBox(width: 16),
              Icon(Icons.repeat, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text('${post.retweets}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              const Spacer(),
              GestureDetector(
                onTap: () => _showPostDetails(post),
                child: const Text('View Details', style: TextStyle(color: Color(0xFF00B4D8), fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getSentimentIcon(String sentiment) {
    switch (sentiment) {
      case 'positive':
        return const Icon(Icons.sentiment_satisfied, color: Color(0xFF2EC4B6));
      case 'negative':
        return const Icon(Icons.warning, color: Color(0xFFFF6F61));
      default:
        return const Icon(Icons.sentiment_neutral, color: Colors.grey);
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }

  void _showPostDetails(SocialPost post) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF00B4D8),
                  child: Text(post.username[1], style: const TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.username, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(_formatTimestamp(post.timestamp), style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                _getSentimentIcon(post.sentiment),
              ],
            ),
            const SizedBox(height: 16),
            Text(post.content, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.favorite, color: Colors.red[400]),
                const SizedBox(width: 4),
                Text('${post.likes} likes'),
                const SizedBox(width: 16),
                Icon(Icons.repeat, color: Colors.green[400]),
                const SizedBox(width: 4),
                Text('${post.retweets} retweets'),
              ],
            ),
            if (post.location != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(post.location!),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}