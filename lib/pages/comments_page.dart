import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.post['commentsList']?.length ?? 0,
              itemBuilder: (context, index) {
                final comment = widget.post['commentsList'][index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(comment['avatar'] ?? 'https://via.placeholder.com/40'),
                  ),
                  title: Text(comment['username'] ?? 'Anonymous'),
                  subtitle: Text(comment['text'] ?? ''),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _addComment,
                  icon: const Icon(Icons.send),
                ),
              ],
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
        'avatar': 'https://via.placeholder.com/40',
      };
      
      setState(() {
        widget.post['commentsList'] ??= [];
        widget.post['commentsList'].add(newComment);
        widget.post['comments'] = (widget.post['comments'] ?? 0) + 1;
      });
      
      widget.onCommentAdded(widget.post);
      _commentController.clear();
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}