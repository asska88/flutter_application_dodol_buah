import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myapp/module/cart_provider.dart';
import 'package:provider/provider.dart';

class OrderDetailScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order detail'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Lihat detail',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .doc(orderId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final orderData = snapshot.data!.data() as Map<String, dynamic>;
            final orderItems = orderData['orderItems'];
            final shippingAddress = orderData['shippingAddress'];

            return SingleChildScrollView(
              // Agar bisa discroll jika konten panjang
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nomor Transaksi
                  Text('no. transaksi', style: GoogleFonts.poppins()),
                  Text('#${orderData['id']}',
                      style: GoogleFonts.jetBrainsMono()),

                  const SizedBox(height: 16),

                  // Nama Pembeli
                  Text('nama pembeli', style: GoogleFonts.poppins()),
                  Text(shippingAddress['name'],
                      style: GoogleFonts.jetBrainsMono()),

                  const SizedBox(height: 16),

                  // Tanggal Beli
                  Text('tanggal beli', style: GoogleFonts.poppins()),
                  Text(
                    DateFormat('dd/MM/yyyy')
                        .format((orderData['orderDate'] as Timestamp).toDate()),
                    style: GoogleFonts.jetBrainsMono(),
                  ),

                  const SizedBox(height: 16),

                  // Detail Produk (dalam Card)
                  Card(
                    child: ListTile(
                      leading: Image.network(
                        orderItems[0]['product']['image'],
                        height: 50,
                        width: 50,
                        fit: BoxFit.contain,
                      ),
                      title: Text(
                        orderItems[0]['product']['name'],
                        style: GoogleFonts.poppins(),
                      ),
                      subtitle: Text(
                        '${orderItems[0]['quantity']}x Rp ${NumberFormat("#,##0", "id_ID").format(orderItems[0]['product']['price'])}',
                        style: GoogleFonts.jetBrainsMono(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Alamat Pengiriman
                  Text('Jl. ${shippingAddress['street']}',
                      style: GoogleFonts.poppins()),
                  Text(
                    '${shippingAddress['city']}, ${shippingAddress['province']}, ${shippingAddress['postalCode']}',
                    style: GoogleFonts.jetBrainsMono(),
                  ),

                  const SizedBox(height: 32),

                  // Total Harga, Ongkir, dan Penjualan
                  Text('total harga (${orderItems.length})',
                      style: GoogleFonts.poppins()),
                  Text(
                    NumberFormat.currency(
                      locale: 'id_ID',
                      symbol: 'Rp',
                      decimalDigits: 0,
                    ).format(cartProvider.checkedTotal),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                  ),

                  const SizedBox(height: 8),
                  Text('Total Penjualan', style: GoogleFonts.poppins()),
                  Text(
                    'Rp ${NumberFormat("#,##0", "id_ID").format(orderData['total'] ?? 0)}',
                    style:
                        GoogleFonts.jetBrainsMono(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 32),

                  // Tombol Kirim Pesanan
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Kirim pesanan'),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
