import 'package:flutter/material.dart';
import 'package:myapp/module/cart_provider.dart';
import 'package:myapp/module/products.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartItems = context.watch<CartProvider>().cartItems;
    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang Belanja')),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final Product products = cartItems[index];
          return ListTile(
            title: Text(cartItems[index].name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (products.quantity > 1) { // Access quantity from the product, not the list
                      Provider.of<CartProvider>(context, listen: false)
                          .updateQuantity(products, products.quantity - 1);
                    }
                  },
                ),
                Text('${cartItems[index].quantity}'),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Provider.of<CartProvider>(context, listen: false)
                        .updateQuantity(products, products.quantity + 1);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}