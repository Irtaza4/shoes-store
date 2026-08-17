import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../state/app_state.dart';
import '../widgets/image_fallback.dart';
import '../widgets/empty_state.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _promoController = TextEditingController();
  String? _promoMessage;
  bool _isPromoSuccess = false;

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _handleApplyPromo(AppState appState) {
    final code = _promoController.text.trim();
    if (code.isEmpty) return;

    final success = appState.applyPromoCode(code);
    setState(() {
      _isPromoSuccess = success;
      if (success) {
        _promoMessage = code.toUpperCase() == 'NWS20'
            ? '20% OFF Discount applied!'
            : 'Free shipping applied!';
      } else {
        _promoMessage = 'Invalid promo code. Try "NWS20"';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final items = appState.cartItems;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Your Cart (${appState.cartCount})',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
        actions: [
          if (items.isNotEmpty)
            IconButton(
              icon: const Icon(
                Icons.delete_sweep_outlined,
                color: AppColors.textSecondary,
                size: 22,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: AppColors.surfaceLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.card),
                    ),
                    title: const Text('Clear Cart'),
                    content: const Text(
                      'Are you sure you want to remove all items from your bag?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          appState.clearCart();
                          Navigator.pop(ctx);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryAccent,
                        ),
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: items.isEmpty
          ? EmptyStateWidget.cart(
              onExplore: () => appState.setTabIndex(0),
            )
          : Column(
              children: [
                // Cart Items List
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.horizontalPadding),
                    itemCount: items.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = items[index];

                      return Dismissible(
                        key: Key('cart_${item.product.id}_${item.selectedSize}_$index'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: AppColors.primaryAccent,
                            borderRadius: BorderRadius.circular(AppRadius.card),
                          ),
                          child: const Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        onDismissed: (_) {
                          appState.removeFromCart(index);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(AppRadius.card),
                            border: Border.all(color: AppColors.neutral100),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Product Image
                              SizedBox(
                                width: 84,
                                height: 84,
                                child: ShoeImage(
                                  imageUrl: item.product.images.first,
                                  fit: BoxFit.cover,
                                  borderRadius: AppRadius.md,
                                ),
                              ),
                              const SizedBox(width: 14),

                              // Item Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          item.product.brand.toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.sand,
                                            letterSpacing: 0.8,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () =>
                                              appState.removeFromCart(index),
                                          child: const Icon(
                                            Icons.close,
                                            size: 16,
                                            color: AppColors.neutral200,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      item.product.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryDark,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Size: ${item.selectedSize}  •  ${item.selectedColor.name}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),

                                    // Stepper & Price
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '\$${item.totalPrice.toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.primaryDark,
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.cardSurface,
                                            borderRadius: BorderRadius.circular(
                                                AppRadius.full),
                                            border: Border.all(
                                                color: AppColors.neutral100),
                                          ),
                                          child: Row(
                                            children: [
                                              _buildStepperButton(
                                                icon: Icons.remove,
                                                onTap: () => appState
                                                    .updateCartQuantity(
                                                        index, -1),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Text(
                                                  '${item.quantity}',
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.primaryDark,
                                                  ),
                                                ),
                                              ),
                                              _buildStepperButton(
                                                icon: Icons.add,
                                                onTap: () => appState
                                                    .updateCartQuantity(
                                                        index, 1),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Order Summary & Checkout Bottom Sheet Area
                Container(
                  padding: const EdgeInsets.all(AppSpacing.horizontalPadding),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppRadius.sheet),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Promo code input
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.cardSurface,
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.md),
                                  border:
                                      Border.all(color: AppColors.neutral100),
                                ),
                                child: TextField(
                                  controller: _promoController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter promo code (e.g. NWS20)',
                                    hintStyle: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.neutral200,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.discount_outlined,
                                      size: 18,
                                      color: AppColors.textSecondary,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding:
                                        const EdgeInsets.symmetric(vertical: 10),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => _handleApplyPromo(appState),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryDark,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.md),
                                ),
                              ),
                              child: const Text(
                                'Apply',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                        if (_promoMessage != null) ...[
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                _isPromoSuccess
                                    ? Icons.check_circle_rounded
                                    : Icons.error_outline_rounded,
                                size: 14,
                                color: _isPromoSuccess
                                    ? AppColors.success
                                    : AppColors.error,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _promoMessage!,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: _isPromoSuccess
                                      ? AppColors.success
                                      : AppColors.error,
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 16),

                        // Subtotal, Shipping, Discount Breakdown
                        _buildSummaryRow(
                          'Subtotal',
                          '\$${appState.subtotal.toStringAsFixed(0)}',
                        ),
                        const SizedBox(height: 6),
                        _buildSummaryRow(
                          'Shipping',
                          appState.shippingFee == 0
                              ? 'FREE'
                              : '\$${appState.shippingFee.toStringAsFixed(0)}',
                        ),
                        if (appState.discountAmount > 0) ...[
                          const SizedBox(height: 6),
                          _buildSummaryRow(
                            'Promo Discount (${appState.appliedPromoCode})',
                            '-\$${appState.discountAmount.toStringAsFixed(0)}',
                            isAccent: true,
                          ),
                        ],
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(height: 1),
                        ),

                        // Total & CTA
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                              ),
                            ),
                            Text(
                              '\$${appState.total.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Checkout Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CheckoutScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('Proceed to Checkout'),
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

  Widget _buildStepperButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: Icon(icon, size: 14, color: AppColors.primaryDark),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isAccent = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isAccent ? AppColors.primaryAccent : AppColors.textSecondary,
            fontWeight: isAccent ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isAccent ? AppColors.primaryAccent : AppColors.primaryDark,
          ),
        ),
      ],
    );
  }
}
