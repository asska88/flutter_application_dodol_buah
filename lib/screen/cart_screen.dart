import 'package:flutter/material.dart';
import 'package:myapp/module/cart_provider.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final cartItems = cartProvider.cartItems;

    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang Belanja')),
      body: cartItems.isEmpty
          ? const Center(child: Text('Keranjang Kosong'))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = cartItems[index];
                final product = cartItem.product;
                final quantity = cartItem.quantity; 

                return ListTile(
                  title: Text(product.name),
                  subtitle: Text('Rp. ${product.price.toStringAsFixed(2)}'), 
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => cartProvider.decreaseQuantity(product),
                      ),
                      Text('$quantity'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => cartProvider.increaseQuantity(product),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
