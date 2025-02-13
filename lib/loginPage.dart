import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/bottomnavbar.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  final String _baseUrl = 'https://edu-auth.vercel.app/auth';

  Future<void> _saveLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }

  Future<String?> _authUser(LoginData data, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': data.name,
          'password': data.password,
        }),
      );

      if (response.statusCode == 200) {
        await _saveLoginState();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavbar()),
        );
        return null;
      } else {
        return 'Invalid email or password';
      }
    } catch (e) {
      return 'Error: Unable to connect to server';
    }
  }

  Future<String?> _signup(SignupData data, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': data.name,
          'password': data.password,
          'additionalData': data.additionalSignupData,
        }),
      );

      if (response.statusCode == 201) {
        await _saveLoginState();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavbar()),
        );
        return null;
      } else {
        return 'Signup failed. Try again.';
      }
    } catch (e) {
      return 'Error: Unable to connect to server';
    }
  }

  Future<String?> _recoverPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        return null;
      } else {
        return 'Email not found';
      }
    } catch (e) {
      return 'Error: Unable to connect to server';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterLogin(
        onLogin: (data) => _authUser(data, context),
        onSignup: (data) => _signup(data, context),
        onRecoverPassword: _recoverPassword,
        theme: LoginTheme(
          primaryColor: Colors.orange.shade500,
          accentColor: Colors.white,
          cardTheme: const CardTheme(color: Colors.white),
          buttonTheme: const LoginButtonTheme(backgroundColor: Colors.amberAccent),
        ),
      ),
    );
  }
}
