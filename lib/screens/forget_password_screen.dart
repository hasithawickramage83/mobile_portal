import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'pin_verification_screen.dart';

// --- Custom Colors ---
const Color _primaryPurple = Color(0xFF5D3E8E);
const Color _primaryOrange = Color(0xFFF58220);
const Color _secondaryOrange = Color(0xFFF2A332);

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<ForgetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendOtp() async {
    _navigatedVerificationCode();
    if (!_formKey.currentState!.validate()) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('user_email', _emailController.text.trim());
    setState(() => _isLoading = true);
    const String url = 'https://mindecho.afford-it.co.nz/api/resend-otp';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "email": _emailController.text.trim()
        }),
      );

      final Map<String, dynamic> result = jsonDecode(response.body);

      if (!mounted) return;

      if (response.statusCode == 200 && result['meta']['status'] == 200) {

        _showSuccessDialog("Otp sent successful for ${_emailController.text.trim()} ", navigate: true);
      } else {
        showErrorDialog(result['meta']['message'] ?? "Otp failed");
      }
    } catch (e) {
      if (!mounted) return;
      showErrorDialog("Something went wrong.\n${e.toString()}");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  void showErrorDialog(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // --- Success Dialog ---
  void _showSuccessDialog(String msg, {bool navigate = false}) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(msg),
        content: const Text("Send Otp successful"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (navigate) _navigatedVerificationCode();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }


  void _navigatedVerificationCode() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PinVerificationScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(color: const Color(0xFFF7F7F7)),

          // Bottom Curve
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: CustomLoginClipper(),
              child: Container(
                height: screenHeight * 0.35,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [_secondaryOrange, _primaryOrange],
                  ),
                ),
              ),
            ),
          ),

          // Main Content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 120),

                    // Title
                    const Text(
                      'Email Verification',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Description
                    const Text(
                      'Enter your email address to receive a verification PIN',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        border: UnderlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: _primaryPurple, width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 40),

                    // Send Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : () {
                          if (_formKey.currentState!.validate()) _sendOtp();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryPurple,
                          padding:
                          const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Send Verification Code',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------
// --- Custom Clipper for the bottom curve ---
// ------------------------------------------

class CustomLoginClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // 1. Start from the bottom left corner and go to bottom right
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);

    // 2. Move up to where the curve starts on the right
    path.lineTo(size.width, size.height * 0.60);

    // 3. Create the main outward/top curve section
    // Control Point 1 (far right, high up)
    path.quadraticBezierTo(
        size.width * 0.95,
        size.height * 0.40,
        size.width * 0.60,
        size.height * 0.50
    );

    // 4. Create the inner dip/scoop curve section
    // Control Point 2 (center, low dip)
    path.quadraticBezierTo(
        size.width * 0.45,
        size.height * 0.55,
        size.width * 0.35,
        size.height * 0.75
    );

    // 5. Create the final curve leading to the left edge
    // Control Point 3 (left side, mid height)
    path.quadraticBezierTo(
        size.width * 0.20,
        size.height * 0.85,
        0,
        size.height * 0.90
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomLoginClipper oldClipper) => false;
}