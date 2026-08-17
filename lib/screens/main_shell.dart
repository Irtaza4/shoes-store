import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../widgets/bottom_navigation_nws.dart';
import 'home_screen.dart';
import 'explore_screen.dart';
import 'favorites_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final currentIndex = appState.currentTabIndex;

    final List<Widget> pages = const [
      HomeScreen(),
      ExploreScreen(),
      FavoritesScreen(),
      CartScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: NwsBottomNavigation(
        currentIndex: currentIndex,
        onTap: (index) {
          appState.setTabIndex(index);
        },
      ),
    );
  }
}
