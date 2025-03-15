import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoursesList extends StatefulWidget {
  final ScrollController scrollController;
  final Function(String, String, String) onCourseTap;

  const CoursesList({
    super.key,
    required this.scrollController,
    required this.onCourseTap,
  });

  @override
  State<CoursesList> createState() => _CoursesListState();
}

class _CoursesListState extends State<CoursesList> {
  final String _apiUrl = 'https://edtechdata.shivamrajdubey.tech/data/courses/latest';
  final String _wishlistAddApiUrl = 'https://edtechdata.shivamrajdubey.tech/data/wishlist/add';
  final String _wishlistRemoveApiUrl = 'https://edtechdata.shivamrajdubey.tech/data/wishlist/remove';

  List<Map<String, String>> _courses = [];
  bool _isLoading = true;
  String _errorMessage = '';
  Set<String> _wishlist = {}; // Stores favorite courses

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  // ✅ Fetch courses
  Future<void> _fetchCourses() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        setState(() {
          _courses = data
              .map<Map<String, String>>((course) => {
                    "title": course["title"] ?? "No Title",
                    "image": course["image"] ?? "",
                    "price": course["price"] ?? "N/A",
                  })
              .toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load courses (Status: ${response.statusCode})');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  // ✅ Fetch JWT token from SharedPreferences
  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token'); // Fetch token
  }

  // ✅ Add course to wishlist
  Future<void> _addToWishlist(Map<String, String> course) async {
    final token = await _getAuthToken();
    if (token == null) {
      print("Error: No token found. Please log in.");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(_wishlistAddApiUrl),
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
          _wishlist.add(course["title"]!);
        });
        print("Course added to wishlist");
      } else {
        print("Failed to add course to wishlist: ${response.body}");
      }
    } catch (e) {
      print("Error adding to wishlist: $e");
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
          _wishlist.remove(course["title"]!);
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
    if (_isLoading) {
      return SliverToBoxAdapter(
        child: Center(
          child: Lottie.asset(
            'lib/assets/loading.json',
            width: 200,
            height: 200,
            repeat: false,
          ),
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Text(_errorMessage, style: const TextStyle(color: Colors.red)),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return _buildItem(_courses[index]);
        },
        childCount: _courses.length,
      ),
    );
  }

  Widget _buildItem(Map<String, String> course) {
    return GestureDetector(
      onTap: () {
        widget.onCourseTap(course["title"]!, course["image"]!, course["price"]!);
      },
      child: Container(
        width: 400,
        height: 200,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                child: course["image"]!.isNotEmpty
                    ? Image.network(
                        course["image"]!,
                        width: 400,
                        height: 135,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 100, color: Colors.grey),
                      )
                    : const Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course["title"]!,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _wishlist.contains(course["title"]) ? Icons.favorite : Icons.favorite_border,
                        color: _wishlist.contains(course["title"]) ? Colors.red : Colors.black,
                      ),
                      onPressed: () {
                        if (_wishlist.contains(course["title"])) {
                          _removeFromWishlist(course);
                        } else {
                          _addToWishlist(course);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
