import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/module/cart_provider.dart';
import 'package:myapp/module/products.dart';
import 'package:myapp/screen/cart_screen.dart';
import 'package:provider/provider.dart';

class DetailProductScreen extends StatefulWidget {
  const DetailProductScreen({super.key});

  @override
  State<DetailProductScreen> createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  late DocumentSnapshot productSnapshot;
  bool isFavorit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    productSnapshot =
        ModalRoute.of(context)!.settings.arguments as DocumentSnapshot;
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: const Color(0xffF5DCAD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: const Text('Detail Product'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isFavorit ? Icons.favorite : Icons.favorite_border,
              color: isFavorit ? Colors.red : null,
            ),
            onPressed: () {
              setState(() {
                isFavorit = !isFavorit;
              });
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      productSnapshot['name'],
                      style: GoogleFonts.inter(
                          color: const Color(0xff3D5920),
                          fontSize: screenSize.width * 0.07,
                          fontWeight: FontWeight.w400,
                          letterSpacing: -3 / 100),
                    ),
                  ),
                ],
              ),
              SizedBox(
                  height: screenSize.height * 0.4,
                  width: screenSize.height * 0.4,
                  child: Image.network(
                    productSnapshot['image'],
                    fit: BoxFit.contain,
                  )),
              const SizedBox(
                height: 5,
              ),
              Container(
                width: screenSize.width,
                height: screenSize.height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Description',
                            style: GoogleFonts.inter(
                                color: const Color(0xff0B3128),
                                fontSize: screenSize.width * 0.05,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -3 / 100),
                          ),
                          Text(
                            productSnapshot['description'],
                            style: GoogleFonts.inter(
                                color: Colors.black87,
                                fontSize: screenSize.width * 0.03,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -3 / 100),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Row(
                        children: [
                          RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: 'Price ',
                                style: GoogleFonts.josefinSans(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: -2 / 100),
                              ),
                              TextSpan(
                                text:
                                    '\nRp. ${productSnapshot['price'].toStringAsFixed(2)}',
                                style: GoogleFonts.josefinSans(
                                    color: const Color(0xff0B3128),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -2 / 100),
                              ),
                            ]),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: screenSize.width * 0.3),
                            child: Row(
                              children: [
                                Icon(Icons.star, color: Colors.yellow[800]),
                                Icon(Icons.star, color: Colors.yellow[800]),
                                Icon(Icons.star, color: Colors.yellow[800]),
                                Icon(Icons.star, color: Colors.yellow[800]),
                                Icon(Icons.star, color: Colors.grey[400]),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Column(
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    side: const BorderSide(
                                        color: Colors.black, width: 1),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero,
                                    ),
                                    padding: const EdgeInsets.all(8.0));
                                Provider.of<CartProvider>(context,
                                        listen: false)
                                    .addToCart(Product.fromFirestore(productSnapshot));
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CartScreen(), // Assuming your CartScreen widget is defined
                                  ),
                                );
                              },
                              child: Text(
                                'Add to cart',
                                style: GoogleFonts.josefinSans(
                                    color: Colors.black,
                                    fontSize: screenSize.width * 0.04,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: -2 / 100),
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
