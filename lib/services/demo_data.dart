import '../models/report_model.dart';
import 'report_service.dart';

class DemoData {
  static void loadDemoReports() {
    // Add some demo reports for testing
    final demoReports = [
      Report(
        id: 'demo1',
        hazardType: 'tsunami',
        description: 'Unusual wave patterns observed near the coast. Water level rising rapidly.',
        severity: 'High',
        lat: 13.0827,
        lng: 80.2707,
        mediaPaths: [],
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Report(
        id: 'demo2',
        hazardType: 'storm_surge',
        description: 'Strong winds and high waves hitting the shoreline.',
        severity: 'Medium',
        lat: 15.2993,
        lng: 74.1240,
        mediaPaths: [],
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      Report(
        id: 'demo3',
        hazardType: 'flood',
        description: 'Coastal flooding in low-lying areas. Roads are waterlogged.',
        severity: 'Medium',
        lat: 11.0168,
        lng: 76.9558,
        mediaPaths: [],
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      Report(
        id: 'demo4',
        hazardType: 'high_waves',
        description: 'Waves reaching 3-4 meters in height. Fishing boats advised to stay ashore.',
        severity: 'Low',
        lat: 13.1000,
        lng: 80.3000,
        mediaPaths: [],
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    ];
    
    for (final report in demoReports) {
      ReportService.addReport(report);
    }
  }
}