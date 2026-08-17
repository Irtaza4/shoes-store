import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/mock_data.dart';
import 'main_shell.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _floatAnim = Tween<double>(begin: -12, end: 12).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _getStarted() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const MainShell(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final tween = Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeOutCubic));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 550),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity != null && details.primaryVelocity! < -100) {
            // Swiped up
            _getStarted();
          }
        },
        child: Stack(
          children: [
            // Background Dark to Burnt Orange Gradient
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF161312),
                      Color(0xFF1C1412),
                      Color(0xFF381B14),
                      Color(0xFFB84424),
                      Color(0xFFE85836),
                    ],
                    stops: [0.0, 0.35, 0.60, 0.85, 1.0],
                  ),
                ),
              ),
            ),

            // Background Ghost "NIKE" Typography
            Positioned(
              top: size.height * 0.07,
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

            // Swirling Orbit Lines Behind Shoe
            Positioned(
              top: size.height * 0.16,
              left: size.width * 0.08,
              right: size.width * 0.08,
              height: 290,
              child: CustomPaint(
                painter: OrbitTrailsPainter(),
              ),
            ),

            // Floating Transparent Sneaker
            Positioned(
              top: size.height * 0.14,
              left: 20,
              right: 20,
              height: 310,
              child: AnimatedBuilder(
                animation: _floatAnim,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _floatAnim.value),
                    child: Transform.rotate(
                      angle: -0.22,
                      child: Center(
                        child: Image.asset(
                          MockData.products[1].images.first,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.roller_skating_outlined,
                                  size: 160, color: Colors.white70),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Lower Content: Headline, Subtitle, and Upward CTA
            Positioned(
              bottom: 40,
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
                  const SizedBox(height: 34),

                  // Double Chevron Up & Get Started with smooth slide up
                  GestureDetector(
                    onTap: _getStarted,
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      children: [
                        const Icon(
                          Icons.keyboard_double_arrow_up_rounded,
                          color: Colors.white,
                          size: 28,
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
                ],
              ),
            ),
          ],
        ),
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
            color: Colors.white.withValues(alpha: 0.07),
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
      ..color = const Color(0xFFE85836).withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final paint2 = Paint()
      ..color = const Color(0xFFFF9E7D).withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

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
