import 'package:flutter/foundation.dart';

class OrderNotifier extends ChangeNotifier {
  bool _isOrderSent = false;
  String? _isOrderNotification;

  bool get isOrderSent => _isOrderSent;
  String? get isOrderNotification => _isOrderNotification;

  void sendOrder() {
    _isOrderSent = true;
    _isOrderNotification = 'Pesanan Telah Dikirim';
    notifyListeners(); // Inform listeners of the state change
  }

}
