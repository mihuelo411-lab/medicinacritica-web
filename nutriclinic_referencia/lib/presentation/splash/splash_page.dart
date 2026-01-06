import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:nutrivigil/core/routes/app_router.dart';
import 'package:nutrivigil/core/di/dependencies.dart';
import 'package:nutrivigil/core/notifications/notification_service.dart';
import 'package:nutrivigil/domain/alerts/alert_engine.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  static const _fadeInDuration = Duration(milliseconds: 900);
  static const _totalDelay = Duration(milliseconds: 2200);

  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _fadeInDuration);
    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _controller.forward();

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final minDelay = Future.delayed(_totalDelay);
    
    final initialization = Future.wait([
      Dependencies.register(),
      Future(() async {
        // Dependencies must be registered first if NotificationService/AlertEngine depend on them being ready immediately.
        // However, Dependencies.register is async but lazy singletons are instant.
        // Let's await registration fully first just to be safe, but here we do it in parallel batch if possible.
        // Actually, Dependencies.register sets up GetIt. 
        // We should probably wait for Dependencies.register BEFORE resolving sl<...>.
        // Since we cannot easily chain inside Future.wait cleanly without nesting, let's restructure slightly.
      }),
    ]);
    
    // Better approach:
    try {
      // 1. Minimum animation delay
      final delayFuture = Future.delayed(_totalDelay);
      
      // 2. Heavy Lifting
      await Dependencies.register();
      await sl<NotificationService>().init();
      try {
         await sl<AlertEngine>().evaluate();
      } catch (e) {
         debugPrint('Error evaluating alerts in splash: $e');
      }

      // 3. Wait for animation
      await delayFuture;
      
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRouter.home);
    } catch (e) {
      debugPrint('Critical initialization error: $e');
      // Even if error, try to go home or show error page.
       if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRouter.home);
    }
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _SplashBackground(),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _GlassBadge(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 92,
                          height: 92,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: const Icon(
                            Icons.health_and_safety_rounded,
                            size: 54,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'NutriVigil',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontSize: 28,
                            letterSpacing: 1.1,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Seguimiento nutricional inteligente',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.75),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  const SizedBox(
                    width: 60,
                    height: 60,
                    child: _PulseLoader(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SplashBackground extends StatelessWidget {
  const _SplashBackground();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0EA8A8), Color(0xFF0F172A)],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -width * 0.25,
                top: -height * 0.05,
                child: _Bubble(
                  diameter: width * 0.7,
                  color: Colors.white.withOpacity(0.07),
                ),
              ),
              Positioned(
                left: -width * 0.25,
                bottom: -height * 0.1,
                child: _Bubble(
                  diameter: width * 0.65,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
              Positioned(
                left: width * 0.2,
                top: height * 0.3,
                child: _Bubble(
                  diameter: width * 0.2,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GlassBadge extends StatelessWidget {
  const _GlassBadge({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            color: Colors.white.withOpacity(0.12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 28,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _PulseLoader extends StatefulWidget {
  const _PulseLoader();

  @override
  State<_PulseLoader> createState() => _PulseLoaderState();
}

class _PulseLoaderState extends State<_PulseLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final value = _controller.value;
        final scale = 0.8 + (value * 0.3);
        final opacity = 0.35 + (1 - value) * 0.3;
        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(0.8),
            width: 4,
          ),
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.diameter, required this.color});

  final double diameter;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
