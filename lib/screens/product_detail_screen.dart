import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../state/app_state.dart';
import '../widgets/image_fallback.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final String? heroTag;

  const ProductDetailScreen({
    super.key,
    required this.product,
    this.heroTag,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedColorIndex = 0;
  late int _selectedSize;
  String _selectedUnit = 'EU';
  bool _isDescriptionExpanded = false;
  bool _isAdding = false;

  @override
  void initState() {
    super.initState();
    _selectedSize = 42; // default active size from reference
  }

  void _onAddToBag(AppState appState) async {
    setState(() {
      _isAdding = true;
    });

    appState.addToCart(
      widget.product,
      widget.product.availableColors[_selectedColorIndex % widget.product.availableColors.length],
      _selectedSize,
    );

    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    setState(() {
      _isAdding = false;
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
            const Icon(Icons.check_circle_rounded,
                color: AppColors.primaryAccent, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Added ${widget.product.name} (Size $_selectedSize) to bag',
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
            appState.setTabIndex(1);
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final product = widget.product;
    final sizeList = [40, 41, 42, 43, 45, 46];
    final selectedColor = product.availableColors[_selectedColorIndex % product.availableColors.length];
    final currentShoeImage = product.images[_selectedColorIndex % product.images.length];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left_rounded,
            size: 28,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Men\'s Shoes',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryAccent,
          ),
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.shopping_bag_outlined,
                  size: 24,
                  color: AppColors.textPrimary,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  appState.setTabIndex(1);
                },
              ),
              if (appState.cartCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryAccent,
                      shape: BoxShape.circle,
                    ),
                    constraints:
                        const BoxConstraints(minWidth: 15, minHeight: 15),
                    child: Text(
                      '${appState.cartCount}',
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
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.horizontalPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                // Hero Sneaker Showcase with Oval Shadow
                Center(
                  child: SizedBox(
                    height: 220,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Soft Floor Shadow
                        Positioned(
                          bottom: 20,
                          child: Container(
                            width: 210,
                            height: 35,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryAccent
                                      .withValues(alpha: 0.18),
                                  blurRadius: 32,
                                  spreadRadius: 8,
                                ),
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 22,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Pure Transparent Hero Sneaker Image - updates dynamically on color selection
                        Transform.rotate(
                          angle: -0.12,
                          child: Hero(
                            tag: widget.heroTag ??
                                'product_image_grid_${product.id}',
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 220),
                              child: ShoeImage(
                                key: ValueKey('hero_shoe_$currentShoeImage'),
                                imageUrl: currentShoeImage,
                                height: 195,
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
                const SizedBox(height: 24),

                // Product Title
                Text(
                  product.name,
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),

                // Rating & Review Count
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: AppColors.starGold,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${product.rating}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${product.reviewCount} Reviews)',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Description with "... Read More"
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.45,
                    ),
                    children: [
                      TextSpan(
                        text: _isDescriptionExpanded
                            ? product.description
                            : '${product.description.substring(0, 105)}... ',
                      ),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isDescriptionExpanded =
                                  !_isDescriptionExpanded;
                            });
                          },
                          child: Text(
                            _isDescriptionExpanded ? 'Read Less' : 'Read More',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryAccent,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Select Color Row & Dynamic Colorway Swatches
                Row(
                  children: [
                    const Text(
                      'Select Color :',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      selectedColor.name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Horizontally Scrollable Colorway Cards (Prevents Any RenderFlex Overflow)
                SizedBox(
                  height: 48,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: product.availableColors.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final isSelected = _selectedColorIndex == index;
                      final colorItem = product.availableColors[index];
                      final swatchImage =
                          product.images[index % product.images.length];

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedColorIndex = index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryAccent.withValues(alpha: 0.08)
                                : AppColors.cardSurface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryAccent
                                  : Colors.transparent,
                              width: 1.8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Mini Colorway Sneaker Thumbnail
                              SizedBox(
                                width: 38,
                                height: 32,
                                child: ShoeImage(
                                  imageUrl: swatchImage,
                                  fit: BoxFit.contain,
                                  borderRadius: 4,
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Color Dot
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: colorItem.color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.black26,
                                    width: 0.8,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              // Color Name
                              Text(
                                colorItem.name,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                  color: isSelected
                                      ? AppColors.primaryAccent
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Size Row with Unit Switcher
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Size :',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Row(
                      children: ['EU', 'US', 'UK'].map((unit) {
                        final isUnitSelected = _selectedUnit == unit;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedUnit = unit),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              unit,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isUnitSelected
                                    ? FontWeight.w800
                                    : FontWeight.w500,
                                color: isUnitSelected
                                    ? AppColors.textPrimary
                                    : AppColors.neutral200,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Size Grid Chips
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: sizeList.map((size) {
                    final isSelected = _selectedSize == size;

                    return GestureDetector(
                      onTap: () => setState(() => _selectedSize = size),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryAccent
                              : AppColors.cardSurface,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.primaryAccent
                                        .withValues(alpha: 0.35),
                                    offset: const Offset(0, 3),
                                    blurRadius: 8,
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            '$size',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 120), // Bottom space for fixed bar
              ],
            ),
          ),

          // Dark Capsule Bottom Sticky Bar: Price on Left, Orange "Add to Bag" on Right
          Positioned(
            bottom: 24,
            left: AppSpacing.horizontalPadding,
            right: AppSpacing.horizontalPadding,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primaryDark,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    offset: const Offset(0, 8),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Price Column on Left
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Price',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF9E9E9E),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  // Orange "Add to Bag" CTA Button on Right
                  ElevatedButton(
                    onPressed: _isAdding ? null : () => _onAddToBag(appState),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                    ),
                    child: _isAdding
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Add to Bag',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
