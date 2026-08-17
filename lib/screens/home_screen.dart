import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../state/app_state.dart';
import '../models/mock_data.dart';
import '../widgets/category_chip.dart';
import '../widgets/product_card.dart';
import '../widgets/image_fallback.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final products = appState.filteredProducts;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Top App Bar: Hamburger Menu & Search
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.horizontalPadding,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Staggered Hamburger Menu Icon (Opens Side Drawer)
                    Builder(
                      builder: (scaffoldCtx) => GestureDetector(
                        onTap: () => Scaffold.of(scaffoldCtx).openDrawer(),
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 22,
                                height: 2.5,
                                decoration: BoxDecoration(
                                  color: AppColors.textPrimary,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: 14,
                                height: 2.5,
                                decoration: BoxDecoration(
                                  color: AppColors.textPrimary,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: 18,
                                height: 2.5,
                                decoration: BoxDecoration(
                                  color: AppColors.textPrimary,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Search Action
                    IconButton(
                      icon: const Icon(
                        Icons.search_rounded,
                        size: 26,
                        color: AppColors.textPrimary,
                      ),
                      onPressed: () => appState.setTabIndex(3),
                    ),
                  ],
                ),
              ),
            ),

            // Hero Banner: "New Release - Nike Air Max 90 - Shop Now"
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.horizontalPadding,
                  vertical: 8,
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(
                          product: MockData.products[2],
                          heroTag: 'product_image_banner_${MockData.products[2].id}',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 175,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1817),
                      borderRadius: BorderRadius.circular(24),
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFF161312),
                          Color(0xFF2E1914),
                          Color(0xFF6B291A),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryDark.withValues(alpha: 0.15),
                          offset: const Offset(0, 8),
                          blurRadius: 18,
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        // Background Ghost Watermark "NIKE"
                        Positioned(
                          top: -10,
                          right: -10,
                          child: Text(
                            'NIKE',
                            style: GoogleFonts.inter(
                              fontSize: 90,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 4.0,
                              color: Colors.white.withValues(alpha: 0.05),
                            ),
                          ),
                        ),

                        // Left Text Content
                        Positioned(
                          left: 20,
                          top: 24,
                          bottom: 24,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'New Release',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white.withValues(alpha: 0.7),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Nike Air\nMax 90',
                                    style: GoogleFonts.inter(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      height: 1.15,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.full),
                                ),
                                child: const Text(
                                  'Shop Now',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Right Sneaker Image
                        Positioned(
                          right: -8,
                          top: 10,
                          bottom: 10,
                          width: 190,
                          child: Transform.rotate(
                            angle: -0.15,
                            child: Hero(
                              tag: 'product_image_banner_${MockData.products[2].id}',
                              child: ShoeImage(
                                imageUrl: MockData.products[2].images.first,
                                fit: BoxFit.contain,
                                borderRadius: 0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Category Selector Horizontal Pills
            SliverToBoxAdapter(
              child: CategoryChipBar(
                selectedCategory: appState.selectedCategory,
                onSelected: (cat) => appState.setCategory(cat),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Section Header: "New Men's" & "See all"
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.horizontalPadding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'New Men\'s',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => appState.setTabIndex(3),
                      child: const Text(
                        'See all',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // 2-Column Product Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.horizontalPadding,
              ),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: AppSpacing.gridGap,
                  mainAxisSpacing: AppSpacing.gridGap,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = products[index % products.length];
                    final gridHeroTag = 'product_image_grid_${product.id}';
                    return ProductCard(
                      product: product,
                      heroTag: gridHeroTag,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailScreen(
                              product: product,
                              heroTag: gridHeroTag,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  childCount: products.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}
