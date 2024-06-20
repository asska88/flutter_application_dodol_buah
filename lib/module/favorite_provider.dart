import 'package:flutter/foundation.dart';
import 'package:myapp/service/favorite_service.dart';

class FavoriteProvider extends ChangeNotifier {
  final FavoriteService _favoriteService = FavoriteService();
  final Map<String, bool> _favoriteStatus = {}; // Menyimpan status favorit per produk

  bool isFavorite(String productId) {
    return _favoriteStatus[productId] ?? false;
  }

  Future<void> toggleFavorite(String userId, String productId, Map<String, dynamic> productData) async {
    if (isFavorite(productId)) {
      await _favoriteService.removeFavorite(userId, productId);
      _favoriteStatus[productId] = false;
    } else {
      await _favoriteService.addFavorite(userId, productId, productData);
      _favoriteStatus[productId] = true;
    }
    notifyListeners(); // Beri tahu widget yang mendengarkan perubahan
  }
}
