import 'package:flutter/material.dart';
import 'dart:convert';
import '../models/social_post.dart';
import '../models/report_model.dart';
import '../services/social_post_service.dart';

class SocialTrendsPage extends StatefulWidget {
  final bool isOfficial;
  
  const SocialTrendsPage({super.key, this.isOfficial = false});

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
    var posts = SocialPostService.getPosts();
    if (selectedRegion != 'All India') {
      posts = posts.where((p) => p.region == selectedRegion).toList();
    }
    if (selectedKeyword != null) {
      posts = posts.where((p) => p.content.toLowerCase().contains(selectedKeyword!.toLowerCase())).toList();
    }
    return posts;
  }

  Map<String, int> get analytics => SocialPostService.getAnalytics();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Social Trends'),
        backgroundColor: const Color(0xFF023E8A),
        foregroundColor: Colors.white,
        actions: widget.isOfficial ? [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: _exportData,
            tooltip: 'Export Data',
          ),
        ] : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.isOfficial) ...[
              _buildAnalyticsCards(),
              const SizedBox(height: 20),
            ],
            _buildFiltersSection(),
            const SizedBox(height: 20),
            _buildKeywordCloud(),
            const SizedBox(height: 20),
            _buildSentimentBar(),
            const SizedBox(height: 20),
            if (widget.isOfficial)
              _buildCompareButton(),
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
                onTap: () {
                  setState(() => selectedKeyword = isSelected ? null : entry.key);
                  if (widget.isOfficial && !isSelected) {
                    _showKeywordCrossCheck(entry.key);
                  }
                },
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
              if (widget.isOfficial) ...[
                _buildValidationButtons(post),
                const SizedBox(width: 8),
              ],
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

  Widget _buildAnalyticsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildAnalyticsCard(
            'Posts Today',
            analytics['postsToday'].toString(),
            Icons.today,
            const Color(0xFF00B4D8),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildAnalyticsCard(
            'Hazard Keywords',
            analytics['hazardKeywords'].toString(),
            Icons.warning,
            const Color(0xFFFF6F61),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildAnalyticsCard(
            'Negative %',
            '${analytics['negativePercentage']}%',
            Icons.sentiment_dissatisfied,
            const Color(0xFFFF6F61),
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildCompareButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _showCompareModal,
        icon: const Icon(Icons.compare_arrows, color: Colors.white),
        label: const Text('Compare Reports vs Social Media', style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF023E8A),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildValidationButtons(SocialPost post) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildValidationButton(Icons.check, Colors.green, 'relevant', post),
        const SizedBox(width: 4),
        _buildValidationButton(Icons.close, Colors.red, 'false', post),
        const SizedBox(width: 4),
        _buildValidationButton(Icons.help_outline, Colors.orange, 'verify', post),
      ],
    );
  }

  Widget _buildValidationButton(IconData icon, Color color, String status, SocialPost post) {
    final isSelected = post.status == status;
    return GestureDetector(
      onTap: () {
        setState(() {
          SocialPostService.updatePostStatus(post, isSelected ? 'pending' : status);
        });
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.grey[300],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, size: 12, color: isSelected ? Colors.white : Colors.grey[600]),
      ),
    );
  }

  void _showKeywordCrossCheck(String keyword) {
    final posts = SocialPostService.getPostsByKeyword(keyword);
    final reports = SocialPostService.getRelatedReports(keyword);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cross-Check: $keyword'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: Column(
            children: [
              Text('${posts.length} related posts, ${reports.length} citizen reports'),
              const SizedBox(height: 16),
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      const TabBar(
                        tabs: [
                          Tab(text: 'Posts'),
                          Tab(text: 'Reports'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            ListView.builder(
                              itemCount: posts.length,
                              itemBuilder: (context, index) => ListTile(
                                title: Text(posts[index].username),
                                subtitle: Text(posts[index].content, maxLines: 2),
                                trailing: _getSentimentIcon(posts[index].sentiment),
                              ),
                            ),
                            ListView.builder(
                              itemCount: reports.length,
                              itemBuilder: (context, index) => ListTile(
                                title: Text(reports[index].hazardType),
                                subtitle: Text(reports[index].description, maxLines: 2),
                                trailing: Text(reports[index].severity),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showCompareModal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reports vs Social Media'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const TabBar(
                  tabs: [
                    Tab(text: 'Latest Reports'),
                    Tab(text: 'Latest Posts'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      ListView.builder(
                        itemCount: 3,
                        itemBuilder: (context, index) => ListTile(
                          title: Text('Report ${index + 1}'),
                          subtitle: const Text('Sample report description'),
                          trailing: const Text('High'),
                        ),
                      ),
                      ListView.builder(
                        itemCount: filteredPosts.take(3).length,
                        itemBuilder: (context, index) {
                          final post = filteredPosts[index];
                          return ListTile(
                            title: Text(post.username),
                            subtitle: Text(post.content, maxLines: 2),
                            trailing: _getSentimentIcon(post.sentiment),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _exportData() {
    final posts = filteredPosts;
    final jsonData = posts.map((post) => post.toJson()).toList();
    final jsonString = const JsonEncoder.withIndent('  ').convert(jsonData);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exported ${posts.length} posts to JSON'),
        backgroundColor: const Color(0xFF2EC4B6),
        action: SnackBarAction(
          label: 'View',
          textColor: Colors.white,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Exported Data'),
                content: SingleChildScrollView(
                  child: Text(jsonString, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
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
            if (widget.isOfficial) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Status: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(post.status.toUpperCase()),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }
}