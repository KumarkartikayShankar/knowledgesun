import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Profile Section
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            accountName: Text(
              'Kumar Kartikay Shankar',
              
              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
            ),
            accountEmail: Text('kumar@gmail.com',style: TextStyle(color: Colors.white),),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://media.licdn.com/dms/image/v2/D4D03AQEoL5KtR11I-g/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1722709693564?e=2147483647&v=beta&t=hUyOo4QyBQ3pCSJ6zharOLvGDWLYHJTeUUKwY9mI6C8'),
              // Use local image as well
              // backgroundImage: AssetImage('assets/profile_picture.jpg'),
            ),
          ),

          // Account Section
           ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Account'),
              onTap: () {
                // Navigate to Account page
              },
            ),
          

          // My Courses Section
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('My Courses'),
            onTap: () {
              // Navigate to My Courses page
            },
          ),

          // Help Section
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help'),
            onTap: () {
              // Navigate to Help page
            },
          ),

          // About Us Section
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About Us'),
            onTap: () {
              // Navigate to About Us page
            },
          ),
        ],
      ),
    );
  }
}
