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
        title: const Text('Selesai'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('orders').doc(orderId).get(),
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
                  const SizedBox(height: 16),
                  const Text('Daftar Produk:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: orderData['orderItems'].length,
                    itemBuilder: (context, index) {
                      final item = orderData['orderItems'][index];
                      final product = item['product']; // Ambil data produk
                      return _buildProductCard(product, item['quantity']);
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          color: Colors.grey[100],
                          height: 20,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tanggal Pemesanan:'),
                      Text(_formatDate(orderData['orderDate']))
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Nama Pelanggan: '),
                      Text(orderData['customerName']),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Nomor Telepon:'),
                      Text(orderData['phoneNumber']),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Alamat Pengiriman:'),
                  Text(orderData['shippingAddress']['street']),
                  Text(orderData['shippingAddress']['city']),
                  Text(orderData['shippingAddress']['province']),
                  Text(orderData['shippingAddress']['postalCode']),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Nomor Pesanan:'),
                      Text(orderId),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Pembayaran: ',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        NumberFormat.currency(
                                locale: 'id_ID',
                                symbol: 'Rp ',
                                decimalDigits: 0)
                            .format(orderData['totalAmount']),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
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

  Widget _buildProductCard(Map<String, dynamic> product, int quantity) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Card(
      elevation: 10,
      color: Colors.grey[200],
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar produk (jika ada)
            if (product['image'] != null)
              Image.network(
                product['image'],
                width: 50,
                height: 50,
                fit: BoxFit.contain,
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${formatCurrency.format(product['price'])} x $quantity',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    final formatter = DateFormat('dd MMMM yyyy, HH:mm');
    return formatter.format(dateTime);
  }
}
