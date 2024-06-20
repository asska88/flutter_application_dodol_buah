import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/module/item_favorite.dart';

class FavoriteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addFavorite(String userId, String productId, Map<String, dynamic> productData) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorit')
        .doc(productId)
        .set(productData); 
  }

  Future<void> removeFavorite(String userId, String productId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorit')
        .doc(productId)
        .delete();
  }

  Stream<List<ItemFavorit>> getFavoritesStream(String userId) {
  return _firestore
      .collection('users')
      .doc(userId)
      .collection('favorit')
      .snapshots()
      .asyncMap((querySnapshot) async {
    final favoriteProducts = <ItemFavorit>[];
    for (final doc in querySnapshot.docs) {
      final itemFavorit =
          await ItemFavorit.fromFirestore(doc, null); // Use static method
      favoriteProducts.add(itemFavorit);
    }
    return favoriteProducts;
  });
}

Future<bool> isFavoriteCollectionExists(String userId) async {
    try {
      final favoriteCollectionRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('favorit');

      final snapshot = await favoriteCollectionRef.limit(1).get();
      return snapshot.docs.isNotEmpty; // Check if any documents exist
    } catch (e) {
      // If the collection doesn't exist, this will throw an exception
      return false;
    }
  }

}
