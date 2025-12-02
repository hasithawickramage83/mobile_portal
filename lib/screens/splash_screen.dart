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

  // Simulating a delay and checking login status
  _navigateToNextScreen() async {
    // Wait for 5 seconds (for clear visibility)
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
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Using your custom logo image defined in assets/
            // NOTE: Ensure you have an image file at 'assets/splash.png'
            Image.asset(
              'assets/splash.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            const Text("Loading app services...", style: TextStyle(fontSize: 18))
          ],
        ),
      ),
    );
  }
}