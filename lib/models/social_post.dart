class SocialPost {
  final String username;
  final String content;
  final String region;
  final String sentiment;
  final DateTime timestamp;
  final String? location;
  final int likes;
  final int retweets;

  SocialPost({
    required this.username,
    required this.content,
    required this.region,
    required this.sentiment,
    required this.timestamp,
    this.location,
    this.likes = 0,
    this.retweets = 0,
  });
}