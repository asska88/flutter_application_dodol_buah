import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String image;
  final double price;
  final String description;


  Product(
      {required this.id,
      required this.name,
      required this.image,
      required this.price,
      required this.description,
      });

      factory Product.fromFirestore(DocumentSnapshot doc){
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>; 
        return Product(
          id: doc.id,
          name: data['name'] ?? '',
          image: data['image'] ?? '',
          price: data['price']?.toDouble() ?? 0.0,
          description: data['description'] ?? '',
        );
      }
}
