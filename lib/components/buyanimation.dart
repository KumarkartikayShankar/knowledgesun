import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class BuyAnimation extends StatelessWidget {
  const BuyAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'lib/assets/success.json', // Ensure this file is in the assets folder
              width: 200,
              height: 200,
              repeat: false, // Play animation only once
            ),
            const SizedBox(height: 20),
            const Text(
              "Purchase Successful!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to the cart screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              ),
              child: const Text("Go Back", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
