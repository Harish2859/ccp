import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  
  // Step 1 controllers
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String _selectedGender = '';
  
  // Step 2 controllers
  final _aadharController = TextEditingController();
  final _mobileController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isOtpSent = false;
  
  // Step 3 controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  'Sign Up - Step ${_currentStep + 1} of 3',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 3,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
              ),
              _buildProgressIndicator(),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildStep1(),
                    _buildStep2(),
                    _buildStep3(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: List.generate(3, (index) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
              height: 4,
              decoration: BoxDecoration(
                color: index <= _currentStep ? const Color(0xFF1E3A8A) : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.8)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 4,
                      color: Colors.white,
                    ),
                    Shadow(
                      offset: Offset(-1, -1),
                      blurRadius: 2,
                      color: Colors.white70,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tell us about yourself',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 2,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildInputField(
                label: 'Full Name',
                controller: _nameController,
                hintText: 'Enter your full name',
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 20),
              _buildInputField(
                label: 'Age',
                controller: _ageController,
                hintText: 'Enter your age',
                prefixIcon: Icons.cake_outlined,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              const Text(
                'Gender',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 2,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildGenderOption('Male'),
                  const SizedBox(width: 12),
                  _buildGenderOption('Female'),
                  const SizedBox(width: 12),
                  _buildGenderOption('Other'),
                ],
              ),
              const SizedBox(height: 32),
              _buildNextButton(() => _validateStep1()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.8)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Verification',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 4,
                      color: Colors.white,
                    ),
                    Shadow(
                      offset: Offset(-1, -1),
                      blurRadius: 2,
                      color: Colors.white70,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Verify your identity with Aadhar',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 2,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildInputField(
                label: 'Aadhar Number',
                controller: _aadharController,
                hintText: 'Enter 12-digit Aadhar number',
                prefixIcon: Icons.credit_card,
                keyboardType: TextInputType.number,
                maxLength: 12,
              ),
              const SizedBox(height: 20),
              _buildInputField(
                label: 'Aadhar Linked Mobile',
                controller: _mobileController,
                hintText: 'Enter mobile number',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                maxLength: 10,
              ),
              const SizedBox(height: 20),
              if (!_isOtpSent)
                _buildSendOtpButton()
              else ...[
                _buildInputField(
                  label: 'OTP',
                  controller: _otpController,
                  hintText: 'Enter 6-digit OTP',
                  prefixIcon: Icons.security,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _sendOtp,
                  child: const Text(
                    'Resend OTP',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 2,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 32),
              _buildNextButton(() => _validateStep2()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.8)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Account Setup',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 4,
                      color: Colors.white,
                    ),
                    Shadow(
                      offset: Offset(-1, -1),
                      blurRadius: 2,
                      color: Colors.white70,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Create your login credentials',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 2,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildInputField(
                label: 'Email',
                controller: _emailController,
                hintText: 'Enter your email address',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              _buildInputField(
                label: 'Password',
                controller: _passwordController,
                hintText: 'Create a strong password',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                obscureText: _obscurePassword,
                onToggleVisibility: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              const SizedBox(height: 20),
              _buildInputField(
                label: 'Confirm Password',
                controller: _confirmPasswordController,
                hintText: 'Confirm your password',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                obscureText: _obscureConfirmPassword,
                onToggleVisibility: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
              const SizedBox(height: 32),
              _buildCompleteButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
    TextInputType? keyboardType,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            shadows: [
              Shadow(
                offset: Offset(1, 1),
                blurRadius: 2,
                color: Colors.white,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.5)),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            maxLength: maxLength,
            style: const TextStyle(color: Color(0xFF374151)),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
              prefixIcon: Icon(prefixIcon, color: const Color(0xFF6B7280)),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility : Icons.visibility_off,
                        color: const Color(0xFF6B7280),
                      ),
                      onPressed: onToggleVisibility,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              counterText: '',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderOption(String gender) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedGender = gender),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: _selectedGender == gender
                ? const Color(0xFF1E3A8A).withOpacity(0.1)
                : Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _selectedGender == gender
                  ? const Color(0xFF1E3A8A)
                  : Colors.white.withOpacity(0.5),
            ),
          ),
          child: Text(
            gender,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _selectedGender == gender
                  ? Colors.black87
                  : Colors.black87,
              fontWeight: FontWeight.w600,
              shadows: [
                Shadow(
                  offset: Offset(1, 1),
                  blurRadius: 2,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSendOtpButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _sendOtp,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E3A8A),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text(
          'Send OTP',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton(VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E3A8A),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text(
          'Next',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildCompleteButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _completeSignup,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E3A8A),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text(
          'Complete Registration',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _validateStep1() {
    if (_nameController.text.trim().isEmpty) {
      _showSnackBar('Please enter your name');
      return;
    }
    if (_ageController.text.trim().isEmpty) {
      _showSnackBar('Please enter your age');
      return;
    }
    if (_selectedGender.isEmpty) {
      _showSnackBar('Please select your gender');
      return;
    }
    _nextStep();
  }

  void _validateStep2() {
    if (_aadharController.text.length != 12) {
      _showSnackBar('Please enter valid 12-digit Aadhar number');
      return;
    }
    if (_mobileController.text.length != 10) {
      _showSnackBar('Please enter valid 10-digit mobile number');
      return;
    }
    if (!_isOtpSent) {
      _showSnackBar('Please send OTP first');
      return;
    }
    if (_otpController.text.length != 6) {
      _showSnackBar('Please enter valid 6-digit OTP');
      return;
    }
    _nextStep();
  }

  void _sendOtp() {
    if (_aadharController.text.length != 12) {
      _showSnackBar('Please enter valid Aadhar number');
      return;
    }
    if (_mobileController.text.length != 10) {
      _showSnackBar('Please enter valid mobile number');
      return;
    }
    
    setState(() {
      _isOtpSent = true;
    });
    _showSnackBar('OTP sent to your mobile number');
  }

  void _completeSignup() {
    if (_emailController.text.trim().isEmpty || !_emailController.text.contains('@')) {
      _showSnackBar('Please enter valid email');
      return;
    }
    if (_passwordController.text.length < 6) {
      _showSnackBar('Password must be at least 6 characters');
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      _showSnackBar('Passwords do not match');
      return;
    }
    
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
      (route) => false,
    );
  }

  void _nextStep() {
    setState(() {
      _currentStep++;
    });
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF1E3A8A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _aadharController.dispose();
    _mobileController.dispose();
    _otpController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}