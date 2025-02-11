import 'package:flutter/material.dart';

class CategoryButtons extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {"label": "Flutter", "isNew": true},
    {"label": "Machine Learning", "isNew": false},
    {"label": "Web Development", "isNew": false},
    {"label": "Node.js", "isNew": false},
    {"label": "Java", "isNew": false},
    {"label": "C Language", "isNew": false},
    {"label": "C++", "isNew": false},
    {"label": "Python", "isNew": false},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120, // Adjust height to fit buttons and text
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center the items vertically
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        print("${category['label']} clicked");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Button color
                        foregroundColor: Colors.white, // Text color
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                      child: Text(category["label"],
                          style: const TextStyle(fontSize: 14)),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
