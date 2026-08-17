import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../state/app_state.dart';

class NwsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showLogo;
  final bool showBackButton;
  final VoidCallback? onBack;
  final VoidCallback? onMenuTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onCartTap;
  final List<Widget>? actions;

  const NwsAppBar({
    super.key,
    this.title,
    this.showLogo = false,
    this.showBackButton = false,
    this.onBack,
    this.onMenuTap,
    this.onSearchTap,
    this.onCartTap,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final cartCount = appState.cartCount;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leading: showBackButton
          ? IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.neutral100),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 16,
                  color: AppColors.primaryDark,
                ),
              ),
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
            )
          : IconButton(
              icon: const Icon(
                Icons.grid_view_rounded,
                size: 22,
                color: AppColors.primaryDark,
              ),
              onPressed: onMenuTap ?? () => Scaffold.of(context).openDrawer(),
            ),
      title: showLogo
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'NWS',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3.0,
                    color: AppColors.primaryDark,
                  ),
                ),
                Container(
                  width: 14,
                  height: 2,
                  color: AppColors.primaryAccent,
                ),
              ],
            )
          : (title != null
              ? Text(
                  title!,
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                    letterSpacing: -0.2,
                  ),
                )
              : null),
      actions: actions ??
          [
            if (onSearchTap != null)
              IconButton(
                icon: const Icon(
                  Icons.search_rounded,
                  size: 24,
                  color: AppColors.primaryDark,
                ),
                onPressed: onSearchTap,
              ),
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.shopping_bag_outlined,
                    size: 23,
                    color: AppColors.primaryDark,
                  ),
                  onPressed: onCartTap ?? () => appState.setTabIndex(1),
                ),
                if (cartCount > 0)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryAccent,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$cartCount',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 8),
          ],
    );
  }
}
