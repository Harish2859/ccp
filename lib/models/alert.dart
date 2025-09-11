class Alert {
  final String id;
  final String title;
  final String description;
  final String hazardType;
  final String severity;
  final String location;
  final String? mediaPath;
  final DateTime timestamp;
  final List<String> deliveryMethods;

  Alert({
    required this.id,
    required this.title,
    required this.description,
    required this.hazardType,
    required this.severity,
    required this.location,
    this.mediaPath,
    required this.timestamp,
    required this.deliveryMethods,
  });
}

class AppNotification {
  final String id;
  final String type;
  final String title;
  final String message;
  final String location;
  final String severity;
  final DateTime timestamp;
  final Map<String, dynamic>? userData;

  AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.location,
    required this.severity,
    required this.timestamp,
    this.userData,
  });
}