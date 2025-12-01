import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'forget_password_screen.dart';
import 'dashboard_screen.dart';

// 1. Convert to a StatefulWidget to manage the form state and keys.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 2. Create a GlobalKey to uniquely identify the Form widget
  // and allow validation.
  final _formKey = GlobalKey<FormState>();

  // Controllers to access text field values (optional but good practice)
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Function to handle the login attempt and validation
  void _login() {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      // If the form is valid (inputs meet validation criteria), proceed with login logic.

      // *** Dummy Login Logic Start ***
      String email = _emailController.text;
      String password = _passwordController.text;

      // In a real app, you would call an API here.
      if (email == 'test@example.com' && password == 'password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successful!')),
        );
        // Navigate to Dashboard on successful login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid Credentials')),
        );
      }
      // *** Dummy Login Logic End ***
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView( // Use SingleChildScrollView to prevent overflow on keyboard show
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form( // 3. Wrap inputs in a Form widget
            key: _formKey, // 4. Assign the GlobalKey
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50), // Added spacing for centered look
                // --- Email Input ---
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  // 5. Add a validator function
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address.';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email address.';
                    }
                    return null; // Return null if validation passes
                  },
                ),
                const SizedBox(height: 20),

                // --- Password Input ---
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  // 6. Add a validator function
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password.';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // --- Login Button ---
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _login, // Call the validation function
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                      'Log In',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // --- Forgot Password ---
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ForgetPasswordScreen(),
                    ));
                  },
                  child: const Text('Forgot Password?'),
                ),

                // --- Sign Up Link ---
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    ));
                  },
                  child: const Text('Don\'t have an account? Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}