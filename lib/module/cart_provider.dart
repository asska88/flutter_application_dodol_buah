import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:myapp/module/products.dart';

class CartItem {
  final Product product;
  int quantity;
  bool isChecked;

  CartItem({required this.product, this.quantity = 1, this.isChecked = false});
}

class CartProvider extends ChangeNotifier {
  
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  void toggleItemChecked(Product product) {
    final item = cartItems.firstWhere((item) => item.product == product);
    item.isChecked = !item.isChecked;
    notifyListeners();
  }

  List<CartItem> get checkedItems => cartItems.where((item) => item.isChecked).toList(); // Daftar item yang dicentang


  // Mengambil data produk dari Firestore berdasarkan ID
  Future<Product?> getProductById(String productId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .get();
      if (doc.exists) {
        return Product.fromFirestore(doc);
      } else {
        return null; 
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching product: $e");
      }
      return null;
    }
  }

  void addToCart(Product product, {required int quantity}) {
    final existingCartItemIndex = _cartItems.indexWhere(
      (item) => item.product.id == product.id,
    );
    if (existingCartItemIndex != -1) {
      _cartItems[existingCartItemIndex].quantity++;
    } else {
      _cartItems.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void increaseQuantity(Product product) {
    _updateQuantity(product, 1);
  }

  void decreaseQuantity(Product product) {
    _updateQuantity(product, -1);
  }
  void removeFromCart(Product product) {
    cartItems.removeWhere((item) => item.product == product);
    notifyListeners();
  }

  void _updateQuantity(Product product, int change) {
    final existingCartItemIndex = _cartItems.indexWhere(
      (item) => item.product.id == product.id,
    );
    if (existingCartItemIndex != -1) {
      _cartItems[existingCartItemIndex].quantity += change;
      if (_cartItems[existingCartItemIndex].quantity <= 0) {
        _cartItems.removeAt(existingCartItemIndex);
      }
      notifyListeners();
    }
  }

  double totalPrice(List<CartItem> cartItems) {
    double total = 0;
    for (var item in cartItems) {
      if (item.isChecked) {
  total += item.product.price * item.quantity;
}
    }
    return total;
  }

}
