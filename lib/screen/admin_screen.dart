import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart';
import 'package:myapp/screen/order_detail_screen.dart';
import 'package:readmore/readmore.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  final CollectionReference _products =
      FirebaseFirestore.instance.collection('products');
  final CollectionReference _orders =
      FirebaseFirestore.instance.collection('orders');

  XFile? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  Future<String?> _uploadImageToFirebase(String productId) async {
    if (_imageFile == null) return null;

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('product_images/$productId.jpg');
      final uploadTask = await ref.putFile(File(_imageFile!.path));
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image: $e');
      }
      return null;
    }
  }

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _nameController.text = documentSnapshot['name'];
      _priceController.text = documentSnapshot['price'].toString();
      _descriptionController.text = documentSnapshot['description'];
      _stockController.text = documentSnapshot['stock'].toString();
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                // prevent the soft keyboard from covering text fields
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _stockController,
                  decoration: const InputDecoration(labelText: 'Stock'),
                ),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Pilih Gambar'),
                ),

                // Preview gambar jika ada
                if (_imageFile != null)
                  Image.file(
                    File(_imageFile!.path),
                    height: 100,
                  ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text(action == 'create' ? 'Create' : 'Update'),
                  onPressed: () async {
                    final String name = _nameController.text;
                    final String description = _descriptionController.text;
                    final int? stock = int.tryParse(_stockController.text);
                    if (name.isEmpty) {
                      return;
                    }
                    final NumberFormat numberFormat = NumberFormat(
                        '#,##0.00', 'id_ID'); // Format untuk Indonesia
                    final double? price =
                        numberFormat.parse(_priceController.text) as double?;
                    if (price == null || price <= 0) {
                      // Tampilkan snackbar atau pesan error lainnya
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Harga harus berupa angka positif.')),
                      );
                      return;
                    }
                    String? imageUrl;
                    if (_imageFile != null) {
                      imageUrl = await _uploadImageToFirebase(
                          documentSnapshot?.id ??
                              DateTime.now().toIso8601String());
                    }
                    if (action == 'create') {
                      await _products.add({
                        "name": name,
                        "price": price,
                        "description": description,
                        "stock": stock,
                        "image": imageUrl,
                      });
                    } else if (action == 'update') {
                      await _products.doc(documentSnapshot?.id).update({
                        "name": name,
                        "price": price,
                        "description": description,
                        "stock": stock,
                        "image": imageUrl,
                      });
                    }

                    // Clear the text fields
                    _nameController.text = '';
                    _priceController.text = '';
                    _descriptionController.text = '';
                    _stockController.text = '';
                    setState(() {
                      _imageFile = null;
                    });

                    // Hide the bottom sheet
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        });
  }

  // Deleteing a product by id
  Future<void> _deleteProduct(String productId) async {
    await _products.doc(productId).delete();

    // Show a snackbar
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'DASHBOARD',
          style: GoogleFonts.openSans(
              fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              text: 'produk',
            ),
            Tab(
              text: 'pesanan',
            )
          ],
        ),
      ),
      // Using StreamBuilder to display all products from Firestore in real-time
      body: TabBarView(
        controller: _tabController,
        children: [
          _tabProduct(screenSize),
          _tabOrder(),
        ],
      ),

      // Add new product
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: () => _createOrUpdate(),
              label: const Text('Tambah Produk'),
              icon: const Icon(Icons.add),
            )
          : null,
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> _tabOrder() {
    return StreamBuilder(
      stream: _orders.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData && streamSnapshot.data!.docs.isNotEmpty) {
          return ListView.builder(
            itemCount: streamSnapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
              final orderItems = documentSnapshot['orderItems'];

              return InkWell(
                // Tambahkan InkWell untuk menangani klik
                onTap: () {
                  // Navigasi ke halaman detail pesanan
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderDetailScreen(
                          orderId: documentSnapshot
                              .id), // Sesuaikan dengan nama halaman detail Anda
                    ),
                  );
                },
                child: Card(
                  surfaceTintColor: Colors.grey,
                  shadowColor: Colors.purple,
                  elevation: 3,
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    // Gunakan ListTile biasa tanpa ExpansionTile
                    leading: Image.network(
                      orderItems['product']
                          ['image'], // Gunakan gambar item pertama
                      height: 50,
                      width: 50,
                      fit: BoxFit.contain,
                    ),
                    title: Row(
                      // Gunakan Row untuk title dan total order
                      children: [
                        Expanded(
                          child: Text(
                            orderItems['product']
                                ['name'], // Gunakan nama item pertama
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Text(
                          '${orderItems.length} item', // Jumlah item dalam pesanan
                          style: GoogleFonts.jetBrainsMono(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '#${documentSnapshot.id}', // Nomor pesanan
                          style: GoogleFonts.jetBrainsMono(),
                        ),
                        Text(
                          DateFormat('dd MMM yyyy HH:mm').format(
                            (documentSnapshot['orderDate'] as Timestamp)
                                .toDate(),
                          ), // Tanggal pesanan
                          style: GoogleFonts.jetBrainsMono(),
                        ),
                      ],
                    ),
                    trailing: Checkbox(
                      value: documentSnapshot['isDone'] ??
                          false, // Tandai pesanan selesai
                      onChanged: (value) {
                        _orders
                            .doc(documentSnapshot.id)
                            .update({'isDone': value});
                      },
                    ),
                  ),
                ),
              );
            },
          );
        } else if (streamSnapshot.hasError) {
          // Tampilkan pesan error
        } else {
          return const Center(
            child: Text("Belum ada pesanan"),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> _tabProduct(Size screenSize) {
    return StreamBuilder(
      stream: _products.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          return ListView.builder(
            itemCount: streamSnapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
              final docID = documentSnapshot.id;
              final description = documentSnapshot.get('description');
              final stock = documentSnapshot.get('stock');
              return Card(
                surfaceTintColor: Colors.grey,
                shadowColor: Colors.purple,
                elevation: 3,
                key: ValueKey(docID),
                margin: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (documentSnapshot['image'] != null)
                      Image.network(
                        documentSnapshot['image'],
                        height: screenSize.height * 0.2,
                        width: screenSize.width * 0.2,
                        fit: BoxFit.contain,
                      ),
                    Expanded(
                      // Expand to take available space
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              documentSnapshot['name'],
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              "Harga: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(documentSnapshot['price'])}",
                              style: GoogleFonts.jetBrainsMono(
                                  fontWeight: FontWeight.bold),
                            ),
                            if (stock != null) Text("Stok: $stock"),
                            // Description below the image and details
                            if (description != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: ReadMoreText(
                                  "Deskripsi: $description",
                                  trimLines: 2,
                                  colorClickableText: Colors.pink,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: 'Show more',
                                  trimExpandedText: 'Show less',
                                  moreStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  lessStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        // Wrap buttons in a Column for vertical alignment
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blueGrey,
                            ),
                            onPressed: () => _createOrUpdate(documentSnapshot),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.blueGrey),
                            onPressed: () =>
                                _deleteProduct(documentSnapshot.id),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
