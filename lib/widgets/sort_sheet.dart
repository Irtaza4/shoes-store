import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../state/app_state.dart';

class SortBottomSheet extends StatelessWidget {
  final SortOption currentSort;
  final ValueChanged<SortOption> onSortSelected;

  const SortBottomSheet({
    super.key,
    required this.currentSort,
    required this.onSortSelected,
  });

  static Future<void> show(BuildContext context) async {
    final appState = AppStateProvider.of(context);
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SortBottomSheet(
        currentSort: appState.currentSort,
        onSortSelected: (option) {
          appState.setSortOption(option);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.sheet)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.neutral100,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.horizontalPadding),
            child: Text(
              'Sort by',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ...SortOption.values.map((option) {
            final isSelected = currentSort == option;

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.horizontalPadding,
                vertical: 2,
              ),
              title: Text(
                option.label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? AppColors.primaryDark : AppColors.textSecondary,
                ),
              ),
              trailing: isSelected
                  ? const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.primaryDark,
                      size: 20,
                    )
                  : null,
              onTap: () => onSortSelected(option),
            );
          }),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
