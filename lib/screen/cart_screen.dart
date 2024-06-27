import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myapp/module/cart_provider.dart';
import 'package:myapp/module/products.dart';
import 'package:myapp/service/cart_service.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<CartProvider>(context, listen: false).fetchCartItems();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.sizeOf(context);
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 10,
          title: const Text('Keranjang Belanja'),
        ),
        body: StreamBuilder<List<CartItem>>(
            stream: cartProvider.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator()); // Tampilkan loading saat menunggu data
              } else if (snapshot.hasError) {
                return Text(
                    'Error: ${snapshot.error}'); // Tampilkan error jika terjadi
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text(
                    'Keranjang Kosong'); // Tampilkan pesan jika keranjang kosong
              } else {
                final cartItems = snapshot.data!;
                return Stack(
                  children: [
                    ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final cartItem = cartItems[index];
                        final product = cartItem.product;
                        final quantity = cartItem.quantity;
                        return _buildCartItem(context, screenSize, product,
                            cartProvider, quantity, cartItem);
                      },
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: _buildBottomBar(
                          context, screenSize, cartProvider, cartItems),
                    ),
                  ],
                );
              }
            }));
  }

  Widget _buildBottomBar(
    BuildContext context,
    Size screenSize,
    CartProvider cartProvider,
    List<CartItem> cartItems,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: screenSize.width * 0.6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Total:',
                  style: GoogleFonts.openSans(
                      fontSize: 18, fontWeight: FontWeight.w400),
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
          ),
          _checkoutButton(context, cartProvider),
        ],
      ),
    );
  }

  ElevatedButton _checkoutButton(
      BuildContext context, CartProvider cartProvider) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff8A49F7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onPressed: () {
        if (cartProvider.items.where((item) => item.isChecked).isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pilih item yang ingin di-checkout')),
          );
        } else {
          // Pass the filtered items directly to CheckoutScreen
          Navigator.pushNamed(context, '/checkout',
              arguments:
                  cartProvider.items.where((item) => item.isChecked).toList());
        }
      },
      child: Text(
        'Checkout',
        style: GoogleFonts.openSans(color: Colors.white),
      ),
    );
  }

  Widget _buildCartItem(
    BuildContext context,
    Size screenSize,
    Product product,
    CartProvider cartProvider,
    int quantity,
    CartItem cartItem,
  ) {
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      elevation: 3,
      child: CheckboxListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 6),
        visualDensity: VisualDensity.compact,
        controlAffinity: ListTileControlAffinity.leading,
        value: cartItem.isChecked,
        onChanged: (value) {
          cartProvider.toggleItemChecked(product);
        },
        title: ListTile(
          leading: Image.network(
            product.image,
            height: screenSize.height * 0.3,
            width: screenSize.width * 0.2,
            fit: BoxFit.fitHeight,
          ),
          title: Text(
            product.name,
            style: GoogleFonts.openSans(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            NumberFormat.currency(
              locale: 'id_ID',
              symbol: 'Rp',
              decimalDigits: 0,
            ).format(product.price),
          ),
          trailing: Container(
            height: screenSize.height * 0.06,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(quantity == 1 ? Icons.delete : Icons.remove),
                  onPressed: () => quantity == 1
                      ? cartProvider.removeFromCart(product)
                      : cartProvider.decreaseQuantity(product),
                ),
                Text(
                  '$quantity',
                  style: const TextStyle(fontSize: 16),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => cartProvider.increaseQuantity(product),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
