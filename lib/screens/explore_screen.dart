import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../state/app_state.dart';
import '../models/mock_data.dart';
import '../widgets/product_card.dart';
import '../widgets/filter_sheet.dart';
import '../widgets/sort_sheet.dart';
import '../widgets/empty_state.dart';
import 'product_detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final products = appState.filteredProducts;
    final isFiltering = appState.filterCriteria.isActive;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Search Header Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.horizontalPadding,
                16,
                AppSpacing.horizontalPadding,
                8,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(color: AppColors.neutral100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) {
                          appState.setSearchQuery(val);
                        },
                        decoration: InputDecoration(
                          hintText: 'Search shoes, brands...',
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: AppColors.neutral200,
                            size: 20,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.clear_rounded,
                                    size: 18,
                                    color: AppColors.textSecondary,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    appState.setSearchQuery('');
                                  },
                                )
                              : null,
                          filled: false,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Filter Button
                  GestureDetector(
                    onTap: () => FilterBottomSheet.show(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isFiltering
                            ? AppColors.primaryDark
                            : AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                          color: isFiltering
                              ? AppColors.primaryDark
                              : AppColors.neutral100,
                        ),
                      ),
                      child: Icon(
                        Icons.tune_rounded,
                        size: 20,
                        color: isFiltering ? Colors.white : AppColors.primaryDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Search Chips (If search bar empty and no filter active)
            if (appState.searchQuery.isEmpty && !isFiltering)
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.horizontalPadding,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Recent Searches
                      const Text(
                        'Recent Searches',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: MockData.recentSearches.map((term) {
                          return ActionChip(
                            label: Text(term),
                            avatar: const Icon(
                              Icons.history_rounded,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            backgroundColor: AppColors.surfaceLight,
                            side: const BorderSide(color: AppColors.neutral100),
                            labelStyle: const TextStyle(
                              fontSize: 13,
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w500,
                            ),
                            onPressed: () {
                              _searchController.text = term;
                              appState.setSearchQuery(term);
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),

                      // Popular Searches
                      const Text(
                        'Popular Searches',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: MockData.popularSearches.map((term) {
                          return ActionChip(
                            label: Text(term),
                            avatar: const Icon(
                              Icons.trending_up_rounded,
                              size: 16,
                              color: AppColors.primaryAccent,
                            ),
                            backgroundColor: AppColors.surfaceLight,
                            side: const BorderSide(color: AppColors.neutral100),
                            labelStyle: const TextStyle(
                              fontSize: 13,
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w500,
                            ),
                            onPressed: () {
                              _searchController.text = term;
                              appState.setSearchQuery(term);
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 28),

                      // Featured Catalog Preview
                      const Text(
                        'All Footwear',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: AppSpacing.gridGap,
                          mainAxisSpacing: AppSpacing.gridGap,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          final exploreHeroTag = 'product_image_explore_${product.id}';
                          return ProductCard(
                            product: product,
                            heroTag: exploreHeroTag,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductDetailScreen(
                                    product: product,
                                    heroTag: exploreHeroTag,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              )
            else
              // Search Results with Sort & Count
              Expanded(
                child: Column(
                  children: [
                    // Result count and Sort Row
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.horizontalPadding,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${products.length} results',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryDark,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => SortBottomSheet.show(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceLight,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.full),
                                border: Border.all(color: AppColors.neutral100),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    appState.currentSort.label,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.swap_vert_rounded,
                                    size: 16,
                                    color: AppColors.primaryDark,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Results Grid or Empty state
                    Expanded(
                      child: products.isEmpty
                          ? EmptyStateWidget.search(
                              onReset: () {
                                _searchController.clear();
                                appState.resetFilters();
                              },
                            )
                          : GridView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.horizontalPadding,
                                vertical: 8,
                              ),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.65,
                                crossAxisSpacing: AppSpacing.gridGap,
                                mainAxisSpacing: AppSpacing.gridGap,
                              ),
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                final product = products[index];
                                final searchHeroTag = 'product_image_search_${product.id}';
                                return ProductCard(
                                  product: product,
                                  heroTag: searchHeroTag,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ProductDetailScreen(
                                          product: product,
                                          heroTag: searchHeroTag,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
