import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/module/products.dart';

class CartService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Stream<List<CartItem>> get stream => _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('cart')
          .snapshots()
          .asyncMap((snapshot) async {
        final cartItems = await Future.wait(snapshot.docs.map((doc) async {
          return CartItem.fromDocumentSnapshot(doc); 
        }).toList());
        return cartItems;
      });
}

class CartItem {
  final Product product;
  int quantity;
  bool isChecked;

  CartItem(
      {required this.product, required this.quantity, this.isChecked = false});

  static Future<CartItem> fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc) async {
    final data = doc.data()!;
    final productDoc = await data['product'].get();
    final product = Product.fromFirestore(productDoc);
    return CartItem(
      product: product,
      quantity: data['quantity'] ?? 1,
      isChecked: data['isChecked'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product': product,
      'quantity': quantity,
      'isChecked': isChecked,
    };
  }
}
