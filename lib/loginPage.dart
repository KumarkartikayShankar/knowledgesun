import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/bottomnavbar.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  final String _baseUrl = 'https://edu-auth.vercel.app/auth';

  // ✅ Save JWT token, email, and profile image to SharedPreferences
  Future<void> _saveLoginState(String token, String email, String profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('jwt_token', token);
    await prefs.setString('user_email', email);
    await prefs.setString('user_profile', profile); // ✅ Store profile image
  }

  // ✅ Login API Call
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
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String? token = responseData['token'];
        final String? profile = responseData['user']['profile']; // ✅ Extract profile image URL

        if (token != null && profile != null) {
          await _saveLoginState(token, data.name, profile); // ✅ Save all user data
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavbar()),
          );
          return null;
        } else {
          return 'Error: No token or profile received';
        }
      } else {
        return 'Invalid email or password';
      }
    } catch (e) {
      return 'Error: Unable to connect to server';
    }
  }

  // ✅ Signup API Call
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
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String? token = responseData['token'];
        final String? profile = responseData['user']['profile']; // ✅ Extract profile image URL

        if (token != null && profile != null) {
          await _saveLoginState(token, data.name ?? '', profile); // ✅ Save all user data
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavbar()),
          );
          return null;
        } else {
          return 'Error: No token or profile received';
        }
      } else {
        return 'Signup failed. Try again.';
      }
    } catch (e) {
      return 'Error: Unable to connect to server';
    }
  }

  // ✅ Recover Password API Call
  Future<String?> _recoverPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        return null; // ✅ Success, email sent
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