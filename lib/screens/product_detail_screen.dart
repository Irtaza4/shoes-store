import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../state/app_state.dart';
import '../widgets/image_fallback.dart';
import '../widgets/size_selector.dart';
import '../widgets/color_selector.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final PageController _imageController = PageController();
  int _currentImageIndex = 0;
  late ProductColor _selectedColor;
  late int _selectedSize;
  bool _isDetailsExpanded = false;
  bool _isAddingToCart = false;
  bool _justAdded = false;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.product.availableColors.first;
    // Pick the first available size that isn't out of stock
    _selectedSize = widget.product.availableSizes.firstWhere(
      (s) => !widget.product.outOfStockSizes.contains(s),
      orElse: () => widget.product.availableSizes.first,
    );
  }

  void _onAddToCart(AppState appState) async {
    if (widget.product.isOutOfStock) return;

    setState(() {
      _isAddingToCart = true;
    });

    appState.addToCart(
      widget.product,
      _selectedColor,
      _selectedSize,
    );

    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    setState(() {
      _isAddingToCart = false;
      _justAdded = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primaryDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
        margin: const EdgeInsets.all(AppSpacing.horizontalPadding),
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Added ${widget.product.name} (EU $_selectedSize) to bag',
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'View Bag',
          textColor: AppColors.primaryAccent,
          onPressed: () {
            Navigator.pop(context);
            appState.setTabIndex(3);
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 1800));
    if (mounted) {
      setState(() {
        _justAdded = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final isFav = appState.isFavorite(widget.product.id);
    final product = widget.product;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Scrollable Content
          CustomScrollView(
            slivers: [
              // Top Gallery App Bar
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                backgroundColor: AppColors.cardSurface,
                scrolledUnderElevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 16,
                        color: AppColors.primaryDark,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          size: 20,
                          color: isFav ? AppColors.primaryAccent : AppColors.primaryDark,
                        ),
                        onPressed: () => appState.toggleFavorite(product.id),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      // Image Gallery PageView
                      PageView.builder(
                        controller: _imageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                        itemCount: product.images.length,
                        itemBuilder: (context, index) {
                          return InteractiveViewer(
                            minScale: 1.0,
                            maxScale: 3.0,
                            child: ShoeImage(
                              imageUrl: product.images[index],
                              fit: BoxFit.cover,
                              borderRadius: 0,
                            ),
                          );
                        },
                      ),

                      // Indicators
                      Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            product.images.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              width: _currentImageIndex == index ? 20 : 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: _currentImageIndex == index
                                    ? AppColors.primaryDark
                                    : AppColors.neutral200.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Product Info & Controls
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.horizontalPadding),
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Brand & Ratings
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product.brand.toUpperCase(),
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                              color: AppColors.sand,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded,
                                  color: Color(0xFFE5A83B), size: 18),
                              const SizedBox(width: 4),
                              Text(
                                '${product.rating}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(${product.reviewCount})',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Product Title & Price
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                                height: 1.15,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${product.price.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                              if (product.originalPrice != null)
                                Text(
                                  '\$${product.originalPrice!.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.neutral200,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Color Swatches
                      ColorSelector(
                        colors: product.availableColors,
                        selectedColor: _selectedColor,
                        onColorSelected: (col) {
                          setState(() {
                            _selectedColor = col;
                          });
                        },
                      ),
                      const SizedBox(height: 24),

                      // Size Selector Grid
                      SizeSelector(
                        sizes: product.availableSizes,
                        outOfStockSizes: product.outOfStockSizes,
                        selectedSize: _selectedSize,
                        onSizeSelected: (size) {
                          setState(() {
                            _selectedSize = size;
                          });
                        },
                      ),
                      const SizedBox(height: 28),

                      // Description
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Expandable Specs / Details
                      InkWell(
                        onTap: () {
                          setState(() {
                            _isDetailsExpanded = !_isDetailsExpanded;
                          });
                        },
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            border: Border.all(color: AppColors.neutral100),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Product Specifications',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                  Icon(
                                    _isDetailsExpanded
                                        ? Icons.keyboard_arrow_up_rounded
                                        : Icons.keyboard_arrow_down_rounded,
                                    color: AppColors.primaryDark,
                                  ),
                                ],
                              ),
                              if (_isDetailsExpanded) ...[
                                const SizedBox(height: 12),
                                const Divider(height: 1),
                                const SizedBox(height: 12),
                                ...product.specs.entries.map((entry) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 90,
                                          child: Text(
                                            entry.key,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            entry.value,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.primaryDark,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 100), // Space for sticky CTA
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Sticky Fixed Bottom Add to Cart CTA
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.horizontalPadding),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    offset: const Offset(0, -4),
                    blurRadius: 16,
                  ),
                ],
                border: const Border(
                  top: BorderSide(color: AppColors.neutral100, width: 0.8),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    // Price display
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Price',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '\$${product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),

                    // Add to Cart Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: product.isOutOfStock || _isAddingToCart
                            ? null
                            : () => _onAddToCart(appState),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _justAdded
                              ? AppColors.success
                              : AppColors.primaryDark,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: _isAddingToCart
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : _justAdded
                                  ? const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.check,
                                            color: Colors.white, size: 18),
                                        SizedBox(width: 8),
                                        Text('Added to Bag'),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                            Icons.shopping_bag_outlined,
                                            size: 18),
                                        const SizedBox(width: 8),
                                        Text(
                                          product.isOutOfStock
                                              ? 'Out of Stock'
                                              : 'Add to Cart — \$${product.price.toStringAsFixed(0)}',
                                        ),
                                      ],
                                    ),
                        ),
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
}
