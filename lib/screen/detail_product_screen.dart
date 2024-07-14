import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myapp/module/cart_provider.dart';
import 'package:myapp/module/favorite_provider.dart';
import 'package:myapp/module/products.dart';
import 'package:provider/provider.dart';

class DetailProductScreen extends StatefulWidget {
  const DetailProductScreen({super.key});

  @override
  State<DetailProductScreen> createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  late DocumentSnapshot productSnapshot;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isFavorit = false;
// Inisialisasi FavoriteService
  int _quantity = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    productSnapshot =
        ModalRoute.of(context)!.settings.arguments as DocumentSnapshot;
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
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
              favoriteProvider.isFavorite(productSnapshot.id)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: favoriteProvider.isFavorite(productSnapshot.id)
                  ? Colors.red
                  : null,
            ),
            onPressed: () async {
              final userId = _auth.currentUser!.uid;
              await favoriteProvider.toggleFavorite(userId, productSnapshot.id,
                  productSnapshot.data() as Map<String, dynamic>);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Text(
                            productSnapshot['name'],
                            style: GoogleFonts.inter(
                                color: const Color(0xff3D5920),
                                fontSize: screenSize.width * 0.07,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -3 / 100),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                      height: screenSize.width * 0.6,
                      width: screenSize.width * 0.6,
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
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
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
                              SizedBox(
                                height: 20,
                                child: Text(
                                  'Description',
                                  style: GoogleFonts.inter(
                                      color: const Color(0xff0B3128),
                                      fontSize: screenSize.width * 0.05,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: -3 / 100),
                                ),
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
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Expanded(
                            child: Column(
                              children: [
                                Row(
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
                                          text: NumberFormat.currency(
                                            locale: 'id_ID',
                                            symbol: 'Rp',
                                            decimalDigits: 0,
                                          ).format(productSnapshot['price']),
                                          style: GoogleFonts.josefinSans(
                                              color: const Color(0xff0B3128),
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: -2 / 100),
                                        ),
                                      ]),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: screenSize.width * 0.2),
                                      child: Row(
                                        children: _iconStar,
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      16, screenSize.height * 0.08, 16, 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            if (_quantity > 1) _quantity--;
                                          });
                                        },
                                        icon: const Icon(Icons.remove),
                                      ),
                                      Text(_quantity.toString()),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _quantity++;
                                          });
                                        },
                                        icon: const Icon(Icons.add),
                                      ),
                                    ],
                                  ),
                                ),
                                 _buttonCart(context, screenSize),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

       
    );
  }

  ElevatedButton _buttonCart(BuildContext context, Size screenSize) {
    return ElevatedButton(
        onPressed: () async {
          ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              side: const BorderSide(color: Colors.black, width: 1),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              padding: const EdgeInsets.all(8.0));
          final cartProvider =
              Provider.of<CartProvider>(context, listen: false);
          await cartProvider.addToCart(
            Product.fromFirestore(
                productSnapshot as DocumentSnapshot<Map<String, dynamic>>),
            quantity: _quantity,
          );
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Berhasil'),
                content:
                    const Text('Produk berhasil ditambahkan ke keranjang.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Tutup dialog
                    },
                    child: const Text('OK'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Tutup dialog
                      Navigator.pushNamed(
                          context, '/cart'); // Navigasi ke CartScreen
                    },
                    child: const Text('Lihat Keranjang'),
                  ),
                ],
              ),
            );
          }
        },
        child: SizedBox(
          width: screenSize.width * 0.7,
          height: screenSize.height * 0.07,
          child: Center(
            child: Text(
              'Add to cart',
              style: GoogleFonts.josefinSans(
                  color: Colors.white,
                  fontSize: screenSize.width * 0.05,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1),
            ),
          ),
        ));
  }

  List<Widget> get _iconStar {
    return [
      Icon(Icons.star, color: Colors.yellow[800]),
      Icon(Icons.star, color: Colors.yellow[800]),
      Icon(Icons.star, color: Colors.yellow[800]),
      Icon(Icons.star, color: Colors.yellow[800]),
      Icon(Icons.star, color: Colors.grey[400]),
    ];
  }
}
