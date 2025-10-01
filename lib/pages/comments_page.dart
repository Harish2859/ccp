import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- UI Style Constants (assumed from the previous enhancement) ---
class AppStyles {
  // Colors
  static const Color primaryColor = Color(0xFF0077B6);
  static const Color accentColor = Color(0xFF00B4D8);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color cardColor = Colors.white;
  static const Color primaryTextColor = Color(0xFF212529);
  static const Color secondaryTextColor = Color(0xFF6C757D);

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

class CommentsPage extends StatefulWidget {
  final Map<String, dynamic> post;
  final Function(Map<String, dynamic>) onCommentAdded;

  const CommentsPage({
    super.key,
    required this.post,
    required this.onCommentAdded,
  });

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // Ensure commentsList is not null
    final comments = widget.post['commentsList'] as List? ?? [];

    return Column(
      children: [
        // Handle bar
        Container(
          width: 40,
          height: 4,
          margin: const EdgeInsets.symmetric(vertical: AppStyles.paddingSmall),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        // Header
        Padding(
          padding: const EdgeInsets.all(AppStyles.paddingMedium),
          child: Text(
            'Comments',
            style: AppStyles.baseTextStyle.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: comments.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(AppStyles.paddingMedium),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return _buildCommentItem(comment);
                  },
                  separatorBuilder: (context, index) => const SizedBox(height: AppStyles.paddingMedium),
                ),
        ),
        _buildCommentInputArea(),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 60,
            color: Colors.grey[300],
          ),
          const SizedBox(height: AppStyles.paddingMedium),
          Text(
            'No comments yet.',
            style: AppStyles.subtitleStyle.copyWith(fontSize: 16),
          ),
          Text(
            'Be the first to comment!',
            style: AppStyles.subtitleStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(Map<String, dynamic> comment) {
    String username = comment['username'] ?? 'Anonymous';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AppStyles.primaryColor.withOpacity(0.8),
          child: Text(
            username[0].toUpperCase(),
            style: AppStyles.baseTextStyle.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: AppStyles.paddingMedium),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    username,
                    style: AppStyles.headingStyle.copyWith(fontSize: 14),
                  ),
                  const SizedBox(width: AppStyles.paddingSmall),
                  Text(
                    '• ${comment['time'] ?? ''}',
                    style: AppStyles.subtitleStyle.copyWith(fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                comment['text'] ?? '',
                style: AppStyles.bodyStyle.copyWith(color: AppStyles.primaryTextColor.withOpacity(0.8)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommentInputArea() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppStyles.paddingMedium,
        AppStyles.paddingMedium,
        AppStyles.paddingMedium,
        AppStyles.paddingMedium + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: AppStyles.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: AppStyles.accentColor,
            child: Text(
              'Y', // Represents 'You'
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: AppStyles.paddingSmall),
          Expanded(
            child: TextField(
              controller: _commentController,
              style: AppStyles.bodyStyle,
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                hintStyle: AppStyles.subtitleStyle,
                fillColor: AppStyles.backgroundColor,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppStyles.paddingSmall),
          CircleAvatar(
            radius: 22,
            backgroundColor: AppStyles.primaryColor,
            child: IconButton(
              onPressed: _addComment,
              icon: const Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  void _addComment() {
    if (_commentController.text.trim().isNotEmpty) {
      final newComment = {
        'username': 'You',
        'text': _commentController.text.trim(),
        'time': 'Just now', // Add a timestamp
      };

      setState(() {
        // Ensure the list exists before adding
        if (widget.post['commentsList'] == null) {
          widget.post['commentsList'] = [];
        }
        widget.post['commentsList'].add(newComment);
        widget.post['comments'] = (widget.post['comments'] ?? 0) + 1;
      });

      widget.onCommentAdded(widget.post);
      _commentController.clear();
      FocusScope.of(context).unfocus(); // Dismiss keyboard

      // Scroll to the bottom to show the new comment
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}