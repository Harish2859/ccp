import '../models/alert.dart';

class NotificationService {
  static final List<AppNotification> _notifications = [];

  static List<AppNotification> getAll() => _notifications;

  static void addNotification(AppNotification notification) {
    _notifications.insert(0, notification);
  }
}