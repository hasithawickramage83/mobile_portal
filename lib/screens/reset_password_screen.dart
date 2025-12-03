import 'package:flutter/material.dart';

import 'login_screen.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'New Password'),
            ),
            const SizedBox(height: 10),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Confirm New Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Reset password logic
                // Typically pop to the Login screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}