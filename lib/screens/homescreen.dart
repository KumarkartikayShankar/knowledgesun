import 'package:flutter/material.dart';
import 'package:knowledgesun/components/drawer.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key}); // Remove userEmail parameter

  @override
  Widget build(BuildContext context) {
    // Access the current theme from ThemeProvider
    var currentTheme = Theme.of(context);

    return Scaffold(
      backgroundColor: currentTheme.colorScheme.surface, // Apply the primary color as background
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white), // Set icon color to white
        backgroundColor: currentTheme.colorScheme.inversePrimary, // Inverse primary color for app bar
      ),
      drawer: const CustomDrawer(),
      body: const Center(child: Text("Hello!")),
    );
  }
}
