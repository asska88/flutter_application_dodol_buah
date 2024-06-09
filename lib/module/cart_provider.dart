import 'package:flutter/material.dart';
import 'package:myapp/module/products.dart';

class CartProvider extends ChangeNotifier {
  final List<Product> _cartItems = [];

  List<Product> get cartItems => _cartItems;

  void addToCart(Product product) {
    final existingProduct = _cartItems.firstWhere(
      (item) => item.id == product.id,
      orElse: () => Product (id: -1, name: '', price: 0, image: '', description: ''),
    );
    if (existingProduct.id != -1) {
      existingProduct.quantity++;
    } else {
      _cartItems.add(product);
    }
    notifyListeners();
  }

  void updateQuantity(Product product, int newQuantity) {
    final existingProductIndex = _cartItems.indexWhere(
      (item) => item.id == product.id,
    );
    if (existingProductIndex != -1) {
      _cartItems[existingProductIndex].quantity = newQuantity;
      notifyListeners();
    }
  }
}