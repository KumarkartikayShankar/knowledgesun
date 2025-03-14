import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lottie/lottie.dart';

class CoursesList extends StatefulWidget {
  final ScrollController scrollController;
  final Function(String, String, String) onCourseTap; // ✅ Updated to include price

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
  List<Map<String, String>> _courses = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

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
                    "price": course["price"] ?? "N/A", // ✅ Fetch price from API
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SliverToBoxAdapter(
        child: Center(
          child:  Lottie.asset(
              'lib/assets/loading.json', // Ensure this file is in the assets folder
              width: 200,
              height: 200,
              repeat: false, // Play animation only once
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
        widget.onCourseTap(course["title"]!, course["image"]!, course["price"]!); // ✅ Pass price
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
                      icon: const Icon(Icons.favorite_border, color: Colors.black),
                      onPressed: () {},
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
