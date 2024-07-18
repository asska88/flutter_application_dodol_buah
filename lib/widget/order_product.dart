import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/screen/order_detail_screen.dart';

class OrderProduct extends StatefulWidget {
  const OrderProduct({super.key});

  @override
  State<OrderProduct> createState() => _OrderProductState();
}

class _OrderProductState extends State<OrderProduct> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text('Anda belum masuk.'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pesanan Anda'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: user.uid) // Filter berdasarkan userId
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final orderDocs = snapshot.data!.docs;

          if (orderDocs.isEmpty) {
            return const Center(child: Text('Anda belum memiliki pesanan.'));
          }

          return ListView.builder(
            itemCount: orderDocs.length,
            itemBuilder: (context, index) {
              final orderData = orderDocs[index].data() as Map<String, dynamic>;
              return _buildOrderCard(context, orderData);
            },
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Map<String, dynamic> orderData) {
    final orderItems = orderData['orderItems'] as List<dynamic>;
return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailScreen(orderData: orderData), // Menggunakan userId sebagai orderId
          ),
        );
      },
    child:  Card(
      child: ListTile(
        leading:
            orderItems.isNotEmpty && orderItems[0]['product']['image'] != null
                ? Image.network(
                    orderItems[0]['product']
                        ['image'], // Ambil gambar dari item pertama
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                : null,
        title: Text('Nomor Pesanan: ${orderData['userId']}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status: ${orderData['orderStatus']}'),
            Text(
                'Tanggal Pemesanan: ${DateFormat('dd MMMM yyyy, HH:mm').format(orderData['orderDate'].toDate())}'),
            
          ],
        ),
      ),
    ));
  }
}
