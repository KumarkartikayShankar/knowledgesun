import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'screens/homescreen.dart'; // Import HomePage

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  final String baseUrl = 'https://edu-auth.vercel.app/auth';

  // Save login state to SharedPreferences
  Future<void> _saveLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true); // Save login state
  }

  // Check if the user is already logged in
  Future<bool> _isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false; // Default to false if not found
  }

  // Login
  Future<String?> _authUser(LoginData data, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': data.name,
          'password': data.password,
        }),
      );

      if (response.statusCode == 200) {
        // Save the login state after successful login
        _saveLoginState();

        Future.delayed(Duration.zero, () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Homescreen()), // No data passed
          );
        });

        return null; // Success
      } else {
        return 'Invalid email or password';
      }
    } catch (e) {
      return 'Error: Unable to connect to server';
    }
  }

  // Signup
  Future<String?> _signup(SignupData data, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': data.name,
          'password': data.password,
          'additionalData': data.additionalSignupData,
        }),
      );

      if (response.statusCode == 201) {
        // Save the login state after successful signup
        _saveLoginState();

        Future.delayed(Duration.zero, () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Homescreen()), // No data passed
          );
        });

        return null; // Success
      } else {
        return 'Signup failed. Try again.';
      }
    } catch (e) {
      return 'Error: Unable to connect to server';
    }
  }

  // Forgot Password
  Future<String?> _recoverPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        return null; // Success
      } else {
        return 'Email not found';
      }
    } catch (e) {
      return 'Error: Unable to connect to server';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isLoggedIn(), // Check login state when the app is loaded
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()), // Show loading indicator
          );
        }

        if (snapshot.hasData && snapshot.data == true) {
          // If the user is logged in, navigate directly to Homescreen
          return const Homescreen();
        }

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
      },
    );
  }
}
