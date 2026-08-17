import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/mock_data.dart';

enum SortOption {
  popular('Popular'),
  newest('Newest'),
  priceLowHigh('Price: Low to High'),
  priceHighLow('Price: High to Low'),
  rating('Highest Rated');

  final String label;
  const SortOption(this.label);
}

class FilterCriteria {
  final String? brand;
  final int? size;
  final RangeValues priceRange;
  final String? colorName;
  final String? collection; // 'All', 'New arrivals', 'Best sellers', 'Sale'

  const FilterCriteria({
    this.brand,
    this.size,
    this.priceRange = const RangeValues(50, 350),
    this.colorName,
    this.collection,
  });

  FilterCriteria copyWith({
    String? brand,
    int? size,
    RangeValues? priceRange,
    String? colorName,
    String? collection,
    bool resetBrand = false,
    bool resetSize = false,
    bool resetColor = false,
    bool resetCollection = false,
  }) {
    return FilterCriteria(
      brand: resetBrand ? null : (brand ?? this.brand),
      size: resetSize ? null : (size ?? this.size),
      priceRange: priceRange ?? this.priceRange,
      colorName: resetColor ? null : (colorName ?? this.colorName),
      collection: resetCollection ? null : (collection ?? this.collection),
    );
  }

  bool get isActive =>
      brand != null ||
      size != null ||
      priceRange.start > 50 ||
      priceRange.end < 350 ||
      colorName != null ||
      collection != null;
}

class AppState extends ChangeNotifier {
  // Navigation
  int _currentTabIndex = 0;
  int get currentTabIndex => _currentTabIndex;

  void setTabIndex(int index) {
    if (_currentTabIndex != index) {
      _currentTabIndex = index;
      notifyListeners();
    }
  }

  // Catalog & Categories
  final List<Product> _allProducts = List.from(MockData.products);
  List<Product> get allProducts => List.unmodifiable(_allProducts);

  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Search & Filter
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  SortOption _currentSort = SortOption.popular;
  SortOption get currentSort => _currentSort;

  FilterCriteria _filterCriteria = const FilterCriteria();
  FilterCriteria get filterCriteria => _filterCriteria;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSortOption(SortOption option) {
    _currentSort = option;
    notifyListeners();
  }

  void updateFilterCriteria(FilterCriteria criteria) {
    _filterCriteria = criteria;
    notifyListeners();
  }

  void resetFilters() {
    _filterCriteria = const FilterCriteria();
    _searchQuery = '';
    _selectedCategory = 'All';
    _currentSort = SortOption.popular;
    notifyListeners();
  }

  // Filtered products query result
  List<Product> get filteredProducts {
    var list = _allProducts.where((p) {
      // Category filter
      if (_selectedCategory != 'All' &&
          p.category.toLowerCase() != _selectedCategory.toLowerCase()) {
        return false;
      }

      // Search Query
      if (_searchQuery.trim().isNotEmpty) {
        final q = _searchQuery.toLowerCase().trim();
        final match = p.name.toLowerCase().contains(q) ||
            p.brand.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q);
        if (!match) return false;
      }

      // Brand Filter
      if (_filterCriteria.brand != null &&
          _filterCriteria.brand != 'All Brands' &&
          p.brand.toLowerCase() != _filterCriteria.brand!.toLowerCase()) {
        return false;
      }

      // Size Filter
      if (_filterCriteria.size != null &&
          !p.availableSizes.contains(_filterCriteria.size)) {
        return false;
      }

      // Price Range Filter
      if (p.price < _filterCriteria.priceRange.start ||
          p.price > _filterCriteria.priceRange.end) {
        return false;
      }

      // Color Filter
      if (_filterCriteria.colorName != null) {
        final hasColor = p.availableColors.any((c) =>
            c.name.toLowerCase().contains(_filterCriteria.colorName!.toLowerCase()));
        if (!hasColor) return false;
      }

      // Collection Filter
      if (_filterCriteria.collection != null) {
        if (_filterCriteria.collection == 'New arrivals' && !p.isNew) {
          return false;
        }
        if (_filterCriteria.collection == 'Best sellers' && p.rating < 4.85) {
          return false;
        }
        if (_filterCriteria.collection == 'Sale' && !p.isSale) {
          return false;
        }
      }

      return true;
    }).toList();

    // Apply Sorting
    switch (_currentSort) {
      case SortOption.popular:
        list.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
        break;
      case SortOption.newest:
        list.sort((a, b) => (b.isNew ? 1 : 0).compareTo(a.isNew ? 1 : 0));
        break;
      case SortOption.priceLowHigh:
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceHighLow:
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.rating:
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    return list;
  }

  // Favorites
  final Set<String> _favoriteProductIds = {'prod_preday', 'prod_crater'};
  Set<String> get favoriteProductIds => Set.unmodifiable(_favoriteProductIds);

  bool isFavorite(String productId) => _favoriteProductIds.contains(productId);

