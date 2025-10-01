import 'package:flutter/material.dart';

enum UserRole { citizen, volunteer }

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final UserRole userRole;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.userRole,
    required this.onTap,
  }) : super(key: key);

  List<BottomNavigationBarItem> _getNavItems() {
    return const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        activeIcon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.add_location_outlined),
        activeIcon: Icon(Icons.add_location),
        label: 'Report',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.trending_up_outlined),
        activeIcon: Icon(Icons.trending_up),
        label: 'Trends',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        activeIcon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF1E3A8A),
      unselectedItemColor: Colors.grey[600],
      selectedFontSize: 12,
      unselectedFontSize: 12,
      elevation: 8,
      items: _getNavItems(),
    );
  }
}