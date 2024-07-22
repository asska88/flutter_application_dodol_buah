import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ListProduct extends StatefulWidget {
  const ListProduct({
    super.key,
  });

  @override
  State<ListProduct> createState() => _ListProductState();
}

class _ListProductState extends State<ListProduct> {
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('products');

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.sizeOf(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    'Popular Products',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.dmSans(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: SizedBox(
              height: screenSize.height * 0.6,
              child: StreamBuilder(
                  stream: _products.snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    if (streamSnapshot.hasData) {
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Jumlah kolom
                          crossAxisSpacing: 8, // Jarak horizontal antar card
                          mainAxisSpacing: 8, // Jarak vertikal antar card
                        ),
                        itemCount: streamSnapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          final DocumentSnapshot documentSnapshot =
                              streamSnapshot.data!.docs[index];
                          final docID = documentSnapshot.id;
                          return InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/detail',
                                arguments: streamSnapshot.data!.docs[index],
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Card(
                                key: ValueKey(docID),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    
                                    const SizedBox(height: 8),
                                    Text(documentSnapshot['name'],
                                        style: GoogleFonts.dmSans(
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                        NumberFormat.currency(
                                          locale: 'id_ID',
                                          symbol: 'Rp',
                                          decimalDigits: 0,
                                        ).format(documentSnapshot['price']),
                                        style: GoogleFonts.dmSans(
                                            fontWeight: FontWeight.w400)),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(child: Text('tidak ada product'));
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
