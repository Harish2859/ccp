class ActivityLog {
  final String id;
  final String type; // 'validated_report', 'sent_alert', 'false_report'
  final String description;
  final DateTime timestamp;

  ActivityLog({
    required this.id,
    required this.type,
    required this.description,
    required this.timestamp,
  });
}