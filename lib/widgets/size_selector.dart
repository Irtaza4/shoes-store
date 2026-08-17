import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SizeSelector extends StatelessWidget {
  final List<int> sizes;
  final List<int> outOfStockSizes;
  final int? selectedSize;
  final ValueChanged<int> onSizeSelected;

  const SizeSelector({
    super.key,
    required this.sizes,
    required this.outOfStockSizes,
    required this.selectedSize,
    required this.onSizeSelected,
  });

  void _showSizeGuide(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.sheet)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Size Guide',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.primaryDark),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'All footwear sizes are listed in European (EU) standard sizing. Use the international conversion chart below.',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            Table(
              border: TableBorder.all(color: AppColors.neutral100),
              children: const [
                TableRow(
                  decoration: BoxDecoration(color: AppColors.cardSurface),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('EU', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('US (Men)', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('UK', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Foot (cm)', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                TableRow(children: [
                  Padding(padding: EdgeInsets.all(8.0), child: Text('39')),
                  Padding(padding: EdgeInsets.all(8.0), child: Text('6.5')),
                  Padding(padding: EdgeInsets.all(8.0), child: Text('6.0')),
                  Padding(padding: EdgeInsets.all(8.0), child: Text('24.5')),
                ]),
                TableRow(children: [
                  Padding(padding: EdgeInsets.all(8.0), child: Text('40')),
                  Padding(padding: EdgeInsets.all(8.0), child: Text('7.0')),
                  Padding(padding: EdgeInsets.all(8.0), child: Text('6.5')),
                  Padding(padding: EdgeInsets.all(8.0), child: Text('25.0')),
                ]),
                TableRow(children: [
                  Padding(padding: EdgeInsets.all(8.0), child: Text('41')),
                  Padding(padding: EdgeInsets.all(8.0), child: Text('8.0')),
                  Padding(padding: EdgeInsets.all(8.0), child: Text('7.5')),
                  Padding(padding: EdgeInsets.all(8.0), child: Text('26.0')),
                ]),
                TableRow(children: [
                  Padding(padding: EdgeInsets.all(8.0), child: Text('42')),
                  Padding(padding: EdgeInsets.all(8.0), child: Text('8.5')),
                  Padding(padding: EdgeInsets.all(8.0), child: Text('8.0')),
                  Padding(padding: EdgeInsets.all(8.0), child: Text('26.5')),
                ]),
                TableRow(children: [
                  Padding(padding: EdgeInsets.all(8.0), child: Text('43')),
                  Padding(padding: EdgeInsets.all(8.0), child: Text('9.5')),
                  Padding(padding: EdgeInsets.all(8.0), child: Text('9.0')),
                  Padding(padding: EdgeInsets.all(8.0), child: Text('27.5')),
                ]),
                TableRow(children: [
                  Padding(padding: EdgeInsets.all(8.0), child: Text('44')),
                  Padding(padding: EdgeInsets.all(8.0), child: Text('10.0')),
                  Padding(padding: EdgeInsets.all(8.0), child: Text('9.5')),
                  Padding(padding: EdgeInsets.all(8.0), child: Text('28.0')),
                ]),
                TableRow(children: [
                  Padding(padding: EdgeInsets.all(8.0), child: Text('45')),
                  Padding(padding: EdgeInsets.all(8.0), child: Text('11.0')),
                  Padding(padding: EdgeInsets.all(8.0), child: Text('10.5')),
                  Padding(padding: EdgeInsets.all(8.0), child: Text('29.0')),
                ]),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Select Size',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
            GestureDetector(
              onTap: () => _showSizeGuide(context),
              child: const Text(
                'Size Guide',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryAccent,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: sizes.map((size) {
            final isUnavailable = outOfStockSizes.contains(size);
            final isSelected = selectedSize == size;

            return GestureDetector(
              onTap: isUnavailable ? null : () => onSizeSelected(size),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryDark
                      : (isUnavailable
                          ? AppColors.neutral100.withValues(alpha: 0.4)
                          : AppColors.surfaceLight),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryDark
                        : (isUnavailable
                            ? AppColors.neutral100
                            : AppColors.neutral100),
                    width: 1.2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primaryDark.withValues(alpha: 0.2),
                            offset: const Offset(0, 3),
                            blurRadius: 6,
                          )
                        ]
                      : null,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      '$size',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : (isUnavailable
                                ? AppColors.neutral200
                                : AppColors.primaryDark),
                      ),
                    ),
                    if (isUnavailable)
                      Transform.rotate(
                        angle: -0.7,
                        child: Container(
                          width: 32,
                          height: 1.5,
                          color: AppColors.neutral200,
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
