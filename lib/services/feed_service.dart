import '../models/alert.dart';

class FeedService {
  static final List<Map<String, dynamic>> _posts = [];

  static List<Map<String, dynamic>> getAll() => _posts;

  static void addPost(Alert alert) {
    final post = {
      'id': alert.id,
      'username': 'INCOIS Official',
      'userAvatar': 'IO',
      'timeAgo': 'Just now',
      'imagePath': alert.mediaPath ?? 'assets/images/default_alert.jpg',
      'title': alert.title,
      'description': alert.description,
      'location': alert.location,
      'likes': 0,
      'comments': 0,
      'shares': 0,
      'isLiked': false,
      'alertType': _mapSeverityToAlertType(alert.severity),
    };
    _posts.insert(0, post);
  }

  static String _mapSeverityToAlertType(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return 'critical';
      case 'high':
        return 'warning';
      case 'medium':
        return 'warning';
      case 'safe':
        return 'safe';
      default:
        return 'warning';
    }
  }
}