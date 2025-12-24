import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'reset_password_screen.dart';

// --- Custom Colors ---
const Color _primaryPurple = Color(0xFF5D3E8E);
const Color _primaryOrange = Color(0xFFF58220);
const Color _secondaryOrange = Color(0xFFF2A332);

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({super.key});

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String pinValue = "";
  TextEditingController pinController = TextEditingController();
  bool _isLoading = false;
  Future<void> _verifyPin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_otp',pinController.text.trim());
    final emailAdd = prefs.getString('user_email') ?? '';
    showErrorDialog("emailAdd");
    debugPrint("Email: $emailAdd");
    _navigateReset();
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
          "otp": pinController.text.trim()
        }),
      );

      final Map<String, dynamic> result = jsonDecode(response.body);

      if (!mounted) return;

      if (response.statusCode == 200 && result['meta']['status'] == 200) {
        _navigateReset();

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

  void _navigateReset() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ResetPasswordScreen(),
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

                    const Text(
                      'Verify PIN',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Enter the 6-digit code sent to you',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 40),

                    // --- PIN Input ---
                    PinCodeTextField(
                      controller: pinController,
                      appContext: context,
                      length: 6,
                      keyboardType: TextInputType.number,
                      animationType: AnimationType.fade,
                      cursorColor: _primaryPurple,
                      enableActiveFill: true,
                      animationDuration:
                      const Duration(milliseconds: 300),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter the PIN";
                        }
                        if (value.length < 6) {
                          return "PIN must be 6 digits";
                        }
                        return null;
                      },

                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(8),
                        fieldHeight: 50,
                        fieldWidth: 45,
                        activeColor: _primaryPurple,
                        selectedColor: _primaryPurple,
                        inactiveColor: Colors.grey,
                        activeFillColor: Colors.white,
                        selectedFillColor: Colors.white,
                        inactiveFillColor: Colors.white,
                      ),

                      onCompleted: (value) => pinValue = value,
                      onChanged: (value) => pinValue = value,
                    ),

                    const SizedBox(height: 40),

                    // --- Verify Button ---
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _verifyPin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryPurple,
                          padding:
                          const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Verify & Continue',
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
// --- Shared Custom Clipper ---
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
