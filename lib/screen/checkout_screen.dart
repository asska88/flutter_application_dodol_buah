import 'package:flutter/material.dart';
import 'package:myapp/module/cart_provider.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatelessWidget {
  final List<CartItem> checkedItems;

  const CheckoutScreen({super.key, required this.checkedItems});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ringkasan Pesanan
            const Text('Ringkasan Pesanan:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: checkedItems.length,
              itemBuilder: (context, index) {
                final item = checkedItems[index];
                return ListTile(
                  title: Text(item.product.name),
                  trailing: Text('${item.quantity} x Rp. ${item.product.price.toStringAsFixed(0)}'),
                );
              },
            ),
            const SizedBox(height: 16),
            Text('Total: Rp. ${cartProvider.totalPrice(checkedItems).toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),

            // Formulir Alamat Pengiriman
            const Text('Alamat Pengiriman:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const TextField(decoration: InputDecoration(labelText: 'Nama Lengkap')),
            const TextField(decoration: InputDecoration(labelText: 'Alamat Lengkap')),
            const TextField(decoration: InputDecoration(labelText: 'Nomor Telepon')),
            const SizedBox(height: 32),

            // Pilihan Metode Pembayaran
            const Text('Metode Pembayaran:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            // ... (Tambahkan pilihan metode pembayaran di sini)

            const SizedBox(height: 32),

            // Tombol Selesaikan Pembayaran
            ElevatedButton(
              onPressed: () {
                // ... (Logika untuk menyelesaikan pembayaran)
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff8A49F7),
                foregroundColor: Colors.white,
              ),
              child: const Text('Selesaikan Pembayaran'),
            ),
          ],
        ),
      ),
    );
  }
}
