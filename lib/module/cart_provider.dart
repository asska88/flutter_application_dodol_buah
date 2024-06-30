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
    super.notifyListeners();
  }

  CartProvider() {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        fetchCartItems(); // Ambil data keranjang saat login
      }
    });
    fetchCartItems();
  }

  // Mengambil data produk dari Firestore berdasarkan ID
  Future<void> fetchCartItems() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('carts')
            .doc(userId)
            .get();

        if (snapshot.exists) {
          final data = snapshot.data(); // Menggunakan ? untuk nullable

          final itemsData =
              data?['items'] as List<dynamic>?; // Menggunakan ? untuk nullable

          // Menggunakan if untuk memastikan itemsData tidak null
          _items = itemsData
                  ?.map((itemData) => CartItem.fromMap(itemData))
                  .toList() ??
              [];
        } else {
          _items = [];
        }
      } else {
        _items = [];
      }
    } catch (e) {
      print('Error fetching cart items: $e');
      _itemStreamController.addError(e);
    } finally {
      // Selalu jalankan notifierListeners() dan _itemStreamController.add(_items); baik berhasil ataupun error
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
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      try {
        final cartDocRef = _firestore.collection('carts').doc(userId);

        // Check if the document exists
        if (!(await cartDocRef.get()).exists) {
          await cartDocRef
              .set({'items': []}); // Create document if it doesn't exist
        }

        await cartDocRef.update({
          'items': _items.map((item) => item.toMap()).toList(),
        });

        notifyListeners(); // Beri tahu widget lain tentang perubahan
      } on FirebaseException catch (e) {
        if (e.code == 'permission-denied') {
          print('Error updating cart: Permission denied.');
          // Tampilkan pesan error yang sesuai kepada pengguna.
        } else {
          print('Error updating cart: $e');
          // Handle error lainnya jika diperlukan.
        }
      } catch (e) {
        print(
            'Error updating cart: $e'); // Tangani error lain yang tidak terduga.
      }
    }
  }

  Future<void> clearCheckedItems() async {
    _items.removeWhere((item) => item.isChecked);
    await _updateCartInFirestore();
    notifyListeners();
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
