import 'package:flutter/material.dart';
import 'Home_screen.dart';

class Landingpage extends StatefulWidget {
  const Landingpage({super.key});

  @override
  State<Landingpage> createState() => _LandingpageState();
}

class _LandingpageState extends State<Landingpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Premium Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.blue.shade50],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // 2. Animated Hero Image
                  TweenAnimationBuilder(
                    duration: const Duration(milliseconds: 1200),
                    tween: Tween<double>(begin: 0, end: 1),
                    builder: (context, double value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.scale(
                          scale: 0.8 + (0.2 * value), // Subtle scale-up effect
                          child: child,
                        ),
                      );
                    },
                    child: Material(
                      elevation: 15,
                      shadowColor: Colors.blue.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(40),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.asset(
                          "lib/Assets/image.jpeg",
                          height: MediaQuery.of(context).size.height / 2.2,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),

                  // 3. Catchy Main Title (Staggered Animation)
                  _buildFadeInText(
                    "Your World,\nYour News",
                    34,
                    FontWeight.w900, // Extra Bold for modern editorial look
                    0.4,
                    letterSpacing: -1.0,
                  ),
                  const SizedBox(height: 20),

                  // 4. Descriptive Subtitle
                  _buildFadeInText(
                    "A personalized news experience that connects you to the stories that matter most.",
                    17,
                    FontWeight.w400,
                    0.7,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                  const Spacer(),

                  // 5. High-Impact Animated Button
                  _buildGetStartedButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Animated Text Helper using System Fonts
  Widget _buildFadeInText(
    String text,
    double size,
    FontWeight weight,
    double delay, {
    Color color = Colors.black,
    double letterSpacing = 0.0,
    double height = 1.2,
  }) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 1000),
      curve: Interval(delay, 1.0, curve: Curves.easeOut),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)), // Slide up effect
            child: child,
          ),
        );
      },
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: size,
          fontWeight: weight,
          color: color,
          letterSpacing: letterSpacing,
          height: height,
        ),
      ),
    );
  }

  Widget _buildGetStartedButton() {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 1000),
      curve: const Interval(0.9, 1.0, curve: Curves.elasticOut),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: GestureDetector(
        onTap: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            gradient: const LinearGradient(
              colors: [Colors.blueAccent, Colors.blue],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: const Center(
            child: Text(
              "Get Started",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}