import 'package:flutter/material.dart';
import 'package:login_portal/screens/login_screen.dart';
import 'screens/splash_screen.dart';

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