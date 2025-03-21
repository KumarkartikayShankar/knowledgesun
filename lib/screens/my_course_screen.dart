import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:knowledgesun/screens/video_player_screen.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';

class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({super.key});

  @override
  _MyCoursesPageState createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  List<dynamic> myCourses = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchMyCourses();
  }

  /// Fetch JWT token from SharedPreferences
  Future<String?> _getJwtToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  /// Fetch My Courses API Call using POST request
  Future<void> fetchMyCourses() async {
    String? token = await _getJwtToken();
    if (token == null) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
      return;
    }

    final apiUrl = "https://edtechdata.shivamrajdubey.tech/data/mycourses";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"token": token}), // Sending token in request body
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse["success"] == true && jsonResponse.containsKey("courses")) {
          setState(() {
            myCourses = jsonResponse["courses"];
            isLoading = false;
            hasError = false;
          });
        } else {
          setState(() {
            hasError = true;
            isLoading = false;
          });
        }
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Courses")),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Centers vertically
                children: [
                  SizedBox(
                    width: 200, // Adjust size as needed
                    height: 200, // Adjust size as needed
                    child: Lottie.asset(
                      'lib/assets/edloading.json',
                      fit: BoxFit.contain, // Ensures it stays within bounds
                    ),
                  ),
                ],
              ),
            )
          : hasError
              ? const Center(child: Text("Failed to load courses"))
              : ListView.builder(
                  itemCount: myCourses.length,
                  itemBuilder: (context, index) {
                    var course = myCourses[index];
                    return GestureDetector(
                      onTap: () {
                        String videoUrl = course["link"] ?? "";
                        if (videoUrl.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPlayerPage(videoUrl: videoUrl),
                            ),
                          );
                        }
                      },
                      child: Card(
                        margin: const EdgeInsets.all(12),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  course["image"] ?? "",
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 80,
                                      height: 80,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  course["title"] ?? "Untitled Course",
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
