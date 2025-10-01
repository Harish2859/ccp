import 'package:flutter/material.dart';
import 'dart:convert';
import '../models/social_post.dart';
import '../models/report_model.dart';
import '../services/social_post_service.dart';
import '../components/bottom_nav_bar.dart';
import 'home_page.dart';
import 'report_page.dart';
import 'profile_page.dart';

class SocialTrendsPage extends StatefulWidget {
  const SocialTrendsPage({super.key});

  @override
  State<SocialTrendsPage> createState() => _SocialTrendsPageState();
}

class _SocialTrendsPageState extends State<SocialTrendsPage> {
  String selectedRegion = 'All India';
  String selectedTimeRange = 'Last 24h';
  String? selectedKeyword;
  final TextEditingController _searchController = TextEditingController();
  bool _showSearchDropdown = false;
  List<String> _filteredKeywords = [];
  int _currentNavIndex = 2;

  final List<String> regions = ['All India', 'Tamil Nadu', 'Kerala', 'Goa', 'Andhra Pradesh', 'Odisha'];
  final List<String> timeRanges = ['Last 1h', 'Last 6h', 'Last 24h', 'Last 7d'];
  
  final List<Map<String, String>> disasterTypes = [
    {'value': 'all', 'label': 'All Disasters'},
    {'value': 'coastal_flooding', 'label': 'Coastal Flooding / Inundation 🌊'},
    {'value': 'high_waves', 'label': 'High Waves / Swell Surge 🌊'},
    {'value': 'abnormal_sea_behaviour', 'label': 'Abnormal Sea Behaviour / Tides 🌀'},
    {'value': 'coastal_erosion', 'label': 'Coastal Erosion / Infrastructure Damage 🏗️'},
    {'value': 'storm_surge', 'label': 'Storm Surge / Cyclone Impact 🌪️'},
  ];
  String selectedDisasterType = 'all';

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
    
    // Filter by region
    if (selectedRegion != 'All India') {
      posts = posts.where((p) => p.region == selectedRegion).toList();
    }
    
    // Filter by search keyword
    if (_searchController.text.isNotEmpty) {
      posts = posts.where((p) => 
        p.content.toLowerCase().contains(_searchController.text.toLowerCase()) ||
        p.username.toLowerCase().contains(_searchController.text.toLowerCase())
      ).toList();
    }
    
    // Filter by selected keyword from cloud
    if (selectedKeyword != null) {
      posts = posts.where((p) => p.content.toLowerCase().contains(selectedKeyword!.toLowerCase())).toList();
    }
    
    // Filter by time range (mock implementation)
    final now = DateTime.now();
    posts = posts.where((p) {
      switch (selectedTimeRange) {
        case 'Last 1h':
          return now.difference(p.timestamp).inHours < 1;
        case 'Last 6h':
          return now.difference(p.timestamp).inHours < 6;
        case 'Last 24h':
          return now.difference(p.timestamp).inHours < 24;
        case 'Last 7d':
          return now.difference(p.timestamp).inDays < 7;
        default:
          return true;
      }
    }).toList();
    
    return posts;
  }

  Map<String, int> get analytics => SocialPostService.getAnalytics();

  @override
  void initState() {
    super.initState();
    _filteredKeywords = keywordFrequency.keys.toList();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      if (_searchController.text.isEmpty) {
        _filteredKeywords = keywordFrequency.keys.toList();
        _showSearchDropdown = false;
      } else {
        _filteredKeywords = keywordFrequency.keys
            .where((keyword) => keyword.toLowerCase().contains(_searchController.text.toLowerCase()))
            .toList();
        _showSearchDropdown = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Social Trends'),
        backgroundColor: const Color(0xFF023E8A),
        foregroundColor: Colors.white,
        actions: null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            const SizedBox(height: 16),
            _buildFiltersSection(),
            const SizedBox(height: 20),
            _buildTrendingPostsList(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentNavIndex,
        userRole: UserRole.citizen,
        onTap: _onNavTap,
      ),
    );
  }

  Widget _buildSearchBar() {
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
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search keywords, posts, or users...',
              prefixIcon: const Icon(Icons.search, color: Color(0xFF00B4D8)),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _showSearchDropdown = false;
                          selectedKeyword = null;
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF00B4D8)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF00B4D8), width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onTap: () {
              setState(() {
                _showSearchDropdown = true;
              });
            },
          ),
          if (_showSearchDropdown)
            Container(
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  if (_searchController.text.isEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Trending Keywords', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                    ),
                    ...keywordFrequency.entries.take(5).map((entry) {
                      return ListTile(
                        dense: true,
                        leading: const Icon(Icons.trending_up, size: 16, color: Color(0xFF00B4D8)),
                        title: Text(entry.key, style: const TextStyle(fontSize: 14)),
                        trailing: Text('${entry.value}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        onTap: () {
                          _searchController.text = entry.key;
                          setState(() {
                            selectedKeyword = entry.key;
                            _showSearchDropdown = false;
                          });
                        },
                      );
                    }).toList(),
                  ] else ...[
                    if (_filteredKeywords.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Search Results', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                      ),
                      ..._filteredKeywords.take(5).map((keyword) {
                        return ListTile(
                          dense: true,
                          leading: const Icon(Icons.search, size: 16, color: Color(0xFF00B4D8)),
                          title: Text(keyword, style: const TextStyle(fontSize: 14)),
                          trailing: Text('${keywordFrequency[keyword]}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          onTap: () {
                            _searchController.text = keyword;
                            setState(() {
                              selectedKeyword = keyword;
                              _showSearchDropdown = false;
                            });
                          },
                        );
                      }).toList(),
                    ] else ...[
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('No matching keywords found', style: TextStyle(color: Colors.grey)),
                      ),
                    ],
                  ],
                ],
              ),
            ),
        ],
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
                  isExpanded: true,
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
          DropdownButtonFormField<String>(
            value: selectedDisasterType,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Disaster Type',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: disasterTypes.map((type) => DropdownMenuItem(value: type['value'], child: Text(type['label']!))).toList(),
            onChanged: (value) => setState(() => selectedDisasterType = value!),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => setState(() {}),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00B4D8)),
                  child: const Text('Apply Filters', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _clearAllFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[600],
                  foregroundColor: Colors.white,
                ),
                child: const Text('Clear All'),
              ),
            ],
          ),
        ],
      ),
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
                    Row(
                      children: [
                        const Icon(Icons.person_pin_circle, size: 12, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text('Chennai, Tamil Nadu', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
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
          if (post.location != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF00B4D8).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on, size: 12, color: Color(0xFF00B4D8)),
                  const SizedBox(width: 4),
                  Text(
                    'Disaster Location: ${post.location!}',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF00B4D8), fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
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

















  void _clearAllFilters() {
    setState(() {
      selectedRegion = 'All India';
      selectedTimeRange = 'Last 24h';
      selectedKeyword = null;
      _searchController.clear();
      _showSearchDropdown = false;
    });
  }

  void _onNavTap(int index) {
    if (index == 2) return; // Already on social trends page
    
    Widget page;
    switch (index) {
      case 0:
        page = const HomePage();
        break;
      case 1:
        page = const ReportPage();
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