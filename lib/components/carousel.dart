import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lottie/lottie.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  List<String> imageUrls = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchImageUrls();
  }

  Future<void> fetchImageUrls() async {
    try {
      final response = await http.get(
        Uri.parse('https://edtechdata.shivamrajdubey.tech/data/images/latest'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          imageUrls = data.map<String>((item) => item['url'] as String).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load images. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching images: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: 240, // Height of the carousel
            child: isLoading
                ? Center(
                    child: Lottie.network(
                      'https://assets10.lottiefiles.com/packages/lf20_3rwasyjy.json', // Lottie animation
                      width: 150,
                      height: 150,
                      repeat: true,
                    ),
                  )
                : imageUrls.isEmpty
                    ? const Center(child: Text('No images available'))
                    : CarouselSlider(
                        options: CarouselOptions(
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 2),
                          autoPlayAnimationDuration: const Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          viewportFraction: 0.8,
                          aspectRatio: 16 / 9,
                        ),
                        items: imageUrls.map((url) {
                          return Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.7),
                                  blurRadius: 6,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              image: DecorationImage(
                                image: NetworkImage(url),
                                fit: BoxFit.cover,
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
