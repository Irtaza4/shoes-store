import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/product.dart';
import '../widgets/image_fallback.dart';

class OrderTrackingScreen extends StatelessWidget {
  final Order order;

  const OrderTrackingScreen({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final timelineSteps = [
      {
        'status': OrderStatus.placed,
        'title': 'Order Placed',
        'desc': 'We received your order and are confirming inventory.',
        'time': 'Aug 17, 10:15 AM',
      },
      {
        'status': OrderStatus.processing,
        'title': 'Processing & Quality Check',
        'desc': 'Inspected, authenticated, and boxed in premium packaging.',
        'time': 'Aug 17, 02:40 PM',
      },
      {
        'status': OrderStatus.shipped,
        'title': 'Shipped & En Route',
        'desc': 'Package departed logistics sorting hub with express courier.',
        'time': 'Aug 18, 08:30 AM',
      },
      {
        'status': OrderStatus.outForDelivery,
        'title': 'Out for Delivery',
        'desc': 'Courier is in your area for contactless signature delivery.',
        'time': 'Estimated Today by 5:00 PM',
      },
      {
        'status': OrderStatus.delivered,
        'title': 'Delivered',
        'desc': 'Delivered securely to your address.',
        'time': 'Pending',
      },
    ];

    // Determine current progress index based on order status
    final currentStatusIndex = OrderStatus.values.indexOf(order.status);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Tracking #${order.id}',
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // High Level Status Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryDark,
                borderRadius: BorderRadius.circular(AppRadius.card),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryDark.withValues(alpha: 0.15),
                    offset: const Offset(0, 6),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryAccent,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Text(
                          order.status.title.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.local_shipping_outlined,
                        color: Colors.white,
                        size: 22,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Estimated Delivery',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.neutral200,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.estimatedDelivery,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: Color(0xFF2C2422), height: 1),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tracking Number',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.neutral200,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            order.trackingNumber,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Carrier',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.neutral200,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            order.carrier,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.sand,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Timeline Title
            const Text(
              'Activity Timeline',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 16),

            // Vertical Timeline Items
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: timelineSteps.length,
              itemBuilder: (context, index) {
                final step = timelineSteps[index];
                final isPassed = index <= currentStatusIndex;
                final isCurrent = index == currentStatusIndex;
                final isLast = index == timelineSteps.length - 1;

                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Timeline Indicator Node + Line
                      Column(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: isCurrent
                                  ? AppColors.primaryAccent
                                  : (isPassed
                                      ? AppColors.primaryDark
                                      : AppColors.surfaceLight),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isPassed
                                    ? Colors.transparent
                                    : AppColors.neutral100,
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: isPassed && !isCurrent
                                  ? const Icon(
                                      Icons.check,
                                      size: 16,
                                      color: Colors.white,
                                    )
                                  : isCurrent
                                      ? Container(
                                          width: 10,
                                          height: 10,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                        )
                                      : Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: AppColors.neutral200,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                            ),
                          ),
                          if (!isLast)
                            Expanded(
                              child: Container(
                                width: 2,
                                color: index < currentStatusIndex
                                    ? AppColors.primaryDark
                                    : AppColors.neutral100,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 16),

                      // Timeline Text Content
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    step['title'] as String,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: isCurrent
                                          ? FontWeight.bold
                                          : FontWeight.w600,
                                      color: isPassed
                                          ? AppColors.primaryDark
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                  Text(
                                    step['time'] as String,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isCurrent
                                          ? AppColors.primaryAccent
                                          : AppColors.neutral200,
                                      fontWeight: isCurrent
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                step['desc'] as String,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Order Items in Package
            const Text(
              'Items in this Package',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 12),
            ...order.items.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.neutral100),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 56,
                      height: 56,
                      child: ShoeImage(
                        imageUrl: item.product.images.first,
                        fit: BoxFit.cover,
                        borderRadius: AppRadius.sm,
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
                            'Size: ${item.selectedSize}  •  Qty: ${item.quantity}',
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
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
