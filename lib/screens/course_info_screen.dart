import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:knowledgesun/components/buyanimation.dart';
import 'dart:convert';
import 'package:knowledgesun/components/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart'; // ✅ Import Lottie

class CourseInfoScreen extends StatefulWidget {
  final String courseTitle;
  final String courseImage;
  final String coursePrice;

  const CourseInfoScreen({
    super.key,
    required this.courseTitle,
    required this.courseImage,
    required this.coursePrice,
  });

  @override
  _CourseInfoScreenState createState() => _CourseInfoScreenState();
}

class _CourseInfoScreenState extends State<CourseInfoScreen> {
  String? courseDescription;
  String? coursePrice;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchCourseDescription();
  }

  Future<void> fetchCourseDescription() async {
    final apiUrl =
        "https://edtech-database.vercel.app/data/courses/title/${Uri.encodeComponent(widget.courseTitle)}";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isNotEmpty) {
          setState(() {
            courseDescription = data[0]['description'] ?? "No description available.";
            coursePrice = data[0]['price'] ?? widget.coursePrice;
            isLoading = false;
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
      appBar: AppBar(title: Text(widget.courseTitle)),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Card(
                  margin: const EdgeInsets.all(8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                    side: const BorderSide(color: Colors.black),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(17),
                    child: SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: widget.courseImage.isNotEmpty
                          ? Image.network(widget.courseImage, fit: BoxFit.cover)
                          : const Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    "Details for ${widget.courseTitle}",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                isLoading
                    ? Center(
                        child: Lottie.asset(
                          'lib/assets/coursedetail.json', // ✅ Replace with Lottie animation
                          width: 200,
                          height: 200,
                        ),
                      )
                    : hasError
                        ? const Text("Failed to load description", style: TextStyle(color: Colors.red))
                        : Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Text(
                                  courseDescription ?? "No description available.",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Price: ₹${coursePrice ?? 'N/A'}",
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                                ),
                              ],
                            ),
                          ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 63,
                  child: ElevatedButton(
                    onPressed: () {
                      Provider.of<CartProvider>(context, listen: false)
                          .addToCart(widget.courseTitle, widget.courseImage, widget.coursePrice);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${widget.courseTitle} added to cart"),
                         duration: const Duration(seconds: 1),),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    ),
                    child: const Text("Add to Cart", style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 63,
                  child: ElevatedButton(
                    onPressed: () {
                       Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BuyAnimation()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    ),
                    child: const Text("Buy Now", style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
