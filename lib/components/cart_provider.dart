import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, String>> _cartItems = [];

  List<Map<String, String>> get cartItems => _cartItems;

  void addToCart(String title, String image, String price) {
    print("Adding to cart - Title: $title, Price: $price"); // Debugging line
    _cartItems.add({
      "title": title,
      "image": image,
      "price": price,
    });
    notifyListeners();
  }

  void removeFromCart(String title) {
    _cartItems.removeWhere((course) => course["title"] == title);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
