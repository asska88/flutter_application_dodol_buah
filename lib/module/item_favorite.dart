import 'package:cloud_firestore/cloud_firestore.dart';

class ItemFavorit {
  final String id; 
  final String name;
  final String image; 
  final int price;
  final int stok;

  ItemFavorit({
    required this.id, 
    required this.name, 
    required this.image, 
    required this.price, 
    required this.stok
  });

  static Future<ItemFavorit> fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
  ) async {
    snapshot.data();
    final productId = snapshot.id;
    final productDoc = await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .get();

    final productData = productDoc.data()!; 

    return ItemFavorit(
      id: productId,
      name: productData['name'] ?? '',
      image: productData['image'] ?? '',  
      price: (productData['price'] ?? 0).toInt(),
      stok: (productData['stock'] ?? 0).toInt(),
    );
  }
}
