import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final String orderId;

  const OrderConfirmationScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konfirmasi Pesanan'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('orders')
            .doc(orderId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Pesanan tidak ditemukan'));
          } else {
            final orderData = snapshot.data!.data() as Map<String, dynamic>;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nomor Pesanan: $orderId'),
                  const SizedBox(height: 16),
                  Text('Tanggal Pemesanan: ${_formatDate(orderData['orderDate'])}'),
                  const SizedBox(height: 16),
                  Text('Nama Pelanggan: ${orderData['customerName']}'),
                  const SizedBox(height: 8),
                  Text('Nomor Telepon: ${orderData['phoneNumber']}'),
                  const SizedBox(height: 8),
                  const Text('Alamat Pengiriman:'),
                  Text(orderData['shippingAddress']['street']),
                  Text(orderData['shippingAddress']['city']),
                  Text(orderData['shippingAddress']['province']),
                  Text(orderData['shippingAddress']['postalCode']),
                  const SizedBox(height: 16),
                  Text(
                    'Total Pembayaran: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(orderData['totalAmount'])}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Terima kasih telah berbelanja di toko kami!',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  String _formatDate(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    final formatter = DateFormat('dd MMMM yyyy, HH:mm');
    return formatter.format(dateTime);
  }
}
