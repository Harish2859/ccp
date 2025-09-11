import '../models/report_model.dart';

class ReportService {
  static final ReportService _instance = ReportService._internal();
  factory ReportService() => _instance;
  ReportService._internal();

  final List<Report> _reports = [];

  List<Report> get reports => List.unmodifiable(_reports);

  void addReport(Report report) {
    _reports.add(report);
  }

  void removeReport(String id) {
    _reports.removeWhere((report) => report.id == id);
  }

  Report? getReportById(String id) {
    try {
      return _reports.firstWhere((report) => report.id == id);
    } catch (e) {
      return null;
    }
  }
}