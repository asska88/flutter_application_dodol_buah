import 'package:cloud_firestore/cloud_firestore.dart';

class CartiItem {
  final String id;
  final String name;
  final String image;
  final int price;
  final int stok;

  CartiItem(
      {required this.id,
      required this.name,
      required this.image,
      required this.price,
      required this.stok});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'price': price,
      'stock': stok, // Pastikan nama field di Firestore sama
    };
  }

  static Future<CartiItem> fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) async {
    final data = snapshot.data()!;

    return CartiItem(
      id: snapshot.id,
      name: data['name'] ?? '',
      image: data['image'] ?? '',
      price: (data['price'] ?? 0).toInt(),
      stok: (data['stock'] ?? 0).toInt(),
    );
  }
}
