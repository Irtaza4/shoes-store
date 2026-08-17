import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../state/app_state.dart';
import '../models/mock_data.dart';

class FilterBottomSheet extends StatefulWidget {
  final FilterCriteria initialCriteria;
  final Function(FilterCriteria) onApply;

  const FilterBottomSheet({
    super.key,
    required this.initialCriteria,
    required this.onApply,
  });

  static Future<void> show(BuildContext context) async {
    final appState = AppStateProvider.of(context);
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => FilterBottomSheet(
        initialCriteria: appState.filterCriteria,
        onApply: (criteria) {
          appState.updateFilterCriteria(criteria);
        },
      ),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String? _selectedBrand;
  late int? _selectedSize;
  late RangeValues _priceRange;
  late String? _selectedColorName;
  late String? _selectedCollection;

  final List<int> _availableSizes = [38, 39, 40, 41, 42, 43, 44, 45, 46];
  final List<String> _collections = ['All', 'New arrivals', 'Best sellers', 'Sale'];

  final List<Map<String, dynamic>> _filterColors = [
    {'name': 'Black', 'color': const Color(0xFF0C0706)},
    {'name': 'Red', 'color': const Color(0xFFBB2C1A)},
    {'name': 'Brown', 'color': const Color(0xFF5C180E)},
    {'name': 'Sand', 'color': const Color(0xFFA98B73)},
    {'name': 'Grey', 'color': const Color(0xFF615A56)},
    {'name': 'White', 'color': const Color(0xFFF3F0EA)},
  ];

  @override
  void initState() {
    super.initState();
    _selectedBrand = widget.initialCriteria.brand;
    _selectedSize = widget.initialCriteria.size;
    _priceRange = widget.initialCriteria.priceRange;
    _selectedColorName = widget.initialCriteria.colorName;
    _selectedCollection = widget.initialCriteria.collection;
  }

  void _reset() {
    setState(() {
      _selectedBrand = null;
      _selectedSize = null;
      _priceRange = const RangeValues(50, 350);
      _selectedColorName = null;
      _selectedCollection = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.sheet)),
      ),
      child: Column(
        children: [
          // Drag Handle
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.neutral100,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.horizontalPadding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filters',
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
          ),
          const Divider(height: 1),

          // Scrollable Filter Options
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand Filter
                  const Text(
                    'Brand',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: MockData.brands.map((brand) {
                      final isSelected = (_selectedBrand == brand) ||
                          (_selectedBrand == null && brand == 'All Brands');

                      return ChoiceChip(
                        label: Text(brand),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedBrand = brand == 'All Brands' ? null : brand;
                          });
                        },
                        selectedColor: AppColors.primaryDark,
                        backgroundColor: AppColors.cardSurface,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.primaryDark,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.full),
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primaryDark
                                : AppColors.neutral100,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Price Range
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Price Range',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      Text(
                        '\$${_priceRange.start.round()} — \$${_priceRange.end.round()}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryAccent,
                        ),
                      ),
                    ],
                  ),
                  RangeSlider(
                    values: _priceRange,
                    min: 50,
                    max: 350,
                    divisions: 30,
                    activeColor: AppColors.primaryDark,
                    inactiveColor: AppColors.neutral100,
                    onChanged: (values) {
                      setState(() {
                        _priceRange = values;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  // Size Filter
                  const Text(
                    'Size (EU)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableSizes.map((size) {
                      final isSelected = _selectedSize == size;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedSize = isSelected ? null : size;
                          });
                        },
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryDark
                                : AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryDark
                                  : AppColors.neutral100,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '$size',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.primaryDark,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Color Swatches
                  const Text(
                    'Color',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 12,
                    children: _filterColors.map((colorMap) {
                      final name = colorMap['name'] as String;
                      final col = colorMap['color'] as Color;
                      final isSelected = _selectedColorName == name;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedColorName = isSelected ? null : name;
                          });
                        },
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primaryDark
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: col,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.neutral100,
                                  ),
                                ),
                                child: isSelected
                                    ? Icon(
                                        Icons.check,
                                        size: 16,
                                        color: col.computeLuminance() > 0.5
                                            ? Colors.black
                                            : Colors.white,
                                      )
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 11,
                                color: isSelected
                                    ? AppColors.primaryDark
                                    : AppColors.textSecondary,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Collection
                  const Text(
                    'Collection',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _collections.map((coll) {
                      final isSelected = (_selectedCollection == coll) ||
                          (_selectedCollection == null && coll == 'All');

                      return ChoiceChip(
                        label: Text(coll),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCollection = coll == 'All' ? null : coll;
                          });
                        },
                        selectedColor: AppColors.primaryDark,
                        backgroundColor: AppColors.cardSurface,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.primaryDark,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.full),
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primaryDark
                                : AppColors.neutral100,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Bottom CTAs: Reset & Apply
          Container(
            padding: const EdgeInsets.all(AppSpacing.horizontalPadding),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              border: const Border(
                top: BorderSide(color: AppColors.neutral100, width: 0.8),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  offset: const Offset(0, -3),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: _reset,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      final updated = FilterCriteria(
                        brand: _selectedBrand,
                        size: _selectedSize,
                        priceRange: _priceRange,
                        colorName: _selectedColorName,
                        collection: _selectedCollection,
                      );
                      widget.onApply(updated);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Show Results'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
