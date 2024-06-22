import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myapp/module/cart_provider.dart';
import 'package:myapp/service/cart_service.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {

  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  String? _selectedPaymentMethod; // Store the selected payment method
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();

  List<CartItem> checkedItems = [];

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    _noHpController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments is List<CartItem>) {
      setState(() {
        checkedItems = arguments;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>( // Use Consumer to listen to CartProvider changes
      builder: (context, cartProvider, child) {
        final checkedItems = cartProvider.checkedItems;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ringkasan Pesanan
              const Text(
                'Ringkasan Pesanan:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: checkedItems.length,
                itemBuilder: (context, index) {
                  final item = checkedItems[index];
                  return ListTile(
                    title: Text(item.product.name),
                    trailing: Text(
                        '${item.quantity} x Rp. ${item.product.price.toStringAsFixed(0)}'),
                  );
                },
              ),
              const SizedBox(height: 16),
              Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total:',
                  style: GoogleFonts.openSans(
                    fontSize: 18, fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  NumberFormat.currency(
                    locale: 'id_ID',
                    symbol: 'Rp',
                    decimalDigits: 0,
                  ).format(cartProvider.checkedTotal),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
              const SizedBox(height: 32),

              // Form Alamat Pengiriman
              const Text('Alamat Pengiriman:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _alamatController,
                decoration:
                    const InputDecoration(labelText: 'Alamat Lengkap'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _noHpController,
                decoration:
                    const InputDecoration(labelText: 'Nomor Telepon'),
                keyboardType: TextInputType.phone,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor telepon tidak boleh kosong';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              // Pilihan Metode Pembayaran
              const Text('Metode Pembayaran:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              // Contoh pilihan metode pembayaran dengan radio button
              RadioListTile<String>(
                title: const Text('COD (Bayar di Tempat)'),
                value: 'cod',
                groupValue: _selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value;
                  });
                },
              ),

              const SizedBox(height: 32),

              // Tombol Selesaikan Pembayaran
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      _selectedPaymentMethod != null) {
                    // Logika untuk menyelesaikan pembayaran dengan validasi form dan pilihan metode pembayaran
                    print("Nama: ${_namaController.text}");
                    print("Alamat: ${_alamatController.text}");
                    print("No HP: ${_noHpController.text}");
                    print("Metode Pembayaran: $_selectedPaymentMethod");
                  }
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
      ),
    );
  }
  
);
  }}