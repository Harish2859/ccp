import '../models/alert.dart';
import 'notification_service.dart';
import 'feed_service.dart';

class AlertService {
  static final List<Alert> _alerts = [];

  static List<Alert> getAll() => _alerts;

  static void addAlert(Alert alert) {
    _alerts.insert(0, alert);

    // Add to Notifications
    NotificationService.addNotification(
      AppNotification(
        id: alert.id,
        type: 'official_alert',
        title: alert.title,
        message: alert.description,
        location: alert.location,
        severity: alert.severity,
        timestamp: alert.timestamp,
        userData: {'username': 'INCOIS_Official', 'avatar': 'IO'},
      ),
    );

    // Add to Feed
    FeedService.addPost(alert);
  }
}