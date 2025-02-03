import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'screens/homescreen.dart'; // Import HomePage

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  // Base URL of the API
  final String baseUrl = 'https://edu-auth.vercel.app/auth';

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
        Uri.parse('$baseUrl/recover-password'),
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
    return Scaffold(
      backgroundColor: Colors.orange,
      body: FlutterLogin(
        onLogin: (data) => _authUser(data, context), 
        onSignup: (data) => _signup(data, context), 
        onRecoverPassword: _recoverPassword,
        theme: LoginTheme(
          primaryColor: Colors.orange.shade300,
          accentColor: Colors.white,
          buttonTheme: const LoginButtonTheme(
            backgroundColor: Colors.orange,
          ),
        ),
      ),
    );
  }
}
