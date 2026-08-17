import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shoes_app/state/app_state.dart';
import 'package:shoes_app/models/mock_data.dart';
import 'package:shoes_app/models/product.dart';
import 'package:shoes_app/screens/checkout_screen.dart';
import 'package:shoes_app/screens/cart_screen.dart';
import 'package:shoes_app/widgets/bottom_navigation_nws.dart';

void main() {
  group('AppState Business Logic Tests', () {
    late AppState appState;

    setUp(() {
      appState = AppState();
    });

    test('Initial state is correctly populated', () {
      expect(appState.allProducts.length, MockData.products.length);
      expect(appState.selectedCategory, 'Lifestyle');
      expect(appState.currentTabIndex, 0);
      expect(appState.cartItems.isNotEmpty, true);
      expect(appState.favoriteProductIds.contains('prod_preday'), true);
    });

    test('Category filtering updates filtered products', () {
      appState.setCategory('Running');
      expect(appState.selectedCategory, 'Running');
      final runningProducts = appState.filteredProducts;
      for (final p in runningProducts) {
        expect(p.category.toLowerCase(), 'running');
      }
    });

    test('Search query matches shoe brand or name', () {
      appState.setSearchQuery('Pre-Day');
      final results = appState.filteredProducts;
      expect(results.isNotEmpty, true);
      expect(results.any((p) => p.name.contains('Pre-Day')), true);
    });

    test('Sorting by priceLowHigh works properly', () {
      appState.setSortOption(SortOption.priceLowHigh);
      final list = appState.filteredProducts;
      for (int i = 0; i < list.length - 1; i++) {
        expect(list[i].price <= list[i + 1].price, true);
      }
    });

    test('Toggle favorites adds and removes correctly', () {
      const testId = 'prod_pegasus';
      final wasFav = appState.isFavorite(testId);
      appState.toggleFavorite(testId);
      expect(appState.isFavorite(testId), !wasFav);
      appState.toggleFavorite(testId);
      expect(appState.isFavorite(testId), wasFav);
    });

    test('Cart additions, quantity updates, and promo codes calculate accurately', () {
      appState.clearCart();
      expect(appState.cartCount, 0);
      expect(appState.subtotal, 0.0);

      final product = MockData.products[0];
      final color = product.availableColors[0];
      const size = 42;

      appState.addToCart(product, color, size, quantity: 2);
      expect(appState.cartCount, 2);
      expect(appState.subtotal, product.price * 2);

      // Promo Code NWS20 gives 20% discount
      final success = appState.applyPromoCode('NWS20');
      expect(success, true);
      expect(appState.discountAmount, closeTo(product.price * 2 * 0.20, 0.01));

      // Order creation
      final order = appState.placeOrder(
        address: MockData.initialAddress,
        paymentMethod: 'Apple Pay',
        deliveryOption: 'Standard',
      );

      expect(order.status, OrderStatus.placed);
      expect(appState.cartCount, 0); // Cart is cleared after order
      expect(appState.orders.first.id, order.id);
    });
  });

  group('Checkout & Cart Widget Tests', () {
    testWidgets('CheckoutScreen renders without initState inherited widget errors',
        (WidgetTester tester) async {
      final appState = AppState();

      await tester.pumpWidget(
        AppStateProvider(
          notifier: appState,
          child: const MaterialApp(
            home: CheckoutScreen(),
          ),
        ),
      );

      await tester.pump();

      // Verify Checkout AppBar and Address fields
      expect(find.text('Checkout'), findsOneWidget);
      expect(find.text('Shipping Address'), findsOneWidget);
      expect(find.text('Irtaza Khalid'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('CartScreen renders and navigates towards checkout',
        (WidgetTester tester) async {
      final appState = AppState();

      await tester.pumpWidget(
        AppStateProvider(
          notifier: appState,
          child: const MaterialApp(
            home: CartScreen(),
          ),
        ),
      );

      await tester.pump();

      // Verify Cart Header & Proceed Button
      expect(find.text('Proceed to Checkout'), findsOneWidget);
    });
  });

  group('Draggable Curved Bottom Navigation Tests', () {
    testWidgets('NwsBottomNavigation renders properly with initial tab and labels',
        (WidgetTester tester) async {
      int selectedIndex = 0;
      final appState = AppState();

      await tester.pumpWidget(
        AppStateProvider(
          notifier: appState,
          child: MaterialApp(
            home: Scaffold(
              bottomNavigationBar: StatefulBuilder(
                builder: (context, setState) {
                  return NwsBottomNavigation(
                    currentIndex: selectedIndex,
                    onTap: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(NwsBottomNavigation), findsOneWidget);
    });

    testWidgets('Tapping on a tab slot changes selected index',
        (WidgetTester tester) async {
      int selectedIndex = 0;
      final appState = AppState();

      await tester.pumpWidget(
        AppStateProvider(
          notifier: appState,
          child: MaterialApp(
            home: Scaffold(
              bottomNavigationBar: StatefulBuilder(
                builder: (context, setState) {
                  return NwsBottomNavigation(
                    currentIndex: selectedIndex,
                    onTap: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on the 2nd tab (Cart, index 1)
      final screenWidth =
          tester.view.physicalSize.width / tester.view.devicePixelRatio;
      final tab1Offset = Offset(screenWidth * 0.3, 20);

      await tester.tapAt(tester.getTopLeft(find.byType(NwsBottomNavigation)) + tab1Offset);
      await tester.pumpAndSettle();

      expect(selectedIndex, 1);
    });

    testWidgets('Dragging horizontally smoothly slides and snaps to next tab',
        (WidgetTester tester) async {
      int selectedIndex = 0;
      final appState = AppState();

      await tester.pumpWidget(
        AppStateProvider(
          notifier: appState,
          child: MaterialApp(
            home: Scaffold(
              bottomNavigationBar: StatefulBuilder(
                builder: (context, setState) {
                  return NwsBottomNavigation(
                    currentIndex: selectedIndex,
                    onTap: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Perform a drag from tab 0 area to tab 2 area
      final startPos = tester.getCenter(find.byType(NwsBottomNavigation)) - const Offset(120, 0);
      final dragGesture = await tester.startGesture(startPos);
      await dragGesture.moveBy(const Offset(160, 0));
      await tester.pump(const Duration(milliseconds: 50));
      await dragGesture.up();
      await tester.pumpAndSettle();

      expect(selectedIndex > 0, true);
    });
  });
}
