import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onButtonPressed,
  });

  factory EmptyStateWidget.cart({required VoidCallback onExplore}) {
    return EmptyStateWidget(
      icon: Icons.shopping_bag_outlined,
      title: 'Your bag is empty',
      description: 'Find something you love and start shopping.',
      buttonText: 'Explore Shoes',
      onButtonPressed: onExplore,
    );
  }

  factory EmptyStateWidget.favorites({required VoidCallback onExplore}) {
    return EmptyStateWidget(
      icon: Icons.favorite_border_rounded,
      title: 'Nothing saved yet',
      description: 'Save products you love and they\'ll appear here.',
      buttonText: 'Explore Shoes',
      onButtonPressed: onExplore,
    );
  }

  factory EmptyStateWidget.search({required VoidCallback onReset}) {
    return EmptyStateWidget(
      icon: Icons.search_off_rounded,
      title: 'No shoes found',
      description: 'Try another search or adjust your filters to find what you\'re looking for.',
      buttonText: 'Reset Filters',
      onButtonPressed: onReset,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.neutral100),
              ),
              child: Icon(
                icon,
                size: 38,
                color: AppColors.sand,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: onButtonPressed,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
              ),
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}
