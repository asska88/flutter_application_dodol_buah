import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myapp/screen/order_confirmation_screen.dart';
import 'package:myapp/screen/order_detail_admin_screen.dart';

class OrderItem extends StatelessWidget {
  final bool showCheckbox;
  final DocumentSnapshot documentSnapshot;
  const OrderItem({super.key, required this.documentSnapshot, required this.showCheckbox});

  @override
  Widget build(BuildContext context) {
    final CollectionReference orders =
        FirebaseFirestore.instance.collection('orders');
    final orderItems = documentSnapshot['orderItems'];
    final firstItem =
        orderItems != null && orderItems.isNotEmpty ? orderItems[0] : null;
    if (firstItem != null) {
      final product = firstItem['product'];
      return showCheckbox ? InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  OrderDetailAdminScreen(orderId: documentSnapshot.id),
            ),
          );
        },
        child: Card(
          surfaceTintColor: Colors.grey,
          shadowColor: Colors.purple,
          elevation: 3,
          margin: const EdgeInsets.all(10),
          child: ListTile(
            leading: Image.network(
              product?['image'] ?? '', // Gunakan ?? untuk menangani null
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    product?['name'] ?? 'Nama produk tidak tersedia',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Text(
                  '${firstItem['quantity']} item',
                  style: GoogleFonts.jetBrainsMono(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '#${documentSnapshot.id}', // Nomor pesanan
                  style: GoogleFonts.jetBrainsMono(),
                ),
                Text(
                  DateFormat('dd MMM yyyy HH:mm').format(
                    (documentSnapshot['orderDate'] as Timestamp).toDate(),
                  ), // Tanggal pesanan
                  style: GoogleFonts.jetBrainsMono(),
                ),
              ],
            ),
            trailing:showCheckbox ? Checkbox(
              value: (documentSnapshot.data() as Map<String, dynamic>?)
                      ?.containsKey('isDone') ??
                  false, // Mengubah data menjadi Map<String, dynamic> dan menangani null
              onChanged: (value) {
                orders
                    .doc(documentSnapshot.id)
                    .update({'isDone': value ?? false});
              },
            ):null
          ),
        ),
      ): InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  OrderConfirmationScreen(orderId: documentSnapshot.id),
            ),
          );
        },
        child: Card(
          surfaceTintColor: Colors.grey,
          shadowColor: Colors.purple,
          elevation: 3,
          margin: const EdgeInsets.all(10),
          child: ListTile(
            leading: Image.network(
              product?['image'] ?? '', // Gunakan ?? untuk menangani null
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    product?['name'] ?? 'Nama produk tidak tersedia',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Text(
                  '${firstItem['quantity']} item',
                  style: GoogleFonts.jetBrainsMono(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '#${documentSnapshot.id}', // Nomor pesanan
                  style: GoogleFonts.jetBrainsMono(),
                ),
                Text(
                  DateFormat('dd MMM yyyy HH:mm').format(
                    (documentSnapshot['orderDate'] as Timestamp).toDate(),
                  ), // Tanggal pesanan
                  style: GoogleFonts.jetBrainsMono(),
                ),
              ],
            ),
            trailing:showCheckbox ? Checkbox(
              value: (documentSnapshot.data() as Map<String, dynamic>?)
                      ?.containsKey('isDone') ??
                  false, // Mengubah data menjadi Map<String, dynamic> dan menangani null
              onChanged: (value) {
                orders
                    .doc(documentSnapshot.id)
                    .update({'isDone': value ?? false});
              },
            ):null
          ),
        ),
      );
    } else {
      return Container(); // Kembalikan wadah kosong jika produk null.
    }
  }
}
