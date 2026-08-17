import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../state/app_state.dart';
import 'image_fallback.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final String? heroTag;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final effectiveHeroTag = heroTag ?? 'product_image_grid_${product.id}';

    final cardContent = Container(
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sneaker Image on Light Card Surface
                Expanded(
                  flex: 62,
                  child: Stack(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Transform.rotate(
                            angle: -0.08,
                            child: Hero(
                              tag: effectiveHeroTag,
                              child: ShoeImage(
                                imageUrl: product.images.first,
                                fit: BoxFit.contain,
                                borderRadius: AppRadius.md,
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (product.isSale)
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primaryAccent,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.sm),
                            ),
                            child: const Text(
                              'SALE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Product Details Area
                Expanded(
                  flex: 38,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Category Tag (e.g. Men's Shoes)
                        const Text(
                          'Men\'s Shoes',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryAccent,
                          ),
                        ),
                        const SizedBox(height: 2),

                        // Shoe Name
                        Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Price
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Attached Corner Quick-Add Plus Button (Docked to Bottom-Right)
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () {
                  appState.addToCart(
                    product,
                    product.availableColors.first,
                    product.availableSizes.first,
                  );

                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.primaryDark,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppRadius.button),
                      ),
                      margin: const EdgeInsets.all(
                          AppSpacing.horizontalPadding),
                      content: Row(
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.primaryAccent,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Added ${product.name} to bag',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      action: SnackBarAction(
                        label: 'View Bag',
                        textColor: AppColors.primaryAccent,
                        onPressed: () => appState.setTabIndex(1),
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryDark,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomRight: Radius.circular(AppRadius.card),
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return LongPressDraggable<Product>(
      data: product,
      delay: const Duration(milliseconds: 160),
      hapticFeedbackOnStart: true,
      onDragStarted: () {
        HapticFeedback.mediumImpact();
      },
      feedback: Material(
        type: MaterialType.transparency,
        child: SizedBox(
          width: 140,
          height: 100,
          child: Transform.rotate(
            angle: -0.15,
            child: ShoeImage(
              imageUrl: product.images.first,
              fit: BoxFit.contain,
              borderRadius: 0,
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.35,
        child: cardContent,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: cardContent,
      ),
    );
  }
}
