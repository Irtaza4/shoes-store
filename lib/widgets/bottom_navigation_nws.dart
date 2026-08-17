import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../state/app_state.dart';

class NwsBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const NwsBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final cartCount = appState.cartCount;
    final screenWidth = MediaQuery.of(context).size.width;
    final tabWidth = screenWidth / 5;
    final activeCenterX = (currentIndex + 0.5) * tabWidth;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      color: Colors.transparent,
      height: 72 + bottomPadding,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // Custom Curved White Background with Smooth Notch
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 68 + bottomPadding,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: activeCenterX, end: activeCenterX),
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeInOutCubic,
              builder: (context, animX, child) {
                return CustomPaint(
                  painter: CurvedNotchNavbarPainter(notchCenterX: animX),
                  size: Size(screenWidth, 68 + bottomPadding),
                );
              },
            ),
          ),

          // Icons Row
          Positioned(
            left: 0,
            right: 0,
            bottom: bottomPadding,
            height: 64,
            child: Row(
              children: [
                // Tab 0: Home Slot
                _buildTabSlot(0, Icons.home_outlined),

                // Tab 1: Shopping Bag
                _buildTabSlot(
                  1,
                  Icons.shopping_bag_outlined,
                  badgeCount: cartCount,
                ),

                // Tab 2: Bookmark / Saved
                _buildTabSlot(2, Icons.bookmark_outline_rounded),

                // Tab 3: Explore / Search
                _buildTabSlot(3, Icons.search_rounded),

                // Tab 4: Profile Avatar
                _buildAvatarSlot(4, appState.userProfile.avatarUrl),
              ],
            ),
          ),

          // Floating Orange Elevated Circle for Active Tab
          AnimatedPositioned(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeInOutCubic,
            left: activeCenterX - 27,
            bottom: bottomPadding + 22,
            child: GestureDetector(
              onTap: () => onTap(currentIndex),
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: AppColors.primaryAccent,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryAccent.withValues(alpha: 0.45),
                      offset: const Offset(0, 8),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    _getActiveIconForIndex(currentIndex),
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getActiveIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.home_outlined;
      case 1:
        return Icons.shopping_bag_outlined;
      case 2:
        return Icons.bookmark_outline_rounded;
      case 3:
        return Icons.search_rounded;
      case 4:
        return Icons.person_outline_rounded;
      default:
        return Icons.home_outlined;
    }
  }

  Widget _buildTabSlot(int index, IconData icon, {int badgeCount = 0}) {
    final isSelected = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          height: 60,
          child: Center(
            child: isSelected
                ? const SizedBox.shrink() // Hidden behind elevated floating bubble
                : Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        icon,
                        size: 24,
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
                            constraints:
                                const BoxConstraints(minWidth: 15, minHeight: 15),
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
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSlot(int index, String avatarUrl) {
    final isSelected = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          height: 60,
          child: Center(
            child: isSelected
                ? const SizedBox.shrink()
                : CircleAvatar(
                    radius: 12,
                    backgroundColor: const Color(0xFFE0E0E0),
                    backgroundImage: NetworkImage(avatarUrl),
                  ),
          ),
        ),
      ),
    );
  }
}

class CurvedNotchNavbarPainter extends CustomPainter {
  final double notchCenterX;

  CurvedNotchNavbarPainter({required this.notchCenterX});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.07)
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 14);

    final path = Path();
    const cornerRadius = 26.0;
    const notchRadius = 38.0;
    const notchDepth = 24.0;

    final leftNotchX = notchCenterX - notchRadius;
    final rightNotchX = notchCenterX + notchRadius;

    // Start bottom-left
    path.moveTo(0, size.height);
    path.lineTo(0, cornerRadius);

    // Top-left corner
    if (leftNotchX > cornerRadius) {
      path.quadraticBezierTo(0, 0, cornerRadius, 0);
      path.lineTo(leftNotchX, 0);
    } else {
      path.quadraticBezierTo(0, 0, (leftNotchX > 0 ? leftNotchX : 0), 0);
    }

    // Smooth Curved Notch Dip around active circle
    path.cubicTo(
      notchCenterX - 22,
      0,
      notchCenterX - 24,
      notchDepth,
      notchCenterX,
      notchDepth,
    );
    path.cubicTo(
      notchCenterX + 24,
      notchDepth,
      notchCenterX + 22,
      0,
      rightNotchX,
      0,
    );

    // Top-right corner
    if (rightNotchX < size.width - cornerRadius) {
      path.lineTo(size.width - cornerRadius, 0);
      path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);
    } else {
      path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);
    }

    // Bottom-right and close
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CurvedNotchNavbarPainter oldDelegate) {
    return oldDelegate.notchCenterX != notchCenterX;
  }
}
