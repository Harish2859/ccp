import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/alert.dart';
import '../services/alert_service.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({Key? key}) : super(key: key);

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String _selectedHazardType = 'Flood 🌧';
  String _selectedSeverity = 'Critical';
  String _selectedLocation = 'Auto detect (GPS)';
  String? _selectedMediaPath;
  List<String> _selectedDeliveryMethods = ['Push Notification'];

  final List<String> _hazardTypes = [
    'Flood 🌧',
    'Tsunami 🌊',
    'Cyclone 🌪',
    'High Waves 🌊'
  ];

  final List<String> _severityLevels = ['Critical', 'High', 'Medium', 'Safe'];
  final List<String> _deliveryOptions = ['Push Notification', 'SMS', 'Email'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormSection(),
                    const SizedBox(height: 24),
                    _buildSubmitButton(),
                    const SizedBox(height: 32),
                    _buildPastAlertsSection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF023E8A),
      elevation: 0,
      title: const Text(
        'Alerts & Announcements',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        TextButton(
          onPressed: _showAlertHistory,
          child: const Text(
            'History',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Create New Alert',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF03045E)),
        ),
        const SizedBox(height: 16),
        _buildTextField('Topic / Title', _titleController, 'Enter alert title'),
        const SizedBox(height: 16),
        _buildTextField('Description', _descriptionController, 'Enter detailed message', maxLines: 4),
        const SizedBox(height: 16),
        _buildHazardTypeDropdown(),
        const SizedBox(height: 16),
        _buildSeveritySelector(),
        const SizedBox(height: 16),
        _buildLocationPicker(),
        const SizedBox(height: 16),
        _buildMediaUploader(),
        const SizedBox(height: 16),
        _buildDeliveryOptions(),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF03045E))),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF023E8A)),
            ),
          ),
          validator: (value) => value?.isEmpty == true ? 'This field is required' : null,
        ),
      ],
    );
  }

  Widget _buildHazardTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Hazard Type', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF03045E))),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedHazardType,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          items: _hazardTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
          onChanged: (value) => setState(() => _selectedHazardType = value!),
        ),
      ],
    );
  }

  Widget _buildSeveritySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Severity', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF03045E))),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _severityLevels.map((severity) {
            final isSelected = _selectedSeverity == severity;
            final color = _getSeverityColor(severity);
            return ChoiceChip(
              label: Text(severity, style: TextStyle(color: isSelected ? Colors.white : color)),
              selected: isSelected,
              selectedColor: color,
              onSelected: (selected) => setState(() => _selectedSeverity = severity),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLocationPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Location', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF03045E))),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.location_on, color: Color(0xFF0096C7)),
              const SizedBox(width: 8),
              Text(_selectedLocation),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // Open location picker
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Location picker coming soon...')),
                  );
                },
                child: const Text('Change'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMediaUploader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Attach Image/Video', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF03045E))),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickMedia,
          child: Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(8),
            ),
            child: _selectedMediaPath != null
                ? Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/placeholder.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedMediaPath = null),
                          child: const CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.red,
                            child: Icon(Icons.close, size: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Tap to add image/video', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Delivery Options', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF03045E))),
        const SizedBox(height: 8),
        ..._deliveryOptions.map((option) {
          return CheckboxListTile(
            title: Text(option),
            value: _selectedDeliveryMethods.contains(option),
            onChanged: (checked) {
              setState(() {
                if (checked == true) {
                  _selectedDeliveryMethods.add(option);
                } else {
                  _selectedDeliveryMethods.remove(option);
                }
              });
            },
            activeColor: const Color(0xFF023E8A),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _sendAlert,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF023E8A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text('Send Alert', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildPastAlertsSection() {
    final alerts = AlertService.getAll();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recent Alerts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF03045E))),
        const SizedBox(height: 12),
        if (alerts.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text('No alerts sent yet', style: TextStyle(color: Colors.grey)),
            ),
          )
        else
          ...alerts.take(3).map((alert) => _buildAlertCard(alert)).toList(),
      ],
    );
  }

  Widget _buildAlertCard(Alert alert) {
    final color = _getSeverityColor(alert.severity);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              alert.severity.toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(alert.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(alert.location, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                Text(_formatTime(alert.timestamp), style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
        ],
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical': return const Color(0xFFD00000);
      case 'high': return const Color(0xFFFF6F61);
      case 'medium': return const Color(0xFF0096C7);
      case 'safe': return const Color(0xFF52B788);
      default: return const Color(0xFF495057);
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  void _pickMedia() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _selectedMediaPath = image.path);
    }
  }

  void _sendAlert() {
    if (_formKey.currentState?.validate() != true) return;
    if (_selectedDeliveryMethods.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one delivery method')),
      );
      return;
    }

    final alert = Alert(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      description: _descriptionController.text,
      hazardType: _selectedHazardType,
      severity: _selectedSeverity,
      location: _selectedLocation,
      mediaPath: _selectedMediaPath,
      timestamp: DateTime.now(),
      deliveryMethods: _selectedDeliveryMethods,
    );

    AlertService.addAlert(alert);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Alert sent successfully!'),
        backgroundColor: Color(0xFF2EC4B6),
      ),
    );

    _clearForm();
  }

  void _clearForm() {
    _titleController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedHazardType = 'Flood 🌧';
      _selectedSeverity = 'Critical';
      _selectedLocation = 'Auto detect (GPS)';
      _selectedMediaPath = null;
      _selectedDeliveryMethods = ['Push Notification'];
    });
  }

  void _showAlertHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AlertHistoryPage(),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}

class AlertHistoryPage extends StatelessWidget {
  const AlertHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final alerts = AlertService.getAll();
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF023E8A),
        title: const Text('Alert History', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: alerts.isEmpty
          ? const Center(child: Text('No alerts found'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: alerts.length,
              itemBuilder: (context, index) {
                final alert = alerts[index];
                return _buildHistoryCard(context, alert);
              },
            ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, Alert alert) {
    final color = _getSeverityColor(alert.severity);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  alert.severity.toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              const Icon(Icons.check_circle, color: Colors.green, size: 20),
              const SizedBox(width: 4),
              const Text('Delivered', style: TextStyle(color: Colors.green, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          Text(alert.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(alert.description, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Color(0xFF0096C7)),
              const SizedBox(width: 4),
              Text(alert.location, style: const TextStyle(color: Color(0xFF0096C7), fontSize: 12)),
              const Spacer(),
              Text(_formatTime(alert.timestamp), style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical': return const Color(0xFFD00000);
      case 'high': return const Color(0xFFFF6F61);
      case 'medium': return const Color(0xFF0096C7);
      case 'safe': return const Color(0xFF52B788);
      default: return const Color(0xFF495057);
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}