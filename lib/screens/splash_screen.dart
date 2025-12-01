// lib/screens/splash_screen.dart

import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  // Increased the delay to 5 seconds for better visibility
  _navigateToNextScreen() async {
    // Wait for 5 seconds (was 3 seconds)
    await Future.delayed(const Duration(seconds: 5));

    // Navigate to the LoginScreen
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your App Logo or a larger version of your splash image
            FlutterLogo(size: 150), // Made it larger for visibility
            SizedBox(height: 40),
            // Optional: Loading Indicator
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text("Loading app services...", style: TextStyle(fontSize: 18))
          ],
        ),
      ),
    );
  }
}