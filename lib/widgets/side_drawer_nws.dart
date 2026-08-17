import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../state/app_state.dart';
import '../models/mock_data.dart';
import '../screens/order_tracking_screen.dart';

class NwsSideDrawer extends StatelessWidget {
  const NwsSideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final profile = appState.userProfile;
    final cartCount = appState.cartCount;

    return Drawer(
      backgroundColor: const Color(0xFF161312),
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drawer Top Bar: Brand Logo & Close Action
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'NWS',
                        style: GoogleFonts.inter(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3.5,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        width: 22,
                        height: 2.5,
                        decoration: BoxDecoration(
                          color: AppColors.primaryAccent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white70,
                        size: 20,
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Profile Snapshot Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  appState.setTabIndex(4);
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF221A18),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryAccent,
                        ),
                        child: CircleAvatar(
                          radius: 22,
                          backgroundImage: NetworkImage(profile.avatarUrl),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              profile.email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white38,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Divider(color: Colors.white12, height: 1),
            ),
            const SizedBox(height: 12),

            // Navigation Links
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildDrawerItem(
                    context,
                    icon: Icons.home_rounded,
                    title: 'Home',
                    isSelected: appState.currentTabIndex == 0,
                    onTap: () {
                      Navigator.of(context).pop();
                      appState.setTabIndex(0);
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.shopping_bag_rounded,
                    title: 'My Bag',
                    badge: cartCount > 0 ? '$cartCount' : null,
                    isSelected: appState.currentTabIndex == 1,
                    onTap: () {
                      Navigator.of(context).pop();
                      appState.setTabIndex(1);
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.bookmark_rounded,
                    title: 'Saved & Wishlist',
                    isSelected: appState.currentTabIndex == 2,
                    onTap: () {
                      Navigator.of(context).pop();
                      appState.setTabIndex(2);
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.search_rounded,
                    title: 'Explore & Filter',
                    isSelected: appState.currentTabIndex == 3,
                    onTap: () {
                      Navigator.of(context).pop();
                      appState.setTabIndex(3);
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.local_shipping_rounded,
                    title: 'Track Orders',
                    onTap: () {
                      Navigator.of(context).pop();
                      if (MockData.initialOrders.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OrderTrackingScreen(
                              order: MockData.initialOrders.first,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.flash_on_rounded,
                    title: 'New Releases',
                    onTap: () {
                      Navigator.of(context).pop();
                      appState.setCategory('Lifestyle');
                      appState.setTabIndex(0);
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.person_rounded,
                    title: 'Account Settings',
                    isSelected: appState.currentTabIndex == 4,
                    onTap: () {
                      Navigator.of(context).pop();
                      appState.setTabIndex(4);
                    },
                  ),

                  const SizedBox(height: 14),

                  // Promo Banner in Drawer
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2E1914), Color(0xFF6B291A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primaryAccent.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.local_offer_rounded,
                                color: AppColors.primaryAccent, size: 16),
                            SizedBox(width: 8),
                            Text(
                              'Special Discount',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Use code NWS20 at checkout for 20% OFF your entire order!',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Footer Info
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'NWS Sneaker App v1.0',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                  Text(
                    'LIVE YOUR PERFECT',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                      color: AppColors.primaryAccent.withValues(alpha: 0.8),
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

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? badge,
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryAccent.withValues(alpha: 0.18)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              border: isSelected
                  ? Border.all(
                      color: AppColors.primaryAccent.withValues(alpha: 0.4),
                    )
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected ? AppColors.primaryAccent : Colors.white70,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ),
                if (badge != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primaryAccent,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
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
}
