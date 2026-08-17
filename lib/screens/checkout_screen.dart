import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../state/app_state.dart';
import '../models/product.dart';
import '../models/mock_data.dart';
import 'order_confirmation_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _currentStep = 0; // 0: Address, 1: Delivery & Payment, 2: Review

  // Address Controllers
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _streetController;
  late final TextEditingController _cityController;
  late final TextEditingController _zipController;

  String _selectedDelivery = 'Standard';
  String _selectedPayment = 'Apple Pay';
  bool _isProcessingOrder = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _streetController = TextEditingController();
    _cityController = TextEditingController();
    _zipController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final userProfile = AppStateProvider.of(context).userProfile;
      final defaultAddr = userProfile.addresses.isNotEmpty
          ? userProfile.addresses.first
          : MockData.initialAddress;
      _nameController.text = defaultAddr.name;
      _phoneController.text = defaultAddr.phone;
      _streetController.text = defaultAddr.street;
      _cityController.text = defaultAddr.city;
      _zipController.text = defaultAddr.postalCode;
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  void _placeOrder(AppState appState) async {
    setState(() {
      _isProcessingOrder = true;
    });

    final address = Address(
      id: 'addr_new_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      street: _streetController.text.trim(),
      city: _cityController.text.trim(),
      postalCode: _zipController.text.trim(),
    );

    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    final createdOrder = appState.placeOrder(
      address: address,
      paymentMethod: _selectedPayment,
      deliveryOption: _selectedDelivery,
    );

    setState(() {
      _isProcessingOrder = false;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => OrderConfirmationScreen(order: createdOrder),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final items = appState.cartItems;
    final shipping = _selectedDelivery == 'Express' ? 20.0 : appState.shippingFee;
    final total = appState.subtotal + shipping - appState.discountAmount;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
      ),
      body: Column(
        children: [
          // Step Progress Bar
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.horizontalPadding,
              vertical: 14,
            ),
            color: AppColors.surfaceLight,
            child: Row(
              children: [
                _buildStepIndicator(0, 'Address'),
                _buildStepDivider(0),
                _buildStepIndicator(1, 'Payment'),
                _buildStepDivider(1),
                _buildStepIndicator(2, 'Review'),
              ],
            ),
          ),
          const Divider(height: 1),

          // Step Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.horizontalPadding),
              child: _currentStep == 0
                  ? _buildAddressStep()
                  : _currentStep == 1
                      ? _buildDeliveryPaymentStep()
                      : _buildReviewStep(appState, items, shipping, total),
            ),
          ),

          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.all(AppSpacing.horizontalPadding),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              border: const Border(
                top: BorderSide(color: AppColors.neutral100, width: 0.8),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  offset: const Offset(0, -4),
                  blurRadius: 12,
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  if (_currentStep > 0) ...[
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _currentStep -= 1;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Back'),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _isProcessingOrder
                          ? null
                          : () {
                              if (_currentStep < 2) {
                                setState(() {
                                  _currentStep += 1;
                                });
                              } else {
                                _placeOrder(appState);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isProcessingOrder
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              _currentStep == 2
                                  ? 'Place Order — \$${total.toStringAsFixed(0)}'
                                  : 'Continue',
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

  Widget _buildStepIndicator(int stepIndex, String title) {
    final isDone = _currentStep > stepIndex;
    final isActive = _currentStep == stepIndex;

    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isActive || isDone
                ? AppColors.primaryDark
                : AppColors.neutral100,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isDone
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : Text(
                    '${stepIndex + 1}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isActive ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive ? AppColors.primaryDark : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStepDivider(int stepIndex) {
    final isPassed = _currentStep > stepIndex;
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: isPassed ? AppColors.primaryDark : AppColors.neutral100,
      ),
    );
  }

  Widget _buildAddressStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Shipping Address',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Where should we deliver your luxury pair?',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 20),
        _buildTextField('Full Name', _nameController, Icons.person_outline),
        const SizedBox(height: 14),
        _buildTextField('Phone Number', _phoneController, Icons.phone_outlined),
        const SizedBox(height: 14),
        _buildTextField(
            'Street Address', _streetController, Icons.location_on_outlined),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: _buildTextField(
                  'City & State', _cityController, Icons.location_city_outlined),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: _buildTextField('Postal Code', _zipController, Icons.markunread_mailbox_outlined),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDeliveryPaymentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Delivery Method
        const Text(
          'Delivery Speed',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: 12),
        _buildDeliveryCard(
          title: 'Standard Ground Delivery',
          subtitle: 'Estimated 3–5 Business Days',
          price: '\$10 (or FREE over \$200)',
          value: 'Standard',
        ),
        const SizedBox(height: 10),
        _buildDeliveryCard(
          title: 'Express Overnight Priority',
          subtitle: 'Estimated 1–2 Business Days',
          price: '\$20',
          value: 'Express',
        ),
        const SizedBox(height: 28),

        // Payment Methods
        const Text(
          'Payment Method',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: 12),
        _buildPaymentOption(
          title: 'Apple Pay',
          icon: Icons.apple_rounded,
          value: 'Apple Pay',
        ),
        const SizedBox(height: 8),
        _buildPaymentOption(
          title: 'Google Pay',
          icon: Icons.account_balance_wallet_outlined,
          value: 'Google Pay',
        ),
        const SizedBox(height: 8),
        _buildPaymentOption(
          title: 'Credit / Debit Card (•••• 4242)',
          icon: Icons.credit_card_rounded,
          value: 'Credit Card',
        ),
        const SizedBox(height: 8),
        _buildPaymentOption(
          title: 'Cash on Delivery',
          icon: Icons.local_atm_outlined,
          value: 'Cash on Delivery',
        ),
      ],
    );
  }

  Widget _buildDeliveryCard({
    required String title,
    required String subtitle,
    required String price,
    required String value,
  }) {
    final isSelected = _selectedDelivery == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDelivery = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: isSelected ? AppColors.primaryDark : AppColors.neutral100,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: isSelected ? Colors.white : AppColors.neutral200,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected
                          ? AppColors.neutral100
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              price,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.sand : AppColors.primaryDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required IconData icon,
    required String value,
  }) {
    final isSelected = _selectedPayment == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPayment = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryDark.withValues(alpha: 0.05)
              : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? AppColors.primaryDark : AppColors.neutral100,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primaryDark),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
            Icon(
              isSelected
                  ? Icons.check_circle_rounded
                  : Icons.circle_outlined,
              size: 20,
              color: isSelected ? AppColors.primaryDark : AppColors.neutral200,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewStep(
    AppState appState,
    List<CartItem> items,
    double shipping,
    double total,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Order Summary',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: 12),

        // Items list
        ...items.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.cardSurface,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Image.network(
                    item.product.images.first,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.roller_skating_outlined),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.product.name,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      Text(
                        'Size ${item.selectedSize}  •  Qty: ${item.quantity}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '\$${item.totalPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
          );
        }),
        const Divider(height: 24),

        // Delivery & Shipping to
        const Text(
          'Deliver to',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${_nameController.text}\n${_streetController.text}, ${_cityController.text} ${_zipController.text}\n${_phoneController.text}',
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        const Divider(height: 24),

        // Method & Payment Info
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Shipping Speed',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                  ),
                ),
                Text(
                  _selectedDelivery,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'Payment',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                  ),
                ),
                Text(
                  _selectedPayment,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ],
        ),
        const Divider(height: 24),

        // Price breakdown
        _buildReviewRow('Subtotal', '\$${appState.subtotal.toStringAsFixed(0)}'),
        const SizedBox(height: 6),
        _buildReviewRow(
          'Shipping',
          shipping == 0 ? 'FREE' : '\$${shipping.toStringAsFixed(0)}',
        ),
        if (appState.discountAmount > 0) ...[
          const SizedBox(height: 6),
          _buildReviewRow(
            'Promo Discount',
            '-\$${appState.discountAmount.toStringAsFixed(0)}',
            isAccent: true,
          ),
        ],
        const SizedBox(height: 8),
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
              '\$${total.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: AppColors.primaryDark,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewRow(String label, String val, {bool isAccent = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isAccent ? AppColors.primaryAccent : AppColors.textSecondary,
          ),
        ),
        Text(
          val,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isAccent ? AppColors.primaryAccent : AppColors.primaryDark,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 18, color: AppColors.textSecondary),
      ),
    );
  }
}
