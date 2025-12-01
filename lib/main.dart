import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart'; // For the named route in Dashboard

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Set the initial screen to the Flutter-side SplashScreen
      home: const SplashScreen(),

      // Define a named route for the Login screen (used for clean logout)
      routes: {
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}