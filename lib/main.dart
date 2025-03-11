import 'package:flutter/material.dart';
import 'package:knowledgesun/components/cart_provider.dart';
import 'package:knowledgesun/loginPage.dart';
import 'package:knowledgesun/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/bottomnavbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // Theme management
        ChangeNotifierProvider(create: (_) => CartProvider()),  // Cart management
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return FutureBuilder<bool>(
            future: _checkLoginStatus(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const MaterialApp(
                  home: Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  ),
                );
              }

              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: themeProvider.themeData,
                home: snapshot.data == true ? const BottomNavbar() : const LoginPage(),
              );
            },
          );
        },
      ),
    );
  }
}
