import 'package:flutter/material.dart';
import 'package:knowledgesun/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});
  
 // Logout function
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn'); // Remove login state

    // Navigate to the login page after logout
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()), // Redirect to LoginPage
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ✅ User Circular Image
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(''), // Replace with your image
            ),
            const SizedBox(height: 10),

            // ✅ Username
            const Text(
              "John Doe", // Replace with dynamic username
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // ✅ Separate Cards for Each Option
            _buildAccountCard(context, Icons.library_books, "My Courses", () {
              // Navigate to My Courses
            }),
            _buildAccountCard(context, Icons.info, "About Us", () {
              // Navigate to About Us
            }),
            _buildAccountCard(context, Icons.logout, "Log Out", () {
               _logout(context); 
            }),
          ],
        ),
      ),
    );
  }

  // Helper Widget for Each Card
  Widget _buildAccountCard(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        leading: Icon(icon, color: Theme.of(context).primaryColor, size: 30),
        title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 20),
        onTap: onTap,
      ),
    );
  }
}
