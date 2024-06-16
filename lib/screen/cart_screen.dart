import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/module/cart_provider.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.sizeOf(context);
    final cartProvider = context.watch<CartProvider>();
    final cartItems = cartProvider.cartItems;

    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang Belanja')),
      body: Stack(
        children: [
          cartItems.isEmpty
              ? const Center(child: Text('Keranjang Kosong'))
              : ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartItems[index];
                    final product = cartItem.product;
                    final quantity = cartItem.quantity;

                    return Card(
                        margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                        elevation: 3,
                        child: CheckboxListTile(
                          value: cartItem.isChecked,
                          onChanged: (value) {
                            cartProvider.toggleItemChecked(product);
                          },
                          title: ListTile(
                            leading: Image.network(
                              product.image,
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(
                              product.name,
                              style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle:
                                Text('Rp. ${product.price.toStringAsFixed(0)}'),
                            trailing: Container(
                              height: screenSize.height * 0.06,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Suggested code may be subject to a license. Learn more: ~LicenseLog:609242505.

                                  IconButton(
                                    icon: Icon(quantity == 1
                                        ? Icons.delete
                                        : Icons.remove),
                                    onPressed: () => quantity == 1
                                        ? cartProvider.removeFromCart(product)
                                        : cartProvider
                                            .decreaseQuantity(product),
                                  ),

                                  Text(
                                    '$quantity',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () =>
                                        cartProvider.increaseQuantity(product),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ));
                  },
                ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
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
                        Text('Total:',
                            style: GoogleFonts.openSans(
                                fontSize: 18, fontWeight: FontWeight.w400)),
                        Text(
                          'Rp. ${cartProvider.totalPrice(cartItems).toStringAsFixed(0)}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff8A49F7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                    onPressed: () {
                      final checkedItems = cartProvider.checkedItems;
                      if (checkedItems.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Pilih item yang ingin di-checkout')),
                        );
                      } else {
                        Navigator.pushNamed(context, '/checkout',
                            arguments: checkedItems);
                      }
                    },
                    child: Text(
                      'Checkout',
                      style: GoogleFonts.openSans(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
