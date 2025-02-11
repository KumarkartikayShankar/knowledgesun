import 'package:flutter/material.dart';
import 'package:knowledgesun/components/carousel.dart';
import 'package:knowledgesun/components/courseGrid.dart';
import 'package:knowledgesun/components/drawer.dart';
import 'package:knowledgesun/components/searchbar.dart';
import 'package:knowledgesun/components/sliderbutton_horizontal.dart';


class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    var currentTheme = Theme.of(context);

    return Scaffold(
      backgroundColor: currentTheme.colorScheme.surface,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: currentTheme.colorScheme.inversePrimary,
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Ensure the column takes minimum height
          children: [
            const Carousel(),
            const Padding(
              padding: EdgeInsets.only(right: 16, top: 10),
              child: Align(
                alignment: Alignment.centerRight,
                child: StaticSearchTextField(),
              ),
            ),
            const SizedBox(height: 8), // Add a small gap if needed
            CategoryButtons(), // Ensure this widget doesn't have extra padding/margin
            // Set a fixed height for the grid
           CoursesGridScreen(),
            
          ],
        ),
      ),
    );
  }
}
