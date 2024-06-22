import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:myapp/module/products.dart';
import 'package:myapp/service/cart_service.dart';
import 'package:collection/collection.dart';

class CartProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// Suggested code may be subject to a license. Learn more: ~LicenseLog:4018085526.
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<CartItem> _items = [];
  List<CartItem> get items => _items;
  List<CartItem> get checkedItems => items
      .where((item) => item.isChecked)
      .toList(); // Daftar item yang dicentang

  Stream<List<CartItem>> get stream => _itemStreamController.stream;

  final _itemStreamController = StreamController<List<CartItem>>.broadcast();

  @override
  void dispose() {
    _itemStreamController.close();
    super.dispose();
  }

  @override
  void notifyListeners() {
    _itemStreamController
        .add(_items); // Add the updated _items list to the stream
    super.notifyListeners();
  }

CartProvider() {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        fetchCartItems(); // Ambil data keranjang saat login
      } else {
        clearCart(); // Kosongkan keranjang saat logout
      }
    });
  }

  void clearCart() {
    _items.clear(); // Kosongkan list _items
    _updateCartInFirestore(); // Update Firestore (opsional)
    notifyListeners(); // Beritahu listeners bahwa data keranjang telah berubah
  }

  // Mengambil data produk dari Firestore berdasarkan ID
  Future<void> fetchCartItems() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid; // Dapatkan user ID
      if (userId != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('carts')
            .doc(userId)
            .get();
          if (snapshot.exists) {
            final data = snapshot.data() as Map<String, dynamic>;
            final itemsData = data['items'] as List<dynamic>;
            _items = itemsData
                .map((itemData) => CartItem.fromMap(itemData))
                .toList();
          } else {
            _items = [];
          }
          notifyListeners();
        } 
        }catch (e) {
          print('Error fetching cart items: $e');
        _itemStreamController.add(_items);
      }
    }    
  

  // Add a product to the cart
  Future<void> addToCart(Product product, {int quantity = 1}) async {
    final existingItem =
        _items.firstWhereOrNull((item) => item.product.id == product.id);

    if (existingItem != null) {
      existingItem.quantity += quantity;
    } else {
      _items.add(CartItem(
          product: product,
          quantity: quantity,
          isChecked: false)); // Default unchecked
    }

    await _updateCartInFirestore();
    notifyListeners();
  }

  // Remove a product from the cart
  Future<void> removeFromCart(Product product) async {
    _items.removeWhere((item) => item.product.id == product.id);
    await _updateCartInFirestore();
    notifyListeners();
  }

  // Increase the quantity of a product
  Future<void> increaseQuantity(Product product) async {
    final item = _items.firstWhere((item) => item.product.id == product.id);
    item.quantity++;
    await _updateCartInFirestore();
    notifyListeners();
  }

  // Decrease the quantity of a product
  Future<void> decreaseQuantity(Product product) async {
    final item = _items.firstWhere((item) => item.product.id == product.id);
    if (item.quantity > 1) {
      item.quantity--;
      await _updateCartInFirestore();
      notifyListeners();
    }
  }

  // Toggle the checked state of an item
  void toggleItemChecked(Product product) {
    final item = _items.firstWhere((item) => item.product.id == product.id);
    item.isChecked = !item.isChecked;
    _updateCartInFirestore();
    notifyListeners();
  }

  // Update the cart in Firestore
  Future<void> _updateCartInFirestore() async {
    final userId = FirebaseAuth.instance.currentUser?.uid; // Dapatkan user ID
    if (userId != null) {
      await _firestore
          .collection('carts')
          .doc(userId)
          .set(Cart(userId: userId, items: _items).toMap());
    }
  }

  // Calculate the total price of checked items
  double get checkedTotal {
    return _items.where((item) => item.isChecked).fold(
        0.0,
        (currentTotal, item) =>
            currentTotal + item.product.price * item.quantity);
  }

  double totalPrice(List<CartItem> items) {
    double total = 0;
    for (var item in items) {
      if (item.isChecked) {
        total += item.product.price * item.quantity;
      }
    }
    return total;
  }
}
