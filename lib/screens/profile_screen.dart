import 'package:flutter/material.dart';
import 'package:knowledgesun/loginPage.dart';
import 'package:knowledgesun/screens/my_course_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart'; // ✅ Import url_launcher

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String? userEmail;
  String? profileUrl; // ✅ Store Profile URL

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // ✅ Load user data from SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('user_email') ?? 'No email found';

      // Fetch and correct profile image URL
      String? storedProfileUrl = prefs.getString('user_profile');
      if (storedProfileUrl != null && storedProfileUrl.isNotEmpty) {
        if (!storedProfileUrl.endsWith('.jpg') && !storedProfileUrl.endsWith('.png')) {
          profileUrl = "$storedProfileUrl.jpg"; // Append .jpg if missing
        } else {
          profileUrl = storedProfileUrl;
        }
      } else {
        profileUrl = "https://i.imgur.com/6oTdEsH.jpg"; // Default Image
      }
    });
  }

  // ✅ Logout function
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('user_email');
    await prefs.remove('user_profile');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  // ✅ Open "About Us" page in browser
  Future<void> _launchAboutUs() async {
    const String url = 'https://www.quantumsoftdev.in/';
    final Uri uri = Uri.parse(url);

    print('Attempting to launch: $url'); // Debugging log

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      print('Could not launch $url');
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Account")),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(profileUrl ?? "https://i.imgur.com/6oTdEsH.jpg"), // ✅ Load Dynamic Image
            ),
            const SizedBox(height: 10),

            Text(
              userEmail ?? 'No email found',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 30),

            _buildAccountCard(context, Icons.library_books, "My Courses", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyCoursesPage()),
              );
            }),
            _buildAccountCard(context, Icons.info, "About Us", _launchAboutUs), // ✅ Opens About Us page
            _buildAccountCard(context, Icons.logout, "Log Out", () {
              _logout(context);
            }),
          ],
        ),
      ),
    );
  }

  // ✅ Helper Widget for Each Card
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