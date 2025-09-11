import 'dart:math';
import '../models/report_model.dart';

class MapUtils {
  static List<ReportCluster> clusterReports(List<Report> reports, double zoomLevel) {
    if (reports.isEmpty) return [];
    
    final clusters = <ReportCluster>[];
    final processed = List<bool>.filled(reports.length, false);
    final clusterRadius = _getClusterRadius(zoomLevel);
    
    for (int i = 0; i < reports.length; i++) {
      if (processed[i]) continue;
      
      final cluster = ReportCluster(
        centerLat: reports[i].lat,
        centerLng: reports[i].lng,
        reports: [reports[i]],
      );
      
      processed[i] = true;
      
      // Find nearby reports
      for (int j = i + 1; j < reports.length; j++) {
        if (processed[j]) continue;
        
        final distance = _calculateDistance(
          reports[i].lat, reports[i].lng,
          reports[j].lat, reports[j].lng,
        );
        
        if (distance <= clusterRadius) {
          cluster.reports.add(reports[j]);
          processed[j] = true;
        }
      }
      
      clusters.add(cluster);
    }
    
    return clusters;
  }
  
  static double _getClusterRadius(double zoomLevel) {
    // Adjust clustering radius based on zoom level
    if (zoomLevel < 8) return 50.0; // km
    if (zoomLevel < 12) return 10.0; // km
    return 2.0; // km
  }
  
  static double _calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    const double earthRadius = 6371; // km
    
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLng = _degreesToRadians(lng2 - lng1);
    
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) * cos(_degreesToRadians(lat2)) *
        sin(dLng / 2) * sin(dLng / 2);
    
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    
    return earthRadius * c;
  }
  
  static double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }
}

class ReportCluster {
  final double centerLat;
  final double centerLng;
  final List<Report> reports;
  
  ReportCluster({
    required this.centerLat,
    required this.centerLng,
    required this.reports,
  });
  
  bool get isCluster => reports.length > 1;
  
  String get dominantSeverity {
    final severityCount = <String, int>{};
    for (final report in reports) {
      severityCount[report.severity] = (severityCount[report.severity] ?? 0) + 1;
    }
    
    String dominant = 'Low';
    int maxCount = 0;
    
    for (final entry in severityCount.entries) {
      if (entry.value > maxCount) {
        maxCount = entry.value;
        dominant = entry.key;
      }
    }
    
    return dominant;
  }
}