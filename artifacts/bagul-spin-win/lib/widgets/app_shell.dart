import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppShell extends StatelessWidget {
  const AppShell({required this.selectedIndex, required this.child, super.key});

  final int selectedIndex;
  final Widget child;

  static const _routes = ['/home', '/levels', '/refer', '/profile'];
  static const _items = [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.stars_outlined),
      selectedIcon: Icon(Icons.stars),
      label: 'Levels',
    ),
    NavigationDestination(
      icon: Icon(Icons.card_giftcard_outlined),
      selectedIcon: Icon(Icons.card_giftcard),
      label: 'Refer',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(child: child),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        destinations: _items,
        onDestinationSelected: (index) {
          if (index != selectedIndex) {
            Navigator.pushReplacementNamed(context, _routes[index]);
          }
        },
      ),
    );
  }
}
