import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myapp/module/cart_provider.dart';
import 'package:myapp/module/shipping_address_form.dart';
import 'package:myapp/service/cart_service.dart';
import 'package:myapp/service/order_service.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  _CheckoutScreenState get state => this;
  final _formKey = GlobalKey<FormState>();
  String? _selectedPaymentMethod;
  Map<String, dynamic>? selectedAddress;

  bool _isAddingNewAddress = false;

  List<CartItem> checkedItems = [];

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
    return Consumer<CartProvider>(
        // Use Consumer to listen to CartProvider changes
        builder: (context, cartProvider, child) {
      final checkedItems = cartProvider.checkedItems;
      Size screenSize = MediaQuery.sizeOf(context);
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
                      leading: Image.network(
                        item.product.image,
                        fit: BoxFit.fill,
                        width: screenSize.width * 0.1,
                        height: screenSize.height * 0.1,
                      ),
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
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
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
                  ],
                ),
                const SizedBox(height: 32),

                // Form Alamat Pengiriman
                const Center(
                  child: Text('Alamat Pengiriman:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8),
                ShippingAddressForm(
                  onAddressSelected: (address) {
                    setState(() {
                      selectedAddress = address;
                      _isAddingNewAddress = false;
                    });
                  },
                ),
                if (!_isAddingNewAddress && selectedAddress != null)
                  Column(
                    children: [
                      const Text('Alamat Tersimpan:'),
                      Text(selectedAddress!['street']),
                      Text(selectedAddress!['city']),
                      Text(selectedAddress!['province']),
                      Text(selectedAddress!['postalCode']),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isAddingNewAddress = true;
                          });
                        },
                        child: const Text('Tambah Alamat Baru'),
                      ),
                    ],
                  ),

                const SizedBox(height: 32),

                // Pilihan Metode Pembayaran
                const Text('Metode Pembayaran:',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                  onPressed: () async {
                    if (_formKey.currentState!.validate() &&
                        _selectedPaymentMethod != null &&
                        selectedAddress != null) {
                      await OrderService.completeOrder(
                          context, selectedAddress!,
                          namaController: TextEditingController(),
                          noHpController: TextEditingController(),
                          selectedPaymentMethod: _selectedPaymentMethod!);
                      print(
                          '_formKey.currentState!.validate(): ${_formKey.currentState!.validate()}');
                      print('_selectedPaymentMethod: $_selectedPaymentMethod');
                      print('_isAddingNewAddress: $_isAddingNewAddress');
                      print('selectedAddress: $selectedAddress');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Harap lengkapi formulir dan pilih alamat pengiriman.'),
                        ),
                      );
                    }
                    if (_isAddingNewAddress) {
                      setState(() {
                        _isAddingNewAddress = false;
                      });
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
// Tutup formulir jika sedang menambahkan alamat baru
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff8A49F7),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
                  ),
                  child: const Text('Selesaikan Pembayaran'),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
