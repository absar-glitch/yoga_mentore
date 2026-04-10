import 'package:flutter/material.dart';
import 'package:yoga_mentore/Screens/loginsignup.dart';

/// Animated splash screen that appears when the app starts
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progress;

  @override
  void initState() {
    super.initState();

    // Initializing the animation controller with a 3-second duration
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Creating a tween animation for the progress bar
    _progress = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {}); // Rebuild UI on animation frame
      })
      ..addStatusListener((status) {
        // Navigate to AuthScreen once animation completes
        if (status == AnimationStatus.completed) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginSignupScreen()),
          );
        }
      });

    _controller.forward(); // Start the animation
  }

  @override
  void dispose() {
    // Dispose controller to prevent memory leaks
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Theme-aware colors
    final bgPrimary = isDark ? const Color(0xFF102213) : Colors.white;
    final bgSecondary = isDark
        ? const Color.fromARGB(38, 19, 236, 55)
        : const Color.fromARGB(30, 19, 236, 91);
    final circleOverlay = isDark
        ? const Color(0xFF13ec37).withValues(alpha: 0.05)
        : const Color(0xFF13EC5B).withValues(alpha: 0.08);
    final logoContainerBg = isDark
        ? const Color(0xFF102213).withValues(alpha: 0.5)
        : Colors.white.withValues(alpha: 0.9);
    final logoBorder = isDark
        ? const Color(0xFF13ec37).withValues(alpha: 0.3)
        : const Color(0xFF13EC5B).withValues(alpha: 0.25);
    final titleColor = isDark ? Colors.white : const Color(0xFF1A3A1F);
    final subtitleColor = isDark ? Colors.white60 : const Color(0xFF5A7D5F);
    const accentColor = Color(0xFF13EC5B);
    final progressBg = isDark
        ? const Color.fromARGB(25, 19, 236, 55)
        : const Color(0xFF13EC5B).withValues(alpha: 0.15);

    return Scaffold(
      body: Container(
        // Background styling with radial gradient — theme-aware
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 0.7,
            colors: [bgSecondary, bgPrimary],
          ),
        ),
        child: Stack(
          children: [
            // Decorative background circle
            Positioned(
              top: -100,
              left: -100,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: circleOverlay,
                  borderRadius: BorderRadius.circular(200),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo Container
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      color: logoContainerBg,
                      border: Border.all(color: logoBorder),
                      borderRadius: BorderRadius.circular(80),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? Colors.black.withValues(alpha: 0.3)
                              : const Color(0xFF13EC5B).withValues(alpha: 0.15),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Material(
                      color: Colors.transparent,
                      child: Icon(
                        Icons.self_improvement,
                        color: accentColor,
                        size: 80,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // App Name
                  Text(
                    'Yoga Mentor',
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // App Tagline
                  const Text(
                    'Your AI-powered yoga guide',
                    style: TextStyle(color: accentColor, fontSize: 16),
                  ),
                  const SizedBox(height: 60),

                  /// 🔥 Animated Progress Indicator section
                  Column(
                    children: [
                      Text(
                        'Initializing Practice... ${(_progress.value * 100).toInt()}%',
                        style: TextStyle(color: subtitleColor),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 220,
                        child: LinearProgressIndicator(
                          value: _progress.value,
                          backgroundColor: progressBg,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            accentColor,
                          ),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
