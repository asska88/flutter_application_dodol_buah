import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String image;
  final double price;
  final String description;
  final int stock; 

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.description,
    required this.stock,
  });

  factory Product.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
  final data = doc.data(); // No longer cast to Map<String, dynamic>
  if (data == null) {
    throw FirebaseException(plugin: 'cloud_firestore', code: 'document-not-found'); // Or provide default values
  }
  return Product(
    id: doc.id,
    name: data['name'] ?? '',
    image: data['image'] ?? '',
    price: (data['price'] as num?)?.toDouble() ?? 0.0, // Safely handle potential null
    description: data['description'] ?? '',
    stock: data['stock']?.toInt() ?? 0,
  );
}

  Map<String, dynamic> toMap() { 
    return {
      'id': id, // Sertakan ID juga saat menyimpan ke Firestore
      'name': name,
      'image': image,
      'price': price,
      'description': description,
      'stock': stock,
    };
  }
}
