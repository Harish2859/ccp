import 'package:flutter/material.dart';
import 'dart:io';
import 'package:latlong2/latlong.dart';
import '../models/report_model.dart';
import '../services/report_service.dart';
import 'location_picker_page.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  
  // Form data
  String? selectedHazardType;
  String selectedSeverity = 'Medium';
  String description = '';
  List<File> attachedMedia = [];
  Map<String, double>? currentLocation;
  bool isLocationCaptured = false;
  bool isOnline = true; // This would be determined by connectivity check
  bool isSubmitting = false;

  // Hazard types with emojis
  final List<Map<String, String>> hazardTypes = [
    {'value': 'tsunami', 'label': 'Tsunami 🌊', 'emoji': '🌊'},
    {'value': 'storm_surge', 'label': 'Storm Surge 🌪️', 'emoji': '🌪️'},
    {'value': 'flood', 'label': 'Flood 🌧️', 'emoji': '🌧️'},
    {'value': 'high_waves', 'label': 'High Waves 🌊', 'emoji': '🌊'},
    {'value': 'unusual_tide', 'label': 'Unusual Tide 🌐', 'emoji': '🌐'},
  ];

  final List<String> severityLevels = ['Low', 'Medium', 'High'];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildSubmitButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF023E8A), // Deep Blue
      elevation: 0,
      title: const Text(
        'Report Hazard',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        // Online/Offline indicator
        Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isOnline ? const Color(0xFF52B788) : const Color(0xFF495057),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isOnline ? Icons.wifi : Icons.wifi_off,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                isOnline ? 'Online' : 'Offline',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Offline mode banner
            if (!isOnline) _buildOfflineBanner(),
            
            // Emergency notice
            _buildEmergencyNotice(),
            
            const SizedBox(height: 24),
            
            // Hazard type dropdown
            _buildHazardTypeDropdown(),
            
            const SizedBox(height: 20),
            
            // Description box
            _buildDescriptionField(),
            
            const SizedBox(height: 20),
            
            // Media upload section
            _buildMediaUploadSection(),
            
            const SizedBox(height: 20),
            
            // Location section
            _buildLocationSection(),
            
            const SizedBox(height: 20),
            
            // Severity selector
            _buildSeveritySelector(),
            
            const SizedBox(height: 100), // Space for bottom button
          ],
        ),
      ),
    );
  }

  Widget _buildOfflineBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF495057).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF495057).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.offline_bolt,
            color: Color(0xFF495057),
            size: 20,
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'You\'re offline. Report will be saved locally and synced when connection is restored.',
              style: TextStyle(
                color: Color(0xFF495057),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyNotice() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFD00000).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD00000).withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.emergency,
            color: Color(0xFFD00000),
            size: 24,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Emergency?',
                  style: TextStyle(
                    color: Color(0xFFD00000),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'For immediate emergencies, call Coast Guard: 1093 or Emergency Services: 108',
                  style: TextStyle(
                    color: Color(0xFF495057),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHazardTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hazard Type *',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF03045E),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF0096C7).withOpacity(0.3)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedHazardType,
              hint: const Text(
                'Select hazard type',
                style: TextStyle(color: Color(0xFF495057)),
              ),
              isExpanded: true,
              items: hazardTypes.map((hazard) {
                return DropdownMenuItem<String>(
                  value: hazard['value'],
                  child: Text(
                    hazard['label']!,
                    style: const TextStyle(
                      color: Color(0xFF03045E),
                      fontSize: 16,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedHazardType = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description *',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF03045E),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF0096C7).withOpacity(0.3)),
          ),
          child: TextFormField(
            controller: _descriptionController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Describe what you observed (e.g., wave height, water level, damage, etc.)',
              hintStyle: TextStyle(color: Color(0xFF495057)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please provide a description';
              }
              if (value.trim().length < 10) {
                return 'Please provide more details (at least 10 characters)';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                description = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMediaUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Photos/Videos (Optional)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF03045E),
          ),
        ),
        const SizedBox(height: 8),
        
        // Upload buttons
        Row(
          children: [
            Expanded(
              child: _buildMediaButton(
                icon: Icons.camera_alt,
                label: 'Take Photo',
                onTap: _takePhoto,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMediaButton(
                icon: Icons.videocam,
                label: 'Record Video',
                onTap: _recordVideo,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMediaButton(
                icon: Icons.photo_library,
                label: 'From Gallery',
                onTap: _pickFromGallery,
              ),
            ),
          ],
        ),
        
        // Media preview
        if (attachedMedia.isNotEmpty) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: attachedMedia.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 80,
                  height: 80,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF0096C7).withOpacity(0.3)),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          attachedMedia[index].path.contains('.mp4') 
                              ? Icons.play_circle_outline 
                              : Icons.image,
                          color: const Color(0xFF0096C7),
                          size: 32,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removeMedia(index),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Color(0xFFD00000),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMediaButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF00B4D8).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF00B4D8).withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: const Color(0xFF00B4D8),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF00B4D8),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Location',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF03045E),
          ),
        ),
        const SizedBox(height: 8),
        
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF0096C7).withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    isLocationCaptured ? Icons.location_on : Icons.location_off,
                    color: isLocationCaptured ? const Color(0xFF52B788) : const Color(0xFF495057),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isLocationCaptured 
                          ? 'Location captured automatically'
                          : 'Location not available',
                      style: TextStyle(
                        color: isLocationCaptured ? const Color(0xFF52B788) : const Color(0xFF495057),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              if (currentLocation != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Lat: ${currentLocation!['latitude']!.toStringAsFixed(6)}, '
                  'Lng: ${currentLocation!['longitude']!.toStringAsFixed(6)}',
                  style: const TextStyle(
                    color: Color(0xFF495057),
                    fontSize: 12,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _getCurrentLocation,
                      icon: const Icon(Icons.my_location, size: 18),
                      label: const Text('Refresh Location'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0096C7),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pinOnMap,
                      icon: const Icon(Icons.map, size: 18),
                      label: const Text('Pin on Map'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF0096C7),
                        side: const BorderSide(color: Color(0xFF0096C7)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSeveritySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Severity Level *',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF03045E),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: severityLevels.map((severity) {
            bool isSelected = selectedSeverity == severity;
            Color severityColor = _getSeverityColor(severity);
            
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => selectedSeverity = severity),
                child: Container(
                  margin: EdgeInsets.only(
                    right: severity != severityLevels.last ? 8 : 0,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: isSelected ? severityColor.withOpacity(0.1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? severityColor : const Color(0xFF495057).withOpacity(0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _getSeverityIcon(severity),
                        color: isSelected ? severityColor : const Color(0xFF495057),
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        severity,
                        style: TextStyle(
                          color: isSelected ? severityColor : const Color(0xFF495057),
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFF8F9FA)),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isSubmitting ? null : _submitReport,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF023E8A),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: isSubmitting
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Submitting...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              : Text(
                  isOnline ? 'Submit Report' : 'Save Report (Offline)',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'High':
        return const Color(0xFFD00000); // Red
      case 'Medium':
        return const Color(0xFFFF6F61); // Coral Orange
      case 'Low':
        return const Color(0xFF0096C7); // Aqua Blue
      default:
        return const Color(0xFF495057); // Gray
    }
  }

  IconData _getSeverityIcon(String severity) {
    switch (severity) {
      case 'High':
        return Icons.error;
      case 'Medium':
        return Icons.warning;
      case 'Low':
        return Icons.info;
      default:
        return Icons.help;
    }
  }

  void _takePhoto() {
    // Implement camera functionality
    // This would use image_picker package
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Camera functionality would be implemented here')),
    );
  }

  void _recordVideo() {
    // Implement video recording functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Video recording functionality would be implemented here')),
    );
  }

  void _pickFromGallery() {
    // Implement gallery picker functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Gallery picker functionality would be implemented here')),
    );
  }

  void _removeMedia(int index) {
    setState(() {
      attachedMedia.removeAt(index);
    });
  }

  void _getCurrentLocation() async {
    // Implement location services
    // This would use geolocator package
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    setState(() {
      currentLocation = {
        'latitude': 11.0168, // Example coordinates for Chennai
        'longitude': 76.9558,
      };
      isLocationCaptured = true;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Location captured successfully'),
        backgroundColor: Color(0xFF52B788),
      ),
    );
  }

  void _pinOnMap() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPickerPage(
          initialLocation: currentLocation != null 
              ? LatLng(currentLocation!['latitude']!, currentLocation!['longitude']!)
              : null,
        ),
      ),
    );
    
    if (result != null && result is LatLng) {
      setState(() {
        currentLocation = {
          'latitude': result.latitude,
          'longitude': result.longitude,
        };
        isLocationCaptured = true;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location selected from map'),
          backgroundColor: Color(0xFF52B788),
        ),
      );
    }
  }

  void _checkConnectivity() {
    // Implement connectivity check
    // This would use connectivity_plus package
    setState(() {
      isOnline = true; // For demo purposes
    });
  }

  void _submitReport() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedHazardType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a hazard type'),
          backgroundColor: Color(0xFFFF6F61),
        ),
      );
      return;
    }
    if (currentLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please capture location first'),
          backgroundColor: Color(0xFFFF6F61),
        ),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Create Report object
    final newReport = Report(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      hazardType: selectedHazardType!,
      description: _descriptionController.text.trim(),
      severity: selectedSeverity,
      lat: currentLocation!['latitude']!,
      lng: currentLocation!['longitude']!,
      mediaPaths: attachedMedia.map((file) => file.path).toList(),
      timestamp: DateTime.now(),
    );

    // Add to global service
    ReportService().addReport(newReport);

    setState(() {
      isSubmitting = false;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Report submitted successfully!'),
        backgroundColor: Color(0xFF2EC4B6),
      ),
    );

    // Return the report to the calling page
    Navigator.pop(context, newReport);
  }

  void _submitToServer(Map<String, dynamic> reportData) {
    // Implement API submission
    print('Submitting to server: $reportData');
  }

  void _saveLocally(Map<String, dynamic> reportData) {
    // Implement local storage (SharedPreferences, SQLite, etc.)
    print('Saving locally: $reportData');
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}