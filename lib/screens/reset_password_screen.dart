import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

// --- Custom Colors ---
const Color _primaryPurple = Color(0xFF5D3E8E);
const Color _primaryOrange = Color(0xFFF58220);
const Color _secondaryOrange = Color(0xFFF2A332);

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final TextEditingController _newPasswordController =
  TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  Future<void> _resetPassword() async {
    final prefs = await SharedPreferences.getInstance();

    final emailAdd = prefs.getString('user_email') ?? '';
    final otp = prefs.getString('user_otp') ?? '';
    showErrorDialog("emailAdd");
    debugPrint("Email: $emailAdd");
    _navigateLogin();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    const String url = 'https://mindecho.afford-it.co.nz/api/resend-otp';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "email":  emailAdd,
          "otp":otp,
          "password": _newPasswordController.text.trim(),
          "password_confirmation":_confirmPasswordController.text.trim()
        }),
      );

      final Map<String, dynamic> result = jsonDecode(response.body);

      if (!mounted) return;

      if (response.statusCode == 200 && result['meta']['status'] == 200) {
        _navigateLogin();

      } else {
        showErrorDialog(result['meta']['message'] ?? "failed");
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


  void _navigateLogin() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
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

                    const Text(
                      'Reset Password',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Create a new secure password',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 40),

                    // --- New Password ---
                    TextFormField(
                      controller: _newPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'New Password',
                        border: UnderlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: _primaryPurple, width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 6) {
                          return 'Minimum 6 characters';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // --- Confirm Password ---
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Confirm New Password',
                        border: UnderlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: _primaryPurple, width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirm your password';
                        }
                        if (value != _newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 40),

                    // --- Reset Button ---
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _resetPassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryPurple,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Reset Password',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
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
// --- Reused Custom Clipper ---
// ------------------------------------------

class CustomLoginClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height * 0.60);

    path.quadraticBezierTo(
        size.width * 0.95,
        size.height * 0.40,
        size.width * 0.60,
        size.height * 0.50);

    path.quadraticBezierTo(
        size.width * 0.45,
        size.height * 0.55,
        size.width * 0.35,
        size.height * 0.75);

    path.quadraticBezierTo(
        size.width * 0.20,
        size.height * 0.85,
        0,
        size.height * 0.90);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomLoginClipper oldClipper) => false;
}
