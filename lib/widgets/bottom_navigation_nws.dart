import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../state/app_state.dart';

class TabItemData {
  final String label;
  final IconData icon;
  final IconData? activeIcon;
  final bool isProfile;

  const TabItemData({
    required this.label,
    required this.icon,
    this.activeIcon,
    this.isProfile = false,
  });
}

class NwsBottomNavigation extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const NwsBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<NwsBottomNavigation> createState() => _NwsBottomNavigationState();
}

class _NwsBottomNavigationState extends State<NwsBottomNavigation>
    with SingleTickerProviderStateMixin {
  static const List<TabItemData> _tabs = [
    TabItemData(
      label: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
    ),
    TabItemData(
      label: 'Cart',
      icon: Icons.shopping_bag_outlined,
      activeIcon: Icons.shopping_bag_rounded,
    ),
    TabItemData(
      label: 'Saved',
      icon: Icons.bookmark_outline_rounded,
      activeIcon: Icons.bookmark_rounded,
    ),
    TabItemData(
      label: 'Explore',
      icon: Icons.notifications_none_rounded,
      activeIcon: Icons.notifications_rounded,
    ),
    TabItemData(
      label: 'Profile',
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      isProfile: true,
    ),
  ];

  late AnimationController _animController;
  Animation<double>? _xAnimation;
  double _currentX = 0.0;
  bool _isDragging = false;
  int _lastHapticIndex = 0;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    )..addListener(() {
        if (_xAnimation != null && !_isDragging) {
          setState(() {
            _currentX = _xAnimation!.value;
          });
        }
      });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final screenWidth = MediaQuery.of(context).size.width;
      final tabWidth = screenWidth / _tabs.length;
      _currentX = (widget.currentIndex + 0.5) * tabWidth;
      _lastHapticIndex = widget.currentIndex;
      _isInitialized = true;
    }
  }

  @override
  void didUpdateWidget(covariant NwsBottomNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex && !_isDragging) {
      final screenWidth = MediaQuery.of(context).size.width;
      final tabWidth = screenWidth / _tabs.length;
      final targetX = (widget.currentIndex + 0.5) * tabWidth;
      _animateToX(targetX);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _animateToX(double targetX) {
    _animController.stop();
    _xAnimation = Tween<double>(
      begin: _currentX,
      end: targetX,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutCubic,
      ),
    );
    _animController.forward(from: 0.0);
  }

  void _snapToTab(int targetIndex) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tabWidth = screenWidth / _tabs.length;
    final targetX = (targetIndex + 0.5) * tabWidth;
    _animateToX(targetX);
    if (targetIndex != widget.currentIndex) {
      widget.onTap(targetIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final cartCount = appState.cartCount;
    final screenWidth = MediaQuery.of(context).size.width;
    final tabWidth = screenWidth / _tabs.length;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    final minX = tabWidth * 0.5;
    final maxX = screenWidth - (tabWidth * 0.5);

    if (!_isDragging && !_animController.isAnimating) {
      _currentX = ((widget.currentIndex + 0.5) * tabWidth).clamp(minX, maxX);
    }

    final activeIndex =
        (_currentX / tabWidth).floor().clamp(0, _tabs.length - 1);

    // Standard grounded nav bar height + Big Hero Circle (72px)
    const barHeight = 64.0;
    const totalHeight = 92.0;
    const bubbleSize = 58.0;

    return Container(
      color: Colors.transparent,
      height: totalHeight + bottomPadding,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragStart: (details) {
          _animController.stop();
          setState(() {
            _isDragging = true;
            _currentX = details.localPosition.dx.clamp(minX, maxX);
          });
        },
        onHorizontalDragUpdate: (details) {
          final newX = details.localPosition.dx.clamp(minX, maxX);
          final nearestIndex =
              (newX / tabWidth).floor().clamp(0, _tabs.length - 1);

          if (nearestIndex != _lastHapticIndex) {
            HapticFeedback.selectionClick();
            _lastHapticIndex = nearestIndex;
          }

          setState(() {
            _currentX = newX;
          });
        },
        onHorizontalDragEnd: (details) {
          setState(() {
            _isDragging = false;
          });

          final velocity = details.primaryVelocity ?? 0.0;
          int targetIndex;
          if (velocity > 350) {
            targetIndex = (_currentX / tabWidth).floor() + 1;
          } else if (velocity < -350) {
            targetIndex = (_currentX / tabWidth).floor() - 1;
          } else {
            targetIndex = (_currentX / tabWidth).floor();
          }

          targetIndex = targetIndex.clamp(0, _tabs.length - 1);
          HapticFeedback.lightImpact();
          _snapToTab(targetIndex);
        },
        onTapUp: (details) {
          final tappedIndex =
              (details.localPosition.dx / tabWidth).floor().clamp(0, _tabs.length - 1);
          HapticFeedback.lightImpact();
          _snapToTab(tappedIndex);
        },
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            // Custom Curved Background Painter with Fluid Moving Notch (Solid white, no shadow)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: barHeight + bottomPadding,
              child: CustomPaint(
                painter: FluidCurvedNavbarPainter(
                  notchCenterX: _currentX,
                  barHeight: barHeight + bottomPadding,
                  notchRadius: 80.0,
                  notchDepth: 52.0,
                ),
                size: Size(screenWidth, barHeight + bottomPadding),
              ),
            ),

            // Inactive Tab Icons Row
            Positioned(
              left: 0,
              right: 0,
              bottom: bottomPadding,
              height: barHeight,
              child: Row(
                children: List.generate(_tabs.length, (index) {
                  final tab = _tabs[index];
                  final tabCenterX = (index + 0.5) * tabWidth;
                  final dist = (_currentX - tabCenterX).abs();
                  // Distance factor: 0 when right on top, 1 when far away
                  final fadeFactor = (dist / (tabWidth * 0.72)).clamp(0.0, 1.0);
                  final scaleFactor = 0.65 + (0.35 * fadeFactor);

                  return Expanded(
                    child: Center(
                      child: Opacity(
                        opacity: (fadeFactor * 0.95).clamp(0.0, 1.0),
                        child: Transform.scale(
                          scale: scaleFactor,
                          child: tab.isProfile
                              ? _buildAvatarWidget(appState.userProfile.avatarUrl)
                              : _buildIconWidget(tab.icon, badgeCount: index == 1 ? cartCount : 0),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Big Hero Floating Orange Circle Indicator (72px diameter with depth)
            Positioned(
              left: _currentX - (bubbleSize / 2),
              bottom: bottomPadding + 16,
              child: AnimatedScale(
                scale: _isDragging ? 1.06 : 1.0,
                duration: const Duration(milliseconds: 140),
                curve: Curves.easeOutCubic,
                child: Container(
                  width: bubbleSize,
                  height: bubbleSize,
                  decoration: BoxDecoration(
                    color: AppColors.primaryAccent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryAccent.withValues(alpha: _isDragging ? 0.58 : 0.45),
                        offset: Offset(0, _isDragging ? 12 : 8),
                        blurRadius: _isDragging ? 24 : 18,
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.10),
                        offset: const Offset(0, 3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 160),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(
                          scale: Tween<double>(begin: 0.75, end: 1.0).animate(
                            CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
                          ),
                          child: FadeTransition(opacity: animation, child: child),
                        );
                      },
                      child: Icon(
                        _tabs[activeIndex].activeIcon ?? _tabs[activeIndex].icon,
                        key: ValueKey<int>(activeIndex),
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconWidget(IconData icon, {int badgeCount = 0}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          icon,
          size: 26,
          color: const Color(0xFF9E9EAE),
        ),
        if (badgeCount > 0)
          Positioned(
            top: -4,
            right: -6,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: AppColors.primaryAccent,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                '$badgeCount',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAvatarWidget(String avatarUrl) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFD0D0DA),
          width: 1.5,
        ),
      ),
      child: ClipOval(
        child: Image.network(
          avatarUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.person_rounded,
            size: 18,
            color: Color(0xFF9E9EAE),
          ),
        ),
      ),
    );
  }
}

class FluidCurvedNavbarPainter extends CustomPainter {
  final double notchCenterX;
  final double barHeight;
  final double notchRadius;
  final double notchDepth;

  FluidCurvedNavbarPainter({
    required this.notchCenterX,
    required this.barHeight,
    required this.notchRadius,
    required this.notchDepth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Ambient soft top shadow for modern depth
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.05)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

    const cornerRadius = 26.0;
    final path = Path();

    final leftNotchX = notchCenterX - notchRadius;
    final rightNotchX = notchCenterX + notchRadius;

    // Move to bottom-left
    path.moveTo(0, size.height);
    // Line up the left edge
    path.lineTo(0, cornerRadius);

    // Top-left rounded corner
    if (leftNotchX > cornerRadius) {
      path.quadraticBezierTo(0, 0, cornerRadius, 0);
      path.lineTo(leftNotchX, 0);
    } else {
      final blendX = math.max(0.0, leftNotchX);
      path.quadraticBezierTo(0, 0, blendX, 0);
    }

    // Smooth organic Bezier scoop cradle beneath the big floating active circle
    path.cubicTo(
      notchCenterX - (notchRadius * 0.52),
      0,
      notchCenterX - (notchRadius * 0.40),
      notchDepth,
      notchCenterX,
      notchDepth,
    );
    path.cubicTo(
      notchCenterX + (notchRadius * 0.40),
      notchDepth,
      notchCenterX + (notchRadius * 0.52),
      0,
      math.min(size.width, rightNotchX),
      0,
    );

    // Top-right rounded corner
    if (rightNotchX < size.width - cornerRadius) {
      path.lineTo(size.width - cornerRadius, 0);
      path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);
    } else {
      path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);
    }

    // Line down right edge to bottom-right
    path.lineTo(size.width, size.height);
    path.close();

    // Draw shadow first, then white body
    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant FluidCurvedNavbarPainter oldDelegate) {
    return oldDelegate.notchCenterX != notchCenterX ||
        oldDelegate.barHeight != barHeight ||
        oldDelegate.notchRadius != notchRadius ||
        oldDelegate.notchDepth != notchDepth;
  }
}
