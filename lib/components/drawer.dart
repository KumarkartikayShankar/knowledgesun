import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:knowledgesun/loginPage.dart';
import 'package:knowledgesun/screens/my_course_screen.dart';
import 'package:knowledgesun/screens/wishlistscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool isSwitchOn = false;
  String? userEmail = "Loading..."; // Default email placeholder

  @override
  void initState() {
    super.initState();
    _loadSwitchState();
    _loadUserEmail(); // ✅ Load saved email
  }

  // ✅ Load email from SharedPreferences
  Future<void> _loadUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('user_email') ?? 'No email found'; // Default if not found
    });
  }

  // ✅ Load switch state
  Future<void> _loadSwitchState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isSwitchOn = prefs.getBool('isSwitchOn') ?? false;
    });
  }

  // ✅ Save switch state
  Future<void> _saveSwitchState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSwitchOn', value);
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // ✅ Profile Section
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.black),
            accountName: const Text(
              '',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            accountEmail: Text(
              userEmail ?? 'No email found', // ✅ Display dynamic email
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://media.licdn.com/dms/image/v2/D4D03AQEoL5KtR11I-g/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1722709693564?e=2147483647&v=beta&t=hUyOo4QyBQ3pCSJ6zharOLvGDWLYHJTeUUKwY9mI6C8'),
            ),
          ),

          // ✅ My Courses Section
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('My Courses'),
            onTap: () {
               Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyCoursesPage()),
              );
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
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Wishlist'),
            onTap: () {
               Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  WishlistPage()),
              );
            },
          ),

          // ✅ PathMaster AI with Lottie Animation & Persistent Cupertino Switch
          ListTile(
            leading: SizedBox(
              width: 55,
              height: 55,
              child: Lottie.asset('lib/assets/robot.json', fit: BoxFit.cover),
            ),
            title: const Text(
              'PathMaster AI',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            trailing: CupertinoSwitch(
              value: isSwitchOn,
              activeColor: Colors.green,
              onChanged: (bool value) {
                setState(() {
                  isSwitchOn = value;
                  _saveSwitchState(value);
                });
              },
            ),
            onTap: () {},
          ),

          
        ],
      ),
    );
  }
}
