import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderDetailScreen extends StatelessWidget {
  final Map<String, dynamic> orderData;

  const OrderDetailScreen({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    final orderItems = orderData['orderItems'] as List<dynamic>;

    Size screenSize = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pesanan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                height: screenSize.width * 0.6,
                width: screenSize.width * 0.6,
                child: Image.network(
                  orderItems[0]['product']['image'],
                  height: 50,
                  width: 50,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // Tampilkan informasi pesanan sesuai kebutuhan
            Text('Nomor Pesanan: ${orderData['userId']}'),
            Text('Status: ${orderData['orderStatus']}'),
            Text(
                'Tanggal Pemesanan: ${DateFormat('dd MMMM yyyy, HH:mm').format(orderData['orderDate'].toDate())}'),
            Text('Nama Pelanggan: ${orderData['customerName']}'),
            Text('Nomor Telepon: ${orderData['phoneNumber']}'),
            Text(
                'Alamat Pengiriman: ${orderData['shippingAddress']['street']}, ${orderData['shippingAddress']['city']}, ${orderData['shippingAddress']['province']}, ${orderData['shippingAddress']['postalCode']}'),
            Text('Metode Pembayaran: ${orderData['paymentMethod']}'),

            const SizedBox(height: 16),

            const Text('Daftar Produk:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orderItems.length,
              itemBuilder: (context, index) {
                final item = orderItems[index];
                final product = item['product'];
                return ListTile(
                  title: Text(product['name']),
                  subtitle: Text(
                      'x${item['quantity']} - Rp${NumberFormat("#,##0", "id_ID").format(product['price'])}'),
                );
              },
            ),

            const SizedBox(height: 16),

            Text(
                'Total Pembayaran: Rp${NumberFormat("#,##0", "id_ID").format(orderData['totalAmount'])}'),
          ],
        ),
      ),
    );
  }
}
