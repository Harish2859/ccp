import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/report_model.dart';
import '../services/report_service.dart';
import '../utils/map_utils.dart';
import 'report_page.dart';

class HazardMapPage extends StatefulWidget {
  const HazardMapPage({super.key});

  @override
  State<HazardMapPage> createState() => _HazardMapPageState();
}

class _HazardMapPageState extends State<HazardMapPage> {
  static const String apiKey = "D29EGmQHU7kYcqXzFuhd";
  String selectedFilter = 'All';
  final List<String> filterOptions = ['All', 'tsunami', 'storm_surge', 'flood', 'high_waves', 'unusual_tide'];
  double currentZoom = 5.0;
  final MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final reports = ReportService().reports;
    final filteredReports = selectedFilter == 'All' 
        ? reports 
        : reports.where((r) => r.hazardType == selectedFilter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hazard Map'),
        backgroundColor: const Color(0xFF023E8A),
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) => setState(() => selectedFilter = value),
            itemBuilder: (context) => filterOptions.map((filter) => 
              PopupMenuItem(value: filter, child: Text(filter == 'All' ? 'All Types' : _getHazardLabel(filter)))
            ).toList(),
          ),
        ],
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: LatLng(20.5937, 78.9629),
          initialZoom: 5.0,
          onPositionChanged: (position, hasGesture) {
            setState(() {
              currentZoom = position.zoom;
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate: "https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=$apiKey",
            userAgentPackageName: 'com.example.oceanpulse',
          ),
          MarkerLayer(
            markers: _buildMarkers(filteredReports),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openReportPage(context),
        backgroundColor: const Color(0xFF023E8A),
        child: const Icon(Icons.add, color: Colors.white),
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
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning, color: _getSeverityColor(report.severity)),
                const SizedBox(width: 8),
                Text(_getHazardLabel(report.hazardType), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text('Severity: ${report.severity}', style: TextStyle(color: _getSeverityColor(report.severity), fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(report.description),
            const SizedBox(height: 8),
            Text('Reported: ${_formatDateTime(report.timestamp)}', style: const TextStyle(color: Colors.grey)),
            if (report.mediaPaths.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('${report.mediaPaths.length} media file(s) attached'),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  List<Marker> _buildMarkers(List<Report> reports) {
    final clusters = MapUtils.clusterReports(reports, currentZoom);
    
    return clusters.map((cluster) {
      if (cluster.isCluster) {
        return Marker(
          point: LatLng(cluster.centerLat, cluster.centerLng),
          width: 50,
          height: 50,
          child: GestureDetector(
            onTap: () => _showClusterDetails(context, cluster),
            child: Container(
              decoration: BoxDecoration(
                color: _getSeverityColor(cluster.dominantSeverity),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Center(
                child: Text(
                  '${cluster.reports.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        );
      } else {
        final report = cluster.reports.first;
        return Marker(
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
        );
      }
    }).toList();
  }

  void _showClusterDetails(BuildContext context, ReportCluster cluster) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.group_work, color: Colors.orange),
                const SizedBox(width: 8),
                Text('${cluster.reports.length} Reports in this area', 
                     style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: cluster.reports.length,
                itemBuilder: (context, index) {
                  final report = cluster.reports[index];
                  return ListTile(
                    leading: Icon(Icons.warning, color: _getSeverityColor(report.severity)),
                    title: Text(_getHazardLabel(report.hazardType)),
                    subtitle: Text(report.description, maxLines: 1, overflow: TextOverflow.ellipsis),
                    trailing: Text(report.severity),
                    onTap: () {
                      Navigator.pop(context);
                      _showReportDetails(context, report);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
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