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

    return SizedBox(
      height: 94,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // Custom Curved White Background with Notch
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 70,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: activeCenterX, end: activeCenterX),
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeInOutCubic,
              builder: (context, animX, child) {
                return CustomPaint(
                  painter: CurvedNotchNavbarPainter(notchCenterX: animX),
                  size: Size(screenWidth, 70),
                );
              },
            ),
          ),

          // Icons Row
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 70,
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  // Tab 0: Home Slot
                  _buildTabSlot(0, Icons.home_outlined, isSpecial: true),

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
          ),

          // Floating Orange Elevated Circle for Active Tab
          AnimatedPositioned(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeInOutCubic,
            left: activeCenterX - 27,
            bottom: 30,
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
                      color: AppColors.primaryAccent.withValues(alpha: 0.42),
                      offset: const Offset(0, 6),
                      blurRadius: 14,
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
        return Icons.home_rounded;
      case 1:
        return Icons.shopping_bag_rounded;
      case 2:
        return Icons.bookmark_rounded;
      case 3:
        return Icons.search_rounded;
      case 4:
        return Icons.person_rounded;
      default:
        return Icons.home_rounded;
    }
  }

  Widget _buildTabSlot(int index, IconData icon,
      {bool isSpecial = false, int badgeCount = 0}) {
    final isSelected = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          height: 60,
          child: Center(
            child: isSelected
                ? const SizedBox.shrink() // Hidden behind floating bubble
                : Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        icon,
                        size: 24,
                        color: const Color(0xFFB5B5BE),
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
      ..color = Colors.black.withValues(alpha: 0.06)
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 16);

    final path = Path();
    const cornerRadius = 24.0;
    const notchRadius = 34.0;
    const notchDepth = 22.0;

    final leftNotchX = notchCenterX - notchRadius;
    final rightNotchX = notchCenterX + notchRadius;

    // Start bottom-left
    path.moveTo(0, size.height);
    path.lineTo(0, cornerRadius);

    // Top-left rounded corner if notch is not on the very edge
    if (leftNotchX > cornerRadius) {
      path.quadraticBezierTo(0, 0, cornerRadius, 0);
      path.lineTo(leftNotchX, 0);
    } else {
      path.lineTo(0, 0);
      if (leftNotchX > 0) {
        path.lineTo(leftNotchX, 0);
      }
    }

    // Smooth Curved Notch Dip around active circle
    path.cubicTo(
      notchCenterX - 20,
      0,
      notchCenterX - 22,
      notchDepth,
      notchCenterX,
      notchDepth,
    );
    path.cubicTo(
      notchCenterX + 22,
      notchDepth,
      notchCenterX + 20,
      0,
      rightNotchX,
      0,
    );

    // Continue across to top-right
    if (rightNotchX < size.width - cornerRadius) {
      path.lineTo(size.width - cornerRadius, 0);
      path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);
    } else {
      path.lineTo(size.width, 0);
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
