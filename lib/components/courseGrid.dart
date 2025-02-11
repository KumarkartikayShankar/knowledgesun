import 'package:flutter/material.dart';

class CoursesGridScreen extends StatelessWidget {
  final List<Map<String, String>> courses = [
    {"title": "Flutter Basics", "image": "https://picsum.photos/seed/picsum/200/300"},
    {"title": "Java", "image": "https://picsum.photos/200/300"},
    {"title": "UI/UX Design", "image": "https://picsum.photos/400?random=7"},
    {"title": "Machine Learning", "image": "https://picsum.photos/400?random=8"},
    {"title": "Cyber Security", "image": "https://picsum.photos/400?random=9"},
    {"title": "Data Science", "image": "https://picsum.photos/400?random=11"},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true, // ✅ Fix for infinite height issue
      physics:  NeverScrollableScrollPhysics(), // ✅ Prevents scroll conflicts
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    courses[index]["image"]!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  courses[index]["title"]!,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
