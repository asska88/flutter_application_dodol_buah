import 'package:myapp/module/products.dart';

class Cart {
  final String userId;
  final List<CartItem> items;

  Cart({required this.userId, required this.items});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}

class CartItem {
  final Product product;
  int quantity;
  bool isChecked;

  CartItem({required this.product, required this.quantity, this.isChecked = false});

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      product: Product.fromFirestore(map['product']), 
      quantity: map['quantity'],
      isChecked: map['isChecked'] ?? false, // Handle the case where isChecked might not be present in the map
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(Map),
      'quantity': quantity,
      'isChecked': isChecked,
    };
  }
}