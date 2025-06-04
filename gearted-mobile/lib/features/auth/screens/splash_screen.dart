import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glitchAnimation;
  late Animation<double> _staticAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeIn),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _glitchAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.1, 0.7, curve: Curves.easeInOut),
    ));

    _staticAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.5, curve: Curves.linear),
    ));

    _startAnimationAndNavigation();
  }

  void _startAnimationAndNavigation() async {
    _animationController.forward();

    // Wait for animation to complete, then check authentication
    await Future.delayed(const Duration(milliseconds: 3000));

    if (mounted) {
      try {
        final authService = AuthService();
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token');

        if (token != null) {
          // User has a token, try to validate it
          final isLoggedIn = await authService.isLoggedIn();
          if (isLoggedIn) {
            context.go('/home');
          } else {
            context.go('/login');
          }
        } else {
          // No token, go to login
          context.go('/login');
        }
      } catch (e) {
        // If authentication check fails, go to login
        print('Auth check error: $e');
        context.go('/login');
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            // Create glitch effect by slightly offsetting the logo randomly
            final glitchOffset = _glitchAnimation.value < 0.5
                ? Offset(
                    ((_glitchAnimation.value * 10) % 1) * 4 - 2,
                    ((_glitchAnimation.value * 15) % 1) * 2 - 1,
                  )
                : Offset.zero;

            return FadeTransition(
              opacity: _fadeAnimation,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo with transmission interference effect
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Static noise overlay (appears during transmission)
                        if (_staticAnimation.value > 0 &&
                            _staticAnimation.value < 0.8)
                          Container(
                            width: 220,
                            height: 220,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withOpacity(
                                      0.1 * _staticAnimation.value),
                                  Colors.transparent,
                                  Colors.white.withOpacity(
                                      0.05 * _staticAnimation.value),
                                ],
                                stops: [0.0, 0.5, 1.0],
                              ),
                            ),
                          ),

                        // Main logo with glitch effect
                        Transform.translate(
                          offset: glitchOffset,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _glitchAnimation.value > 0.3 &&
                                        _glitchAnimation.value < 0.7
                                    ? const Color(0xFF8B0000).withOpacity(0.3)
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Stack(
                                children: [
                                  // Main logo
                                  Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Image.asset(
                                      'assets/images/gearted_transparent.png',
                                      fit: BoxFit.contain,
                                      width: 152,
                                      height: 152,
                                      color: _glitchAnimation.value > 0.6 &&
                                              _glitchAnimation.value < 0.8
                                          ? Colors.white.withOpacity(0.9)
                                          : null,
                                      colorBlendMode:
                                          _glitchAnimation.value > 0.6 &&
                                                  _glitchAnimation.value < 0.8
                                              ? BlendMode.overlay
                                              : null,
                                    ),
                                  ),

                                  // Horizontal scan lines (TV interference effect)
                                  if (_staticAnimation.value > 0.2 &&
                                      _staticAnimation.value < 0.6)
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: List.generate(
                                                20,
                                                (index) => index % 2 == 0
                                                    ? Colors.transparent
                                                    : Colors.white
                                                        .withOpacity(0.02)),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 60),

                    // Loading indicator with signal strength effect
                    Transform.translate(
                      offset: Offset(0, _glitchAnimation.value > 0.4 ? 2 : 0),
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          strokeWidth: 4,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _staticAnimation.value > 0.3 &&
                                    _staticAnimation.value < 0.7
                                ? const Color(0xFF8B0000).withOpacity(0.6)
                                : const Color(0xFF8B0000).withOpacity(0.8),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // "Signal" text with glitch effect
                    if (_fadeAnimation.value > 0.6)
                      Transform.translate(
                        offset: _glitchAnimation.value > 0.5
                            ? Offset(1, 0)
                            : Offset.zero,
                        child: Text(
                          _staticAnimation.value > 0.4 &&
                                  _staticAnimation.value < 0.8
                              ? "ÉTABLISSEMENT DE LA CONNEXION..."
                              : "CONNEXION ÉTABLIE",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 2,
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
    );
  }
}
