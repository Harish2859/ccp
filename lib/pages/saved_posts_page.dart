import 'package:flutter/material.dart';

class SavedPostsPage extends StatefulWidget {
  final List<Map<String, dynamic>> savedPosts;

  const SavedPostsPage({
    Key? key,
    required this.savedPosts,
  }) : super(key: key);

  @override
  State<SavedPostsPage> createState() => _SavedPostsPageState();
}

class _SavedPostsPageState extends State<SavedPostsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF023E8A),
        elevation: 0,
        title: const Text(
          'Saved Posts',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (widget.savedPosts.isNotEmpty)
            TextButton(
              onPressed: _clearAllSaved,
              child: const Text(
                'Clear All',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: widget.savedPosts.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.savedPosts.length,
              itemBuilder: (context, index) {
                return _buildSavedPostCard(widget.savedPosts[index]);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Saved Posts',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Posts you save will appear here',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedPostCard(Map<String, dynamic> post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFF0096C7),
                  child: Text(
                    post['userAvatar'] ?? post['username'][0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            post['username'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          if (post['isVerified'] == true) ...[
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.verified,
                              size: 16,
                              color: Color(0xFF0096C7),
                            ),
                          ],
                        ],
                      ),
                      if (post['location'] != null) ...[
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 12,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              post['location'],
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                // Alert badge
                if (post['alertType'] != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getAlertColor(post['alertType']),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getAlertEmoji(post['alertType']),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                const SizedBox(width: 8),
                // Remove button
                IconButton(
                  onPressed: () => _removeSavedPost(post),
                  icon: const Icon(
                    Icons.bookmark,
                    color: Color(0xFF0096C7),
                  ),
                ),
              ],
            ),
          ),
          
          // Image
          if (post['imagePath'] != null)
            Container(
              height: 200,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(post['imagePath']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post['title'] ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (post['description'] != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    post['description'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.favorite,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${post['likes']} likes',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${post['comments']} comments',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      post['timeAgo'] ?? 'Just now',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getAlertColor(String alertType) {
    switch (alertType) {
      case 'critical':
        return const Color(0xFFDC2626);
      case 'warning':
        return const Color(0xFFF59E0B);
      case 'safe':
        return const Color(0xFF059669);
      default:
        return const Color(0xFF3B82F6);
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

  void _removeSavedPost(Map<String, dynamic> post) {
    setState(() {
      widget.savedPosts.removeWhere((p) => p['id'] == post['id']);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Post removed from saved'),
        backgroundColor: Color(0xFF2EC4B6),
      ),
    );
  }

  void _clearAllSaved() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Saved Posts'),
        content: const Text('Are you sure you want to remove all saved posts?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                widget.savedPosts.clear();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All saved posts cleared'),
                  backgroundColor: Color(0xFF2EC4B6),
                ),
              );
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}