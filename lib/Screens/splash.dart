import 'package:flutter/material.dart';
import 'package:yoga_mentore/Screens/loginsignup.dart';

/// Animated splash screen that appears when the app starts
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progress;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Fade-in animation for the whole screen
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();

    // Pulse/breathing glow animation for the logo
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);

    // Initializing the animation controller with a 3-second duration
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Creating a tween animation for the progress bar
    _progress = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    )
      ..addListener(() {
        setState(() {}); // Rebuild UI on animation frame
      })
      ..addStatusListener((status) {
        // Navigate to AuthScreen once animation completes
        if (status == AnimationStatus.completed) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const LoginSignupScreen(),
              transitionsBuilder: (context, a, secondaryAnimation, c) =>
                  FadeTransition(opacity: a, child: c),
              transitionDuration: const Duration(milliseconds: 600),
            ),
          );
        }
      });

    _controller.forward(); // Start the animation
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _controller.dispose();
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Theme-aware colors
    final bgPrimary = isDark ? const Color(0xFF0A1A0D) : const Color(0xFFF0FFF4);
    final bgSecondary = isDark
        ? const Color.fromARGB(50, 19, 236, 55)
        : const Color.fromARGB(40, 19, 236, 91);
    final circleOverlay = isDark
        ? const Color(0xFF13ec37).withValues(alpha: 0.08)
        : const Color(0xFF13EC5B).withValues(alpha: 0.1);
    final titleColor = isDark ? Colors.white : const Color(0xFF1A3A1F);
    final subtitleColor = isDark ? Colors.white60 : const Color(0xFF5A7D5F);
    const accentColor = Color(0xFF13EC5B);
    final progressBg = isDark
        ? const Color.fromARGB(25, 19, 236, 55)
        : const Color(0xFF13EC5B).withValues(alpha: 0.15);

    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          // Background styling with radial gradient — theme-aware
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 0.85,
              colors: [bgSecondary, bgPrimary],
            ),
          ),
          child: Stack(
            children: [
              // Decorative background circles for depth
              Positioned(
                top: -120,
                left: -120,
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    color: circleOverlay,
                    borderRadius: BorderRadius.circular(280),
                  ),
                ),
              ),
              Positioned(
                bottom: -80,
                right: -80,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: circleOverlay,
                    borderRadius: BorderRadius.circular(200),
                  ),
                ),
              ),
              // Small floating accent circle
              Positioned(
                top: MediaQuery.of(context).size.height * 0.15,
                right: 40,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Logo Container with animated glow
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(80),
                            boxShadow: [
                              BoxShadow(
                                color: accentColor.withValues(
                                  alpha: 0.25 * _pulseAnimation.value,
                                ),
                                blurRadius: 30 * _pulseAnimation.value,
                                spreadRadius: 5 * _pulseAnimation.value,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(80),
                            child: Image.asset(
                              'assets/images/app_logo.png',
                              width: 160,
                              height: 160,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 28),
                    // App Name with gradient-like styling
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF13EC5B), Color(0xFF0BCB4E), Colors.white],
                        stops: [0.0, 0.6, 1.0],
                      ).createShader(bounds),
                      child: Text(
                        'Yoga Mentor',
                        style: TextStyle(
                          color: titleColor,
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // App Tagline
                    Text(
                      'Your AI-powered yoga guide',
                      style: TextStyle(
                        color: subtitleColor,
                        fontSize: 16,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 60),

                    /// 🔥 Animated Progress Indicator section
                    Column(
                      children: [
                        Text(
                          'Initializing Practice... ${(_progress.value * 100).toInt()}%',
                          style: TextStyle(
                            color: subtitleColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 240,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: _progress.value,
                              backgroundColor: progressBg,
                              valueColor:
                                  const AlwaysStoppedAnimation<Color>(accentColor),
                              minHeight: 7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Credits text at the bottom
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'App made with ❤️ by Absar, Taha and Eman',
                    style: TextStyle(
                      color: subtitleColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
