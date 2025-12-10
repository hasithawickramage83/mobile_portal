import 'package:flutter/material.dart';
import 'package:login_portal/screens/dashboard_screen.dart';
import 'package:login_portal/screens/signup_screen.dart';

import 'forget_password_screen.dart';

// --- Custom Colors ---
const Color _primaryPurple = Color(0xFF5D3E8E);
const Color _primaryOrange = Color(0xFFF58220);
const Color _secondaryOrange = Color(0xFFF2A332);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // --- Navigation Logic (Updated to use provided screen imports) ---

  void _navigateToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
    );
  }

  void _navigateToSignUp() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }

  void _navigateToForgetPassword() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ForgetPasswordScreen()),
    );
  }

  void _goBack() {
    // Standard pop functionality for the back button
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // Using MediaQuery to get the screen height for responsive sizing of the curve
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // The body uses a Stack to layer the background curve beneath the form content
      body: Stack(
        children: [
          // 1. Light Background Color
          Container(
            color: const Color(0xFFF7F7F7),
          ),

          // 2. Orange curve/design at the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: CustomLoginClipper(),
              child: Container(
                // The curve takes up approx 35% of the screen height
                height: screenHeight * 0.35,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      _secondaryOrange,
                      _primaryOrange,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 3. Main content (Scrollable form)
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),

              child: Form(
                key: _formKey,
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 80),

                    // --- Back Button ---
                    // GestureDetector(
                    //   onTap: _goBack,
                    //   child: const Row(
                    //     mainAxisSize: MainAxisSize.min,
                    //     children: [
                    //       Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
                    //       Text(
                    //         'Back',
                    //         style: TextStyle(fontSize: 18, color: Colors.black),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Center(
                      child: const Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: const Text(
                        'Login to your account',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // --- Logo ---
                    Center(
                      child: Image.asset(
                        'assets/logo.png',

                      ),
                    ),
                    const SizedBox(height: 25),

                    // --- Email Field ---
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        // Minimal border style to match the image
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: _primaryPurple, width: 2.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(value!)) {
                          return 'Invalid email format';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // --- Password Field ---
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        // Minimal border style to match the image
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: _primaryPurple, width: 2.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),

                    // --- Login Button ---
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _navigateToDashboard(); // Call the dashboard function
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: _primaryPurple, // Deep purple color
                          elevation: 0,
                        ),
                        child: const Text(
                          'Log in',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // --- Links (Kept for completeness, though not clearly visible in the new design's area) ---
                    Center(
                      child: TextButton(
                        onPressed: _navigateToForgetPassword,
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: _primaryPurple.withOpacity(0.7)),
                        ),
                      ),
                    ),
                    Center(
                      child: TextButton(
                        onPressed: _navigateToSignUp,
                        child: Text(
                          'Create New Account',
                          style: TextStyle(color: _primaryPurple.withOpacity(0.7)),
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