import 'package:flutter/material.dart';
import 'reset_password_screen.dart';

class PinVerificationScreen extends StatelessWidget {
  const PinVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify PIN')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter the 6-digit PIN sent to your email.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            // Simple text field for PIN. For a real app, use a dedicated package.
            const TextField(
              maxLength: 6,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(labelText: 'Verification PIN'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Verify PIN logic, then navigate
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ResetPasswordScreen(),
                ));
              },
              child: const Text('Verify and Proceed'),
            ),
          ],
        ),
      ),
    );
  }
}