  import 'package:flutter/material.dart';
  import 'package:login_portal/screens/dashboard_screen.dart';
  import 'package:login_portal/screens/signup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
  import 'forget_password_screen.dart';
  import 'dart:convert';
  import 'package:flutter/material.dart';
  import 'package:http/http.dart' as http;

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
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    bool _isLoading = false;

    // ---------------- API LOGIN ----------------
    Future<void> _loginApi() async {
      if (!_formKey.currentState!.validate()) return;

      setState(() => _isLoading = true);
      const String url = 'https://mindecho.afford-it.co.nz/api/login';

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "email": _emailController.text.trim(),
            "password": _passwordController.text.trim(),
            "device_token": "flutter_device_token",
          }),
        );

        final Map<String, dynamic> result = jsonDecode(response.body);

        if (!mounted) return;

        if (response.statusCode == 200 && result['meta']['status'] == 200) {
          final token = result['data'][0]['access_token'];
          final user = result['data'][0]['user'][0];

          // Save token locally
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('access_token', token);
          await prefs.setString('user_name', user['name']);
          await prefs.setString('user_email', user['email']);
          _showSuccessDialog("Login successful for ${_emailController.text.trim()} ", navigate: true);
        } else {
          showErrorDialog(result['meta']['message'] ?? "Login failed");
        }
      } catch (e) {
        if (!mounted) return;
        showErrorDialog("Something went wrong.\n${e.toString()}");
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }

    // --- Error Dialog ---
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
          content: const Text("Login successful"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (navigate) _navigateToDashboard();
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }

    // --- Navigation ---
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
      Navigator.of(context).pop();
    }

    @override
    Widget build(BuildContext context) {
      final screenHeight = MediaQuery.of(context).size.height;

      return Scaffold(
        appBar: AppBar(title: const Text('Login to your Account')),
        body: Stack(
          children: [
            // Background
            Container(color: const Color(0xFFF7F7F7)),

            // Bottom Orange Curve
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

            // Form
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Center(child: Image.asset('assets/logo.png')),
                      const SizedBox(height: 20),

                      // Email
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: _primaryPurple, width: 2),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please enter your email';
                          if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(value)) {
                            return 'Invalid email format';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Password
                      TextFormField(
                        obscureText: true,
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: _primaryPurple, width: 2),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please enter your password';
                          if (value.length < 6) return 'Password must be at least 6 characters';
                          return null;
                        },
                      ),
                      const SizedBox(height: 40),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : () {
                            if (_formKey.currentState!.validate()) _loginApi();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: _primaryPurple,
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : const Text(
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

                      // Links
                      Center(
                        child: TextButton(
                          onPressed: _navigateToForgetPassword,
                          child: Text('Forgot Password?', style: TextStyle(color: _primaryPurple.withOpacity(0.7))),
                        ),
                      ),
                      Center(
                        child: TextButton(
                          onPressed: _navigateToSignUp,
                          child: Text('Create New Account', style: TextStyle(color: _primaryPurple.withOpacity(0.7))),
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
  // Custom Clipper for bottom curve
  // ------------------------------------------
  class CustomLoginClipper extends CustomClipper<Path> {
    @override
    Path getClip(Size size) {
      final path = Path();

      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, size.height * 0.60);

      path.quadraticBezierTo(size.width * 0.95, size.height * 0.40, size.width * 0.60, size.height * 0.50);
      path.quadraticBezierTo(size.width * 0.45, size.height * 0.55, size.width * 0.35, size.height * 0.75);
      path.quadraticBezierTo(size.width * 0.20, size.height * 0.85, 0, size.height * 0.90);

      path.close();
      return path;
    }

    @override
    bool shouldReclip(CustomLoginClipper oldClipper) => false;
  }
