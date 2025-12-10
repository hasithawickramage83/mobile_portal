import 'dart:math';
import 'package:flutter/material.dart';
import 'login_screen.dart';

// --- Custom Colors ---
const Color _primaryPurple = Color(0xFF5D3E8E);
const Color _primaryOrange = Color(0xFFF58220);
const Color _secondaryOrange = Color(0xFFF2A332);

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _ballAnimation;

  @override
  void initState() {
    super.initState();

    // Animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    // Smooth easing for rotation (ease-in-out)
    _rotationAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    // Smooth ball movement (sin curve with easing)
    _ballAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutSine,
    );

    _goToLogin();
  }

  Future<void> _goToLogin() async {
    await Future.delayed(const Duration(seconds: 4));
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionsBuilder: (_, animation, __, child) {
          final slide = Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(animation);
          final fade = Tween<double>(begin: 0, end: 1).animate(animation);
          return SlideTransition(
            position: slide,
            child: FadeTransition(opacity: fade, child: child),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_primaryPurple, _primaryOrange],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- App Name ---
              const Text(
                'My App',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),

              // --- Tagline ---
              const Text(
                'Connecting People, Instantly',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 30),

              // --- Animated bars + ball ---
              AnimatedBuilder(
                animation: _controller,
                builder: (_, __) {
                  final rotationValue = _rotationAnimation.value * 2 * pi;
                  final ballValue = _ballAnimation.value * 2 * pi;

                  return SizedBox(
                    width: 200,
                    height: 200,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Glow behind bars
                        Container(
                          width: 220,
                          height: 220,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                _secondaryOrange.withOpacity(0.3),
                                Colors.transparent
                              ],
                              radius: 0.6,
                            ),
                          ),
                        ),

                        // Top curved bar
                        Transform.rotate(
                          angle: rotationValue,
                          child: CustomPaint(
                            size: const Size(180, 40),
                            painter: BarPainter(_primaryPurple),
                          ),
                        ),

                        // Bottom curved bar
                        Transform.rotate(
                          angle: -rotationValue,
                          child: CustomPaint(
                            size: const Size(180, 40),
                            painter: BarPainter(_primaryOrange),
                          ),
                        ),

                        // Moving ball
                        Transform.translate(
                          offset: Offset(
                            0,
                            -60 * sin(ballValue),
                          ),
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: const BoxDecoration(
                              color: _secondaryOrange,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orangeAccent,
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),

              // --- Loading message ---
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(_secondaryOrange),
              ),
              const SizedBox(height: 12),
              const Text(
                'Initializing App...',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom painter for curved bar
class BarPainter extends CustomPainter {
  final Color color;
  BarPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.5);
    path.quadraticBezierTo(
        size.width * 0.25, 0, size.width * 0.5, size.height * 0.5);
    path.quadraticBezierTo(
        size.width * 0.75, size.height, size.width, size.height * 0.5);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
