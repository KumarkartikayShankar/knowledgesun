import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:knowledgesun/components/buyanimation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';

class CartPages extends StatefulWidget {
  const CartPages({super.key});

  @override
  _CartPagesState createState() => _CartPagesState();
}

class _CartPagesState extends State<CartPages> {
  List<dynamic> cartItems = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchCartData();
  }

  Future<String?> _getJwtToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<void> fetchCartData() async {
    String? token = await _getJwtToken();
    if (token == null) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
      return;
    }

    final apiUrl = "https://edtechdata.shivamrajdubey.tech/data/cart";

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          cartItems = data;
          isLoading = false;
          hasError = false;
        });
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

  double getTotalPrice() {
    return cartItems.fold(0.0, (sum, course) {
      double price = double.tryParse(course["price"].toString()) ?? 0;
      return sum + price;
    });
  }

  Future<void> removeFromCart(String courseTitle) async {
    String? token = await _getJwtToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not authenticated")),
      );
      return;
    }

    final apiUrl = "https://edtechdata.shivamrajdubey.tech/data/cart/remove";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"title": courseTitle}),
      );

      if (response.statusCode == 200) {
        setState(() {
          cartItems.removeWhere((course) => course["title"] == courseTitle);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Item removed from cart")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to remove item: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: Unable to connect to server")),
      );
    }
  }

  Future<void> buyAllCourses() async {
    String? token = await _getJwtToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not authenticated")),
      );
      return;
    }

    final apiUrl = "https://edtechdata.shivamrajdubey.tech/data/purchase/cart";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          cartItems.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Purchase successful!")),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BuyAnimation()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Purchase failed: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: Unable to connect to server")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
      body: isLoading
          ? Center(
              child: SizedBox(
                width: double.infinity,
                child: Lottie.asset(
                  'lib/assets/loading.json',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            )
          : hasError
              ? const Center(child: Text("Failed to load cart data"))
              : Column(
                  children: [
                    Expanded(
                      child: cartItems.isEmpty
                          ? const Center(child: Text("Cart is empty"))
                          : ListView.builder(
                              itemCount: cartItems.length,
                              itemBuilder: (context, index) {
                                var course = cartItems[index];
                                return Card(
                                  margin: const EdgeInsets.all(12),
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Image.network(
                                            course["image"] ?? "",
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                course["title"] ?? "",
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                "Price: ₹${course["price"]?.toString() ?? "N/A"}",
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.green),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () {
                                            final String courseTitle =
                                                course["title"]?.toString() ??
                                                    "";
                                            removeFromCart(courseTitle);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    if (cartItems.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 10)
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total: ₹${getTotalPrice().toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                            ElevatedButton(
                              onPressed: buyAllCourses,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 14),
                              ),
                              child: const Text("Buy All",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
    );
  }
}
