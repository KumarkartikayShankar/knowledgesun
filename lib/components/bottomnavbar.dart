import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:knowledgesun/screens/cart.dart';
import 'package:knowledgesun/screens/homescreen.dart';
import 'package:knowledgesun/screens/profile_screen.dart';

class Bottomnavbar extends StatefulWidget {
  const Bottomnavbar({super.key});

  @override
  State<Bottomnavbar> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Homescreen(),
    const CartPages(),
    const AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display selected page here
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(0.1), // Margin around the bottom navbar
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(0), // Curved borders
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: GNav(
            gap: 8, // Space between icons and text
            backgroundColor: Colors.transparent, // Transparent background
            color: Colors.black,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.orange,
            padding: const EdgeInsets.all(16),
            tabs: const [
              GButton(icon: Icons.home, text: 'Home'),
              GButton(icon: Icons.shopping_cart_outlined, text: 'My Cart'),
              GButton(icon: Icons.person, text: 'Account'),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
