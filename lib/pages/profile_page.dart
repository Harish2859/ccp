import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Sample user data
  String userName = "Sarah Johnson";
  String userEmail = "sarah.johnson@oceanpulse.org";
  String userRole = "Volunteer";
  File? _profileImage;
  String selectedLocation = "Miami, FL";
  bool gpsAutoDetect = true;
  bool darkMode = false;
  bool pushNotifications = true;
  bool smsNotifications = false;
  bool emailNotifications = true;
  String selectedLanguage = "English";

  
  final ImagePicker _picker = ImagePicker();

  // OceanPulse Color Palette
  static const Color deepBlue = Color(0xFF023E8A);
  static const Color aquaBlue = Color(0xFF0096C7);
  static const Color turquoise = Color(0xFF00B4D8);
  static const Color lightGray = Color(0xFFF8F9FA);
  static const Color darkNavy = Color(0xFF03045E);
  static const Color gray700 = Color(0xFF495057);
  static const Color coralOrange = Color(0xFFFF6F61);
  static const Color seaGreen = Color(0xFF2EC4B6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGray,
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: deepBlue,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => _showAdvancedSettings(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Section Card
            _buildProfileCard(),
            const SizedBox(height: 20),
            
            // Location Preference Section
            _buildLocationSection(),
            const SizedBox(height: 20),
            
            // Account Settings Section
            _buildAccountSettingsSection(),
            const SizedBox(height: 32),
            
            // Logout Button
            _buildLogoutButton(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Photo
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: turquoise,
                    backgroundImage: _profileImage != null 
                        ? FileImage(_profileImage!) 
                        : null,
                    child: _profileImage == null
                        ? const Icon(Icons.person, size: 50, color: Colors.white)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickProfileImage,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: aquaBlue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // User Info
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: darkNavy,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                userEmail,
                style: const TextStyle(
                  fontSize: 16,
                  color: gray700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: seaGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  userRole,
                  style: const TextStyle(
                    color: seaGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Edit Profile Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _editProfile(),
                  icon: const Icon(Icons.edit, color: Colors.white),
                  label: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: aquaBlue,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, color: turquoise, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Location Preferences',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: darkNavy,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Current Location Display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: lightGray,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: aquaBlue.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Location',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: gray700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        gpsAutoDetect ? Icons.gps_fixed : Icons.location_city,
                        color: gpsAutoDetect ? seaGreen : aquaBlue,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          gpsAutoDetect ? 'Auto-detected: $selectedLocation' : selectedLocation,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: darkNavy,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // GPS Auto-detect Switch
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: aquaBlue.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.gps_fixed,
                    color: gpsAutoDetect ? seaGreen : gray700,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'GPS Auto-detect',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: darkNavy,
                          ),
                        ),
                        Text(
                          gpsAutoDetect 
                              ? 'Automatically detect your location'
                              : 'Manually select your location',
                          style: const TextStyle(
                            fontSize: 12,
                            color: gray700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: gpsAutoDetect,
                    onChanged: (bool value) {
                      setState(() {
                        gpsAutoDetect = value;
                        if (value) {
                          _detectCurrentLocation();
                        }
                      });
                    },
                    activeColor: seaGreen,
                  ),
                ],
              ),
            ),
            
            // Manual Location Selection (only show when GPS is off)
            if (!gpsAutoDetect) ...[
              const SizedBox(height: 16),
              const Text(
                'Select Location Manually',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: gray700,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: aquaBlue),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedLocation,
                    icon: const Icon(Icons.arrow_drop_down, color: aquaBlue),
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: "Miami, FL", child: Text("Miami, FL")),
                      DropdownMenuItem(value: "San Diego, CA", child: Text("San Diego, CA")),
                      DropdownMenuItem(value: "New York, NY", child: Text("New York, NY")),
                      DropdownMenuItem(value: "Seattle, WA", child: Text("Seattle, WA")),
                      DropdownMenuItem(value: "Los Angeles, CA", child: Text("Los Angeles, CA")),
                      DropdownMenuItem(value: "Boston, MA", child: Text("Boston, MA")),
                    ],
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedLocation = newValue;
                        });
                        _saveLocationPreference(newValue);
                      }
                    },
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSettingsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: darkNavy,
              ),
            ),
            const SizedBox(height: 12),
            
            // Change Password
            _buildSettingTile(
              icon: Icons.lock,
              title: 'Change Password',
              subtitle: 'Update your account password',
              onTap: () => _navigateToChangePassword(),
            ),
            
            // Language Settings
            _buildSettingTile(
              icon: Icons.language,
              title: 'Change Language',
              subtitle: selectedLanguage,
              onTap: () => _showLanguageModal(),
            ),
            
            // Notification Preferences
            _buildSettingTile(
              icon: Icons.notifications,
              title: 'Notification Preferences',
              subtitle: 'Manage alert preferences',
              onTap: () => _showNotificationPreferences(),
            ),
            
            // Dark Mode
            ListTile(
              leading: const Icon(Icons.dark_mode, color: turquoise),
              title: const Text('Dark Mode'),
              subtitle: Text(darkMode ? 'Enabled' : 'Disabled'),
              trailing: Switch(
                value: darkMode,
                onChanged: (bool value) {
                  setState(() {
                    darkMode = value;
                  });
                  // TODO: Implement theme switching
                },
                activeColor: seaGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }





  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _logout(),
        icon: const Icon(Icons.logout, color: Colors.white),
        label: const Text(
          'Logout',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: coralOrange,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: turquoise),
      title: Text(title),
      subtitle: Text(subtitle, style: const TextStyle(color: gray700)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: gray700),
      onTap: onTap,
    );
  }



  // Location Methods
  void _detectCurrentLocation() {
    // Simulate GPS detection
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.gps_fixed, color: Colors.white),
            SizedBox(width: 8),
            Text('Detecting your location...'),
          ],
        ),
        backgroundColor: seaGreen,
        duration: const Duration(seconds: 2),
      ),
    );
    
    // Simulate location detection after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        selectedLocation = "Miami, FL"; // Simulated detected location
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Location detected successfully!'),
            ],
          ),
          backgroundColor: seaGreen,
          duration: Duration(seconds: 2),
        ),
      );
    });
  }
  
  void _saveLocationPreference(String location) {
    // Save location preference
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Location updated to $location'),
        backgroundColor: aquaBlue,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // Action Methods
  Future<void> _pickProfileImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 300,
      maxHeight: 300,
    );
    
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  void _editProfile() {
    // TODO: Navigate to edit profile page or show modal
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit Profile functionality coming soon')),
    );
  }

  void _navigateToChangePassword() {
    // TODO: Navigate to change password page
    Navigator.pushNamed(context, '/change_password');
  }

  void _navigateToMyReports() {
    // TODO: Navigate to my reports page
    Navigator.pushNamed(context, '/my_reports');
  }

  void _showLanguageModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Language',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: darkNavy,
                ),
              ),
              const SizedBox(height: 16),
              _buildLanguageOption('English'),
              _buildLanguageOption('Spanish'),
              _buildLanguageOption('French'),
              _buildLanguageOption('Portuguese'),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(String language) {
    return ListTile(
      title: Text(language),
      trailing: selectedLanguage == language 
          ? const Icon(Icons.check, color: seaGreen) 
          : null,
      onTap: () {
        setState(() {
          selectedLanguage = language;
        });
        Navigator.pop(context);
      },
    );
  }

  void _showNotificationPreferences() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Notification Preferences'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CheckboxListTile(
                    title: const Text('Push Notifications'),
                    value: pushNotifications,
                    onChanged: (bool? value) {
                      setState(() {
                        pushNotifications = value ?? false;
                      });
                    },
                    activeColor: seaGreen,
                  ),
                  CheckboxListTile(
                    title: const Text('SMS Notifications'),
                    value: smsNotifications,
                    onChanged: (bool? value) {
                      setState(() {
                        smsNotifications = value ?? false;
                      });
                    },
                    activeColor: seaGreen,
                  ),
                  CheckboxListTile(
                    title: const Text('Email Notifications'),
                    value: emailNotifications,
                    onChanged: (bool? value) {
                      setState(() {
                        emailNotifications = value ?? false;
                      });
                    },
                    activeColor: seaGreen,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAdvancedSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Advanced Settings'),
          content: const Text('Advanced settings panel coming soon!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showAchievements() {
    // TODO: Show achievements modal
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Achievements feature coming soon')),
    );
  }

  void _showFAQs() {
    // TODO: Navigate to FAQs page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('FAQs page coming soon')),
    );
  }

  void _contactSupport() {
    // TODO: Open contact support
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contact support feature coming soon')),
    );
  }

  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'OceanPulse',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.waves, color: turquoise, size: 48),
      children: const [
        Text('Protecting our oceans through community-driven monitoring and reporting.'),
      ],
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Clear session data
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(backgroundColor: coralOrange),
              child: const Text('Logout', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}