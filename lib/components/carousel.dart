import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Make sure to add this package to your pubspec.yaml

class Carousel extends StatelessWidget {
  const Carousel({super.key});

  @override
  Widget build(BuildContext context) {
    // List of image URLs
    final List<String> imageUrls = [
      'https://picsum.photos/400?random=1',
      'https://picsum.photos/400?random=2',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQzP2uuHWysesIsQDu2FxnWE1L5kIHyfYOputjUb8om608qVHXpW7zJ7Dl5uHpMuR05B3w&usqp=CAU',
      'https://picsum.photos/400?random=4',
      'https://picsum.photos/400?random=5',
    ];

    return 
       SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 240, // Height of the carousel
              child: CarouselSlider(
                options: CarouselOptions(
                  
                  autoPlay: true, // Enable auto-play
                  autoPlayInterval: const Duration(seconds: 2), // Auto-play interval
                  autoPlayAnimationDuration: const Duration(milliseconds: 800), // Animation duration
                  autoPlayCurve: Curves.fastOutSlowIn, // Animation curve
                  enlargeCenterPage: true, // Enlarge the center item
                  viewportFraction: 0.8, // Increase width of each item
                  aspectRatio: 16 / 9, // Aspect ratio
                ),
                items: imageUrls.map((url) {
                  return Container(
                    margin: const EdgeInsets.all(8), // Add padding
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12), // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 4), // Add elevation
                        ),
                      ],
                      image: DecorationImage(
                        image: NetworkImage(url),
                        fit: BoxFit.cover, // Cover the container
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    
  }
}

