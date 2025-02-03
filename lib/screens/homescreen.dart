import 'package:flutter/material.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key}); // Remove userEmail parameter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Welcome")), // Remove userEmail from title
      body: const Center(child: Text("Hello!")), // Remove userEmail from text
    );
  }
}
