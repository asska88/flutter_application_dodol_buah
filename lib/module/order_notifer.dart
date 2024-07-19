import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class OrderNotifier extends ChangeNotifier {
  String? _orderStatus;
  String? get orderStatus => _orderStatus;

  Future<void> orderSend(String orderId) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update({'orderStatus': 'Selesai'})
          .then((value) => print("orderStatus Updated"))
          .catchError((error) => print("Failed to update orderStatus: $error"));
      

      _orderStatus = 'Selesai';
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating order status: $e');
    }
  }
}
