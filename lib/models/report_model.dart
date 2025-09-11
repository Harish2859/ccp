class Report {
  final String id;
  final String hazardType;
  final String description;
  final String severity;
  final double lat;
  final double lng;
  final List<String> mediaPaths;
  final DateTime timestamp;

  Report({
    required this.id,
    required this.hazardType,
    required this.description,
    required this.severity,
    required this.lat,
    required this.lng,
    required this.mediaPaths,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hazardType': hazardType,
      'description': description,
      'severity': severity,
      'lat': lat,
      'lng': lng,
      'mediaPaths': mediaPaths,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'],
      hazardType: json['hazardType'],
      description: json['description'],
      severity: json['severity'],
      lat: json['lat'].toDouble(),
      lng: json['lng'].toDouble(),
      mediaPaths: List<String>.from(json['mediaPaths']),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}