import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:knowledgesun/screens/cart.dart';
import 'package:knowledgesun/screens/homescreen.dart';
import 'package:knowledgesun/screens/profile_screen.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _selectedIndex = 0;
  Key cartKey = UniqueKey(); // Key to rebuild the cart page

  final List<Widget> _pages = [
    const Homescreen(),
    CartPages(key: UniqueKey()), // Ensure CartPages reloads
    const AccountPage(),
  ];

  void _onTabChanged(int index) {
    setState(() {
      _selectedIndex = index;

      if (index == 1) {
        // When "My Cart" is selected, force a refresh
        cartKey = UniqueKey();
        _pages[1] = CartPages(key: cartKey);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 5, left: 9, right: 9),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: GNav(
          gap: 8,
          backgroundColor: Colors.transparent,
          color: Colors.black,
          activeColor: Colors.white,
          tabBackgroundColor: Colors.orange.shade500,
          tabBorderRadius: 50,
          tabMargin: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
          padding: const EdgeInsets.all(12),
          tabs: const [
            GButton(icon: Icons.home, text: 'Home'),
            GButton(icon: Icons.shopping_cart_outlined, text: 'My Cart'),
            GButton(icon: Icons.person, text: 'Account'),
          ],
          selectedIndex: _selectedIndex,
          onTabChange: _onTabChanged,
        ),
      ),
    );
  }
}
