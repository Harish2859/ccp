import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../models/report_model.dart';
import '../services/report_service.dart';
import 'report_page.dart';

class HazardMapPage extends StatefulWidget {
  final bool isOfficial;
  
  const HazardMapPage({super.key, this.isOfficial = false});

  @override
  State<HazardMapPage> createState() => _HazardMapPageState();
}

class _HazardMapPageState extends State<HazardMapPage> {
  static const String apiKey = "D29EGmQHU7kYcqXzFuhd";
  
  // Filter states
  String selectedHazardType = 'All';
  Set<String> selectedSeverities = {'Low', 'Medium', 'High'};
  DateTimeRange? selectedDateRange;
  bool isFiltersExpanded = false;
  
  final List<String> hazardTypes = ['All', 'tsunami', 'storm_surge', 'flood', 'high_waves', 'unusual_tide'];
  final List<String> severityLevels = ['Low', 'Medium', 'High'];
  
  final MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final reports = ReportService.getReports();
    final filteredReports = _applyFilters(reports);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hazard Map'),
        backgroundColor: const Color(0xFF023E8A),
        foregroundColor: Colors.white,
        actions: [
          if (widget.isOfficial)
            IconButton(
              icon: const Icon(Icons.file_download),
              onPressed: () => _exportData(filteredReports),
              tooltip: 'Export Data',
            ),
        ],
      ),
      body: Column(
        children: [
          _buildFiltersPanel(),
          Expanded(
            child: FlutterMap(
              mapController: mapController,
              options: const MapOptions(
                initialCenter: LatLng(20.5937, 78.9629),
                initialZoom: 5.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=$apiKey",
                  userAgentPackageName: 'com.example.oceanpulse',
                ),
                MarkerClusterLayerWidget(
                  options: MarkerClusterLayerOptions(
                    maxClusterRadius: 45,
                    size: const Size(40, 40),
                    markers: _buildMarkers(filteredReports),
                    builder: (context, markers) => _buildClusterMarker(markers),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: widget.isOfficial ? null : FloatingActionButton(
        onPressed: () => _openReportPage(context),
        backgroundColor: const Color(0xFF023E8A),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  List<Report> _applyFilters(List<Report> reports) {
    return reports.where((report) {
      // Hazard type filter
      if (selectedHazardType != 'All' && report.hazardType != selectedHazardType) {
        return false;
      }
      
      // Severity filter
      if (!selectedSeverities.contains(report.severity)) {
        return false;
      }
      
      // Date range filter
      if (selectedDateRange != null) {
        final reportDate = DateTime(report.timestamp.year, report.timestamp.month, report.timestamp.day);
        final startDate = DateTime(selectedDateRange!.start.year, selectedDateRange!.start.month, selectedDateRange!.start.day);
        final endDate = DateTime(selectedDateRange!.end.year, selectedDateRange!.end.month, selectedDateRange!.end.day);
        if (reportDate.isBefore(startDate) || reportDate.isAfter(endDate)) {
          return false;
        }
      }
      
      return true;
    }).toList();
  }

  Widget _buildFiltersPanel() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isFiltersExpanded ? 200 : 60,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.filter_list, color: Color(0xFF023E8A)),
            title: const Text('Filters', style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: Icon(isFiltersExpanded ? Icons.expand_less : Icons.expand_more),
            onTap: () => setState(() => isFiltersExpanded = !isFiltersExpanded),
          ),
          if (isFiltersExpanded)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedHazardType,
                            decoration: const InputDecoration(labelText: 'Hazard Type', border: OutlineInputBorder()),
                            items: hazardTypes.map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type == 'All' ? 'All Types' : _getHazardLabel(type)),
                            )).toList(),
                            onChanged: (value) => setState(() => selectedHazardType = value!),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _selectDateRange,
                            child: Text(selectedDateRange == null ? 'Select Date Range' : 
                              '${DateFormat('MMM dd').format(selectedDateRange!.start)} - ${DateFormat('MMM dd').format(selectedDateRange!.end)}'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Severity: ', style: TextStyle(fontWeight: FontWeight.bold)),
                        ...severityLevels.map((severity) => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: selectedSeverities.contains(severity),
                              onChanged: (checked) {
                                setState(() {
                                  if (checked!) {
                                    selectedSeverities.add(severity);
                                  } else {
                                    selectedSeverities.remove(severity);
                                  }
                                });
                              },
                            ),
                            Text(severity),
                            const SizedBox(width: 8),
                          ],
                        )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _resetFilters,
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                          child: const Text('Reset'),
                        ),
                        ElevatedButton(
                          onPressed: () => setState(() {}),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF023E8A)),
                          child: const Text('Apply'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }

  void _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: selectedDateRange,
    );
    if (picked != null) {
      setState(() => selectedDateRange = picked);
    }
  }

  void _resetFilters() {
    setState(() {
      selectedHazardType = 'All';
      selectedSeverities = {'Low', 'Medium', 'High'};
      selectedDateRange = null;
    });
  }

  Widget _buildClusterMarker(List<Marker> markers) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF023E8A),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Center(
        child: Text(
          '${markers.length}',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
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

  void _showReportDetails(BuildContext context, Report report) {
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
                  Expanded(child: Text(_getHazardLabel(report.hazardType), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                ],
              ),
              const SizedBox(height: 8),
              Text('Severity: ${report.severity}', style: TextStyle(color: _getSeverityColor(report.severity), fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text(report.description),
              const SizedBox(height: 8),
              Text('Location: ${report.lat.toStringAsFixed(4)}, ${report.lng.toStringAsFixed(4)}', style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 4),
              Text('Reported: ${_formatDateTime(report.timestamp)}', style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 4),
              Text('Status: ${report.status.toUpperCase()}', style: TextStyle(color: _getStatusColor(report.status), fontWeight: FontWeight.w600)),
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
                          child: Image.asset(
                            path,
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
              if (widget.isOfficial) ...[
                const SizedBox(height: 16),
                const Divider(),
                const Text('Validation Controls:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildValidationButton(
                      icon: Icons.check_circle,
                      label: 'Valid',
                      color: Colors.green,
                      onPressed: () => _updateReportStatus(report, 'valid'),
                    ),
                    _buildValidationButton(
                      icon: Icons.cancel,
                      label: 'False',
                      color: Colors.red,
                      onPressed: () => _updateReportStatus(report, 'false'),
                    ),
                    _buildValidationButton(
                      icon: Icons.priority_high,
                      label: 'Urgent',
                      color: Colors.orange,
                      onPressed: () => _updateReportStatus(report, 'urgent'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildValidationButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  void _updateReportStatus(Report report, String status) {
    ReportService.updateReportStatus(report, status);
    Navigator.pop(context);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Report marked as ${status.toUpperCase()}'),
        backgroundColor: _getStatusColor(status),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'valid': return Colors.green;
      case 'false': return Colors.red;
      case 'urgent': return Colors.orange;
      default: return Colors.grey;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  List<Marker> _buildMarkers(List<Report> reports) {
    return reports.map((report) => Marker(
      point: LatLng(report.lat, report.lng),
      width: 40,
      height: 40,
      child: GestureDetector(
        onTap: () => _showReportDetails(context, report),
        child: Icon(
          Icons.warning,
          color: _getSeverityColor(report.severity),
          size: 35,
        ),
      ),
    )).toList();
  }

  Future<void> _exportData(List<Report> reports) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final file = File('${directory.path}/hazard_reports_$timestamp.csv');
      
      List<List<dynamic>> csvData = [
        ['ID', 'Hazard Type', 'Description', 'Severity', 'Latitude', 'Longitude', 'Timestamp', 'Status']
      ];
      
      for (final report in reports) {
        csvData.add([
          report.id,
          report.hazardType,
          report.description,
          report.severity,
          report.lat,
          report.lng,
          report.timestamp.toIso8601String(),
          report.status,
        ]);
      }
      
      String csv = const ListToCsvConverter().convert(csvData);
      await file.writeAsString(csv);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data exported to ${file.path}'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }



  void _openReportPage(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ReportPage()),
    );
    if (result != null) {
      setState(() {}); // Refresh the map to show new report
    }
  }
}