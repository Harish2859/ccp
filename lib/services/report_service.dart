import '../models/report_model.dart';

class ReportService {
  static final List<Report> _reports = [];

  static List<Report> getReports() => _reports;

  static void addReport(Report report) {
    _reports.add(report);
  }

  static void removeReport(String id) {
    _reports.removeWhere((report) => report.id == id);
  }

  static Report? getReportById(String id) {
    try {
      return _reports.firstWhere((report) => report.id == id);
    } catch (e) {
      return null;
    }
  }
}