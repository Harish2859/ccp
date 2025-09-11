import 'package:flutter/material.dart';
import 'dart:io';
import '../models/report_model.dart';
import '../services/report_service.dart';

class MyReportsPage extends StatefulWidget {
  const MyReportsPage({super.key});

  @override
  State<MyReportsPage> createState() => _MyReportsPageState();
}

class _MyReportsPageState extends State<MyReportsPage> {
  @override
  Widget build(BuildContext context) {
    final reports = ReportService.getReports();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reports'),
        backgroundColor: const Color(0xFF023E8A),
        foregroundColor: Colors.white,
      ),
      body: reports.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reports.length,
              itemBuilder: (context, index) => _buildReportCard(reports[index]),
            ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'No reports yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Submit your first hazard report to see it here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(Report report) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning,
                color: _getSeverityColor(report.severity),
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _getHazardLabel(report.hazardType),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getSeverityColor(report.severity).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  report.severity,
                  style: TextStyle(
                    color: _getSeverityColor(report.severity),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            report.description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                _formatDateTime(report.timestamp),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.location_on, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                '${report.lat.toStringAsFixed(4)}, ${report.lng.toStringAsFixed(4)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          if (report.mediaPaths.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.attachment, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${report.mediaPaths.length} media file(s)',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => _showReportDetails(report),
                  child: const Text('View Details'),
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => _showReportDetails(report),
                child: const Text('View Details'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'High': return const Color(0xFFD00000);
      case 'Medium': return const Color(0xFFFF6F61);
      case 'Low': return const Color(0xFF0096C7);
      default: return const Color(0xFF495057);
    }
  }

  String _getHazardLabel(String hazardType) {
    const labels = {
      'tsunami': 'Tsunami 🌊',
      'storm_surge': 'Storm Surge 🌪️',
      'flood': 'Flood 🌧️',
      'high_waves': 'High Waves 🌊',
      'unusual_tide': 'Unusual Tide 🌐',
    };
    return labels[hazardType] ?? hazardType;
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _showReportDetails(Report report) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.warning, color: _getSeverityColor(report.severity)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _getHazardLabel(report.hazardType),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Severity: ${report.severity}',
                style: TextStyle(
                  color: _getSeverityColor(report.severity),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(report.description),
              const SizedBox(height: 8),
              Text(
                'Reported: ${_formatDateTime(report.timestamp)}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                'Location: ${report.lat.toStringAsFixed(6)}, ${report.lng.toStringAsFixed(6)}',
                style: const TextStyle(color: Colors.grey),
              ),
              if (report.mediaPaths.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text('Media:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...report.mediaPaths.map((path) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: path.toLowerCase().endsWith('.mp4') || path.toLowerCase().endsWith('.mov')
                      ? Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Icon(Icons.play_circle_outline, color: Colors.white, size: 50),
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(path),
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: 200,
                              color: Colors.grey[300],
                              child: const Center(child: Icon(Icons.error)),
                            ),
                          ),
                        ),
                )),
              ],
            ],
          ),
        ),
      ),
    );
  }
}