class SocialPost {
  final String username;
  final String content;
  final String region;
  final String sentiment;
  final DateTime timestamp;
  final String? location;
  final int likes;
  final int retweets;
  String status; // pending, relevant, false, verify

  SocialPost({
    required this.username,
    required this.content,
    required this.region,
    required this.sentiment,
    required this.timestamp,
    this.location,
    this.likes = 0,
    this.retweets = 0,
    this.status = 'pending',
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'content': content,
      'region': region,
      'sentiment': sentiment,
      'timestamp': timestamp.toIso8601String(),
      'location': location,
      'likes': likes,
      'retweets': retweets,
      'status': status,
    };
  }
}