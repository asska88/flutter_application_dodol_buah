import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/module/cart_provider.dart';
import 'package:provider/provider.dart';

class OrderService {
  static Future<void> completeOrder(
      BuildContext context, Map<String, dynamic> shippingAddress,
      {required TextEditingController namaController,
      required TextEditingController noHpController,
      required String selectedPaymentMethod}) async {
    try {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final checkedItems = cartProvider.checkedItems;
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final totalAmount = cartProvider.checkedTotal; // Total harga pesanan

      final orderData = {
        'userId': userId,
        'customerName': shippingAddress['name'],
        'shippingAddress': shippingAddress,
        'phoneNumber': shippingAddress['phoneNumber'],
        'orderItems': checkedItems.map((item) => item.toMap()).toList(),
        'totalAmount': totalAmount,
        'orderDate': FieldValue.serverTimestamp(),
        'orderStatus': 'pending',
        'paymentMethod': selectedPaymentMethod,
      };

      // Simpan data pesanan ke Firestore
      final firestore = FirebaseFirestore.instance;
      final orderDocRef = await firestore.collection('orders').add(orderData);
      final orderId = orderDocRef.id;

      await cartProvider.clearCheckedItems();

      // Navigasi ke halaman konfirmasi pesanan (opsional)
      if (context.mounted) {
        Navigator.of(context)
            .pushNamed('/orderConfirmation', arguments: orderId);
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pesanan berhasil dibuat')),
        );
      }
    } catch (e) {
      print('Error completing order: $e');
      if (e is FirebaseException) {
        if (e.code == 'permission-denied') {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      'Anda tidak memiliki izin untuk melakukan tindakan ini.')),
            );
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Terjadi kesalahan saat menyimpan pesanan.')),
            );
          }
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Terjadi kesalahan yang tidak diketahui.')),
          );
        }
      }
    }
  }
}
