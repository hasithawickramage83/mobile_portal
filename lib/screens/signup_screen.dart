import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login_screen.dart';

// --- Custom Colors ---
const Color _primaryPurple = Color(0xFF5D3E8E);
const Color _primaryOrange = Color(0xFFF58220);
const Color _secondaryOrange = Color(0xFFF2A332);

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  // ---------------- API LOGIN ----------------
  Future<void> _signUpApi() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    const String url = 'https://mindecho.afford-it.co.nz/api/register';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "name":_nameController.text.trim(),
          "email": _emailController.text.trim(),
          "password": _passwordController.text.trim(),
          "device_token": "flutter_device_token",
        }),
      );

      final Map<String, dynamic> result = jsonDecode(response.body);

      if (!mounted) return;

      if (response.statusCode == 200 && result['meta']['status'] == 200) {


        _showSuccessDialog("Registration successful for ${_emailController.text.trim()} ", navigate: true);
      } else {
        showErrorDialog(result['meta']['message'] ?? "Registration failed");
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
              if (navigate) _navigateToLogin();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(color: const Color(0xFFF7F7F7)),

          // Bottom curve
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 80),

                    Center(
                      child: const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Center(
                      child: const Text(
                        'Sign up to get started',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Logo
                    Center(
                      child: Image.asset('assets/logo.png'),
                    ),

                    const SizedBox(height: 25),

                    // --- Full Name ---
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        border: UnderlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: _primaryPurple, width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Full name is required';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // --- Email ---
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
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
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                            .hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // --- Password ---
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
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

                    const SizedBox(height: 40),

                    // --- Sign Up Button ---
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _signUpApi();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryPurple,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    Center(
                      child: TextButton(
                        onPressed: _navigateToLogin,
                        child: Text(
                          'Already have an account? Login',
                          style:
                          TextStyle(color: _primaryPurple.withOpacity(0.7)),
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