  void toggleFavorite(String productId) {
    if (_favoriteProductIds.contains(productId)) {
      _favoriteProductIds.remove(productId);
    } else {
      _favoriteProductIds.add(productId);
    }
    notifyListeners();
  }

  List<Product> get favoriteProducts =>
      _allProducts.where((p) => _favoriteProductIds.contains(p.id)).toList();

  // Cart
  final List<CartItem> _cartItems = [
    CartItem(
      product: MockData.products[0],
      selectedColor: MockData.products[0].availableColors[0],
      selectedSize: 42,
      quantity: 1,
    ),
  ];
  List<CartItem> get cartItems => List.unmodifiable(_cartItems);

  int get cartCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  String? _appliedPromoCode;
  String? get appliedPromoCode => _appliedPromoCode;
  double _promoDiscountRate = 0.0;

  double get subtotal =>
      _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get shippingFee {
    if (_cartItems.isEmpty) return 0.0;
    if (_appliedPromoCode == 'FREESHIP' || subtotal > 200.0) return 0.0;
    return 10.0;
  }

  double get discountAmount => subtotal * _promoDiscountRate;

  double get total => (subtotal + shippingFee - discountAmount).clamp(0.0, double.infinity);

  void addToCart(Product product, ProductColor color, int size, {int quantity = 1}) {
    final existingIndex = _cartItems.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.selectedColor.name == color.name &&
          item.selectedSize == size,
    );

    if (existingIndex >= 0) {
      _cartItems[existingIndex].quantity += quantity;
    } else {
      _cartItems.add(
        CartItem(
          product: product,
          selectedColor: color,
          selectedSize: size,
          quantity: quantity,
        ),
      );
    }
    notifyListeners();
  }

  void updateCartQuantity(int index, int delta) {
    if (index >= 0 && index < _cartItems.length) {
      final newQty = _cartItems[index].quantity + delta;
      if (newQty <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index].quantity = newQty;
      }
      notifyListeners();
    }
  }

  void removeFromCart(int index) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems.removeAt(index);
      notifyListeners();
    }
  }

  bool applyPromoCode(String code) {
    final clean = code.trim().toUpperCase();
    if (clean == 'NWS20') {
      _appliedPromoCode = 'NWS20';
      _promoDiscountRate = 0.20; // 20% OFF
      notifyListeners();
      return true;
    } else if (clean == 'FREESHIP') {
      _appliedPromoCode = 'FREESHIP';
      _promoDiscountRate = 0.0;
      notifyListeners();
      return true;
    }
    return false;
  }

  void removePromoCode() {
    _appliedPromoCode = null;
    _promoDiscountRate = 0.0;
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    _appliedPromoCode = null;
    _promoDiscountRate = 0.0;
    notifyListeners();
  }

  // Orders
  final List<Order> _orders = List.from(MockData.initialOrders);
  List<Order> get orders => List.unmodifiable(_orders);

  Order? _activeTrackingOrder;
  Order? get activeTrackingOrder => _activeTrackingOrder ?? (_orders.isNotEmpty ? _orders.first : null);

  void setActiveTrackingOrder(Order order) {
    _activeTrackingOrder = order;
    notifyListeners();
  }

  Order placeOrder({
    required Address address,
    required String paymentMethod,
    required String deliveryOption,
  }) {
    final shipping = deliveryOption == 'Express' ? 20.0 : shippingFee;
    final finalTotal = subtotal + shipping - discountAmount;
    final orderId = 'NWS${10000 + _orders.length + 1}';
    final trkId = 'NWS-TRK-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}';

    final newOrder = Order(
      id: orderId,
      items: List.from(_cartItems),
      subtotal: subtotal,
      shippingFee: shipping,
      discount: discountAmount,
      total: finalTotal,
      status: OrderStatus.placed,
      shippingAddress: address,
      paymentMethod: paymentMethod,
      trackingNumber: trkId,
      carrier: deliveryOption == 'Express'
          ? 'FedEx Overnight Sneaker Express'
          : 'Standard Ground Delivery',
      createdAt: DateTime.now(),
      estimatedDelivery: '3–5 Business Days',
    );

    _orders.insert(0, newOrder);
    _activeTrackingOrder = newOrder;
    clearCart();
    notifyListeners();
    return newOrder;
  }

  // User Profile
  UserProfile _userProfile = MockData.initialProfile;
  UserProfile get userProfile => _userProfile;

  void updateProfile(UserProfile profile) {
    _userProfile = profile;
    notifyListeners();
  }

  void toggleNotifications(bool value) {
    _userProfile = _userProfile.copyWith(notificationsEnabled: value);
    notifyListeners();
  }
}

class AppStateProvider extends InheritedNotifier<AppState> {
  const AppStateProvider({
    super.key,
    required AppState super.notifier,
    required super.child,
  });

  static AppState of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<AppStateProvider>();
    assert(provider != null, 'No AppStateProvider found in context');
    return provider!.notifier!;
  }
}
