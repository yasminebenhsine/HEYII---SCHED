// splash_screen.dart
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final Widget nextScreen;
  const SplashScreen({Key? key, required this.nextScreen}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _widthAnimation;
  late Animation<double> _moveAnimation;

  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.8, 1.0),
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.2),
    ));

    _widthAnimation = Tween<double>(
      begin: 60.0,
      end: 300.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.4),
    ));

    _moveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 0.8),
    ));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                widget.nextScreen,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    });
  }

  void _startAnimation() {
    if (!_isAnimating) {
      setState(() {
        _isAnimating = true;
      });
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF9F8DC3),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          width: 250,
                          height: 250,
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Welcome',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Le système de planification parfait pour les étudiants et les enseignants.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return GestureDetector(
                    onTap: _startAnimation,
                    child: Container(
                      width: _isAnimating
                          ? Tween<double>(begin: 60.0, end: 300.0)
                              .animate(CurvedAnimation(
                                parent: _controller,
                                curve: const Interval(0.2, 0.4),
                              ))
                              .value
                          : 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: Color(0XFF5C5792),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            left: _isAnimating
                                ? Tween<double>(begin: 0.0, end: 240.0)
                                    .animate(CurvedAnimation(
                                      parent: _controller,
                                      curve: const Interval(0.4, 0.8),
                                    ))
                                    .value
                                : 0.0,
                            top: 0,
                            child: Container(
                              width: 60.0,
                              height: 60.0,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0XFF5C5792),
                              ),
                              child: Transform.scale(
                                scale: _scaleAnimation.value,
                                child: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
