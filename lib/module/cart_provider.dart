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

  Stream<List<CartItem>> get stream async* {
    if (_auth.currentUser != null) {
      await for (var snapshot in _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('cart')
        .snapshots()) {
      yield await Future.wait(snapshot.docs.map((doc) async {
        // Await the get() method to obtain the DocumentSnapshot
        final productDoc = doc as DocumentSnapshot<Map<String, dynamic>>;

        // Now use the cast DocumentSnapshot
        return CartItem.fromDocumentSnapshot(productDoc);
      }).toList());
    }
    }else{
      yield[];
    }
    
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  CartProvider() {
    _auth.authStateChanges().listen((user) {
      stream.listen((items) {
        _items = items;
        notifyListeners();
      });
      // Ambil data keranjang saat login
    });
  }

  // Mengambil data produk dari Firestore berdasarkan ID
  Future<void> fetchCartItems() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('cart')
            .get();

        if (snapshot.docs.isNotEmpty) {
          _items = await Future.wait(snapshot.docs
              .map((doc) => CartItem.fromDocumentSnapshot(doc))
              .toList());
        } else {
          _items = [];
        }
      } else {
        _items = [];
      }
      notifyListeners();
    } on FirebaseException catch (e) {
      print('Error fetching cart items: $e');
    } catch (e) {
      print('Error fetching cart items: $e');
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
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final userDocRef = _firestore.collection('users').doc(user.uid);
        final cartSubcollectionRef = userDocRef.collection('cart');

        // Create or update cart items in the subcollection
        for (final item in _items) {
          final productRef =
              FirebaseFirestore.instance.doc('products/${item.product.id}');
          await cartSubcollectionRef.doc(item.product.id).set({
            'product': productRef,
            'quantity': item.quantity,
            'isChecked': item.isChecked,
          });
        }

        // Remove items that are not in _items
        final cartSnapshot = await cartSubcollectionRef.get();
        for (final doc in cartSnapshot.docs) {
          if (!_items.any((item) => item.product.id == doc.id)) {
            await doc.reference.delete();
          }
        }

        notifyListeners(); // Notify listeners of changes
      } on FirebaseException {
        // ... (error handling)
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
