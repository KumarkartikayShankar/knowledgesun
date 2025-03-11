import 'package:flutter/material.dart';
import 'package:knowledgesun/components/carousel.dart';
import 'package:knowledgesun/components/courseGrid.dart';
import 'package:knowledgesun/components/drawer.dart';
import 'package:knowledgesun/components/searchbar.dart';
import 'package:knowledgesun/components/sliderbutton_horizontal.dart';
import 'package:knowledgesun/screens/course_info_screen.dart';


class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final ScrollController _scrollController = ScrollController();

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
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Carousel(),
                const Padding(
                  padding: EdgeInsets.only(right: 16, top: 10),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: AnimatedSearchTextFeild(),
                  ),
                ),
                const SizedBox(height: 8),
                CategoryButtons(),
              ],
            ),
          ),
          CoursesList(
            scrollController: _scrollController,
            onCourseTap: (courseTitle, courseImage, coursePrice) { // ✅ Updated to pass price
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseInfoScreen(
                    courseTitle: courseTitle,
                    courseImage: courseImage,
                    coursePrice: coursePrice, // ✅ Pass correct price
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
