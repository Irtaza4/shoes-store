import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/mock_data.dart';
import '../widgets/image_fallback.dart';
import 'main_shell.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnim;

  late AnimationController _bounceController;
  late Animation<double> _bounceAnim;

  late AnimationController _transitionController;
  late Animation<double> _slideAnimation;

  double _dragOffset = 0.0;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();

    // Floating sneaker subtle animation
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);

    _floatAnim = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Indicator bounce animation
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _bounceAnim = Tween<double>(begin: 0, end: -6).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    // Transition controller for upward dismiss
    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );

    _slideAnimation = Tween<double>(begin: 0.0, end: -1.0).animate(
      CurvedAnimation(
        parent: _transitionController,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _bounceController.dispose();
    _transitionController.dispose();
    super.dispose();
  }

  void _finishTransition() {
    if (_isNavigating) return;
    _isNavigating = true;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const MainShell(),
        transitionDuration: Duration.zero,
      ),
    );
  }

  void _triggerUpwardAnimation() {
    if (_isNavigating) return;

    _transitionController.forward().then((_) {
      _finishTransition();
    });
  }

  void _onVerticalDragUpdate(DragUpdateDetails details, double screenHeight) {
    if (_isNavigating) return;

    setState(() {
      _dragOffset += details.primaryDelta ?? 0.0;
      // Restrict drag to upward only (negative values)
      if (_dragOffset > 0) _dragOffset = 0;
    });
  }

  void _onVerticalDragEnd(DragEndDetails details, double screenHeight) {
    if (_isNavigating) return;

    final velocity = details.primaryVelocity ?? 0.0;
    final progress = -_dragOffset / screenHeight;

    // If dragged more than 15% of screen or flicked upwards quickly
    if (progress > 0.15 || velocity < -300) {
      // Set transition controller start from current drag progress
      _transitionController.value = progress.clamp(0.0, 1.0);
      _transitionController.forward().then((_) {
        _finishTransition();
      });
    } else {
      // Snap back smoothly
      setState(() {
        _dragOffset = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background MainShell preview for seamless reveal
          const Positioned.fill(
            child: MainShell(),
          ),

          // Interactive Onboarding Layer that slides up
          AnimatedBuilder(
            animation: _transitionController,
            builder: (context, child) {
              final programmaticProgress = _slideAnimation.value * screenHeight;
              final currentY = _dragOffset + programmaticProgress;

              return Transform.translate(
                offset: Offset(0, currentY),
                child: child,
              );
            },
            child: GestureDetector(
              onVerticalDragUpdate: (details) =>
                  _onVerticalDragUpdate(details, screenHeight),
              onVerticalDragEnd: (details) =>
                  _onVerticalDragEnd(details, screenHeight),
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: Stack(
                  children: [
                    // Background Gradient
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF161312),
                              Color(0xFF1F1411),
                              Color(0xFF3B1810),
                              Color(0xFFB84424),
                              Color(0xFFE85836),
                            ],
                            stops: [0.0, 0.35, 0.60, 0.85, 1.0],
                          ),
                        ),
                      ),
                    ),

                    // Ghost "NIKE" Outlined Typography Watermark
                    Positioned(
                      top: screenHeight * 0.06,
                      left: 20,
                      right: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildGhostText('NIKE'),
                          const SizedBox(height: 12),
                          _buildGhostText('NIKE'),
                          const SizedBox(height: 12),
                          _buildGhostText('NIKE'),
                        ],
                      ),
                    ),

                    // Glowing Orbit Trails
                    Positioned(
                      top: screenHeight * 0.14,
                      left: size.width * 0.06,
                      right: size.width * 0.06,
                      height: 310,
                      child: CustomPaint(
                        painter: OrbitTrailsPainter(),
                      ),
                    ),

                    // Floating Transparent Sneaker
                    Positioned(
                      top: screenHeight * 0.13,
                      left: 20,
                      right: 20,
                      height: 320,
                      child: AnimatedBuilder(
                        animation: _floatAnim,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _floatAnim.value),
                            child: Transform.rotate(
                              angle: -0.22,
                              child: Center(
                                child: ShoeImage(
                                  imageUrl: MockData.products[5].images.first,
                                  fit: BoxFit.contain,
                                  borderRadius: 0,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Lower Content: Live Your Perfect & Chevron CTA
                    Positioned(
                      bottom: MediaQuery.of(context).padding.bottom + 24,
                      left: 24,
                      right: 24,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'LIVE YOUR\nPERFECT',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 1.2,
                              height: 1.12,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Smart, gorgeous & fashionable\ncollection makes you cool',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withValues(alpha: 0.85),
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Bouncing Upward Chevron & Get Started Action
                          GestureDetector(
                            onTap: _triggerUpwardAnimation,
                            behavior: HitTestBehavior.opaque,
                            child: AnimatedBuilder(
                              animation: _bounceAnim,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, _bounceAnim.value),
                                  child: child,
                                );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.keyboard_double_arrow_up_rounded,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Get Started',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGhostText(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 88,
        fontWeight: FontWeight.w900,
        letterSpacing: 4.0,
        color: Colors.transparent,
        shadows: [
          Shadow(
            color: Colors.white.withValues(alpha: 0.08),
            blurRadius: 1,
          ),
        ],
      ),
    );
  }
}

class OrbitTrailsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = const Color(0xFFE85836).withValues(alpha: 0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;

    final paint2 = Paint()
      ..color = const Color(0xFFFF9E7D).withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    final path1 = Path();
    path1.moveTo(0, size.height * 0.65);
    path1.cubicTo(
      size.width * 0.4,
      size.height * 0.9,
      size.width * 0.8,
      size.height * 0.3,
      size.width,
      size.height * 0.1,
    );
    canvas.drawPath(path1, paint1);

    final path2 = Path();
    path2.moveTo(size.width * 0.1, size.height * 0.3);
    path2.cubicTo(
      size.width * 0.3,
      size.height * 0.1,
      size.width * 0.7,
      size.height * 0.8,
      size.width * 0.95,
      size.height * 0.5,
    );
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
