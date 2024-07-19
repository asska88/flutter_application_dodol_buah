import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/module/order_notifer.dart';
import 'package:provider/provider.dart';

class OrderDetailScreen extends StatelessWidget {
  final Map<String, dynamic> orderData;

  const OrderDetailScreen({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final orderNotifier = Provider.of<OrderNotifier>(context);
    final orderStatus = orderData['orderStatus'];
    final orderItems = orderData['orderItems'] as List<dynamic>;

    Size screenSize = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Detail'),
        centerTitle: true,
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
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${product['name']} x ${item['quantity']}'),
                      Text(
                          'Rp${NumberFormat("#,##0", "id_ID").format(product['price'])}'),
                    ],
                  ),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Pembayaran: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                    'Rp${NumberFormat("#,##0", "id_ID").format(orderData['totalAmount'])}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold))
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Metode Pembayaran',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text('COD',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            if (orderStatus == 'Selesai') ...[
              const SizedBox(
                  height: 16), // Jarak antara daftar produk dan pesan
              const Center(
                child: Text(
                  'Pesanan Selesai',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              ),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
