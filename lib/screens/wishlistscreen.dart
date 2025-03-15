import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'course_info_screen.dart'; // Import the CourseInfoScreen

class WishlistPage extends StatefulWidget {
  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final String _wishlistApiUrl = 'https://edtechdata.shivamrajdubey.tech/data/wishlist';
  final String _wishlistRemoveApiUrl = 'https://edtechdata.shivamrajdubey.tech/data/wishlist/remove';

  List<Map<String, String>> _wishlistCourses = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchWishlist();
  }

  // ✅ Fetch JWT token from SharedPreferences
  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  // ✅ Fetch wishlist courses
  Future<void> _fetchWishlist() async {
    final token = await _getAuthToken();
    if (token == null) {
      setState(() {
        _errorMessage = 'Error: No token found. Please log in.';
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(_wishlistApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({}), // ✅ Empty body since API expects POST
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        setState(() {
          _wishlistCourses = data.map<Map<String, String>>((course) => {
            "title": course["title"] ?? "No Title",
            "image": course["image"] ?? "",
            "price": course["price"] ?? "N/A",
          }).toList();
          _isLoading = false;
        });

      } else {
        setState(() {
          _errorMessage = 'Failed to load wishlist (Status: ${response.statusCode})';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  // ✅ Remove course from wishlist
  Future<void> _removeFromWishlist(Map<String, String> course) async {
    final token = await _getAuthToken();
    if (token == null) {
      print("Error: No token found. Please log in.");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(_wishlistRemoveApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'title': course["title"],
          'image': course["image"],
          'price': course["price"],
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _wishlistCourses.removeWhere((item) => item["title"] == course["title"]);
        });
        print("Course removed from wishlist");
      } else {
        print("Failed to remove course from wishlist: ${response.body}");
      }
    } catch (e) {
      print("Error removing from wishlist: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Wishlist")),
      body: _isLoading
          ?   Center(
        child: SizedBox(
          width: 300,
          height: 300,
          child: Lottie.asset(
            'lib/assets/wishlistload.json', // ✅ Corrected path
            fit: BoxFit.contain,
          ),
        ),
      )
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.red)))
              : _wishlistCourses.isEmpty
                  ? const Center(child: Text("Your wishlist is empty"))
                  : ListView.builder(
                      itemCount: _wishlistCourses.length,
                      itemBuilder: (context, index) {
                        return _buildWishlistItem(_wishlistCourses[index]);
                      },
                    ),
    );
  }

  // ✅ Wishlist Item UI with Rounded Image and Navigation to CourseInfoScreen
  Widget _buildWishlistItem(Map<String, String> course) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: course["image"]!.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8), // ✅ Rounded Corners
                child: Image.network(
                  course["image"]!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                ),
              )
            : const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
        title: Text(course["title"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Price: ₹${course["price"]}"),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _removeFromWishlist(course),
        ),
        onTap: () {
          // ✅ Navigate to CourseInfoScreen with details
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseInfoScreen(
                courseTitle: course["title"]!,
                courseImage: course["image"]!,
                coursePrice: course["price"]!,
              ),
            ),
          );
        },
      ),
    );
  }
}
