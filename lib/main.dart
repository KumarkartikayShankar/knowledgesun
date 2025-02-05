import 'package:flutter/material.dart';
import 'package:knowledgesun/theme/theme_provider.dart';
import 'package:provider/provider.dart'; // Import provider package
import 'loginPage.dart';
// Import your ThemeProvider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: Provider.of<ThemeProvider>(context).themeData,
            home: const LoginPage(),
          );
        },
      ),
    );
  }
}
