import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:knowledgesun/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool isSwitchOn = false; // ✅ Toggle state for CupertinoSwitch

  @override
  void initState() {
    super.initState();
    _loadSwitchState(); // ✅ Load switch state when the widget initializes
  }

  // ✅ Load switch state from SharedPreferences
  Future<void> _loadSwitchState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isSwitchOn = prefs.getBool('isSwitchOn') ?? false; // Default is false
    });
  }

  // ✅ Save switch state to SharedPreferences
  Future<void> _saveSwitchState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSwitchOn', value);
  }

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
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // ✅ Profile Section
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            accountName: Text(
              'Kumar Kartikay Shankar',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            accountEmail: Text(
              'kumar@gmail.com',
              style: TextStyle(color: Colors.white),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://media.licdn.com/dms/image/v2/D4D03AQEoL5KtR11I-g/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1722709693564?e=2147483647&v=beta&t=hUyOo4QyBQ3pCSJ6zharOLvGDWLYHJTeUUKwY9mI6C8'),
            ),
          ),

          // ✅ My Courses Section
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('My Courses'),
            onTap: () {
              // Navigate to My Courses page
            },
          ),

          // ✅ Help Section
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help'),
            onTap: () {
              // Navigate to Help page
            },
          ),

          // ✅ PathMaster AI with Lottie Animation & Persistent Cupertino Switch
          ListTile(
            leading: SizedBox(
              width: 40,
              height: 40,
              child: Lottie.asset(
                'lib/assets/robot.json', // ✅ Lottie animation path
                fit: BoxFit.cover,
              ),
            ),
            title: const Text('PathMaster AI'),

            // ✅ Added Persistent CupertinoSwitch
            trailing: CupertinoSwitch(
              value: isSwitchOn,
              activeColor: Colors.green, // ✅ Active color when switched on
              onChanged: (bool value) {
                setState(() {
                  isSwitchOn = value;
                  _saveSwitchState(value); // ✅ Save state when changed
                });
              },
            ),

            onTap: () {
              // Navigate to About Us page
            },
          ),

        ],
      ),
    );
  }
}
