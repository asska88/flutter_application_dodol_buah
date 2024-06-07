import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CobaFirestore extends StatefulWidget {
  const CobaFirestore({super.key});

  @override
  State<CobaFirestore> createState() => _CobaFirestoreState();
}

class _CobaFirestoreState extends State<CobaFirestore> {
  // text fields' controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController =
      TextEditingController(); 
  final TextEditingController _stockController =
      TextEditingController(); 

  final CollectionReference _products =
      FirebaseFirestore.instance.collection('products');
  // This function is triggered when the floatting button or one of the edit buttons is pressed
  // Adding a product if no documentSnapshot is passed
  // If documentSnapshot != null then update an existing product
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
                  controller: _descriptionController,
                  maxLines: 3, // Allow multiple lines for description
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _stockController,
                  decoration: const InputDecoration(labelText: 'Stock'),
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
                    final double? price =
                        double.tryParse(_priceController.text);
                    if (price != null) {
                      if (action == 'create') {
                        // Persist a new product to Firestore
                        // await _uploadImageToFirebase(documentSnapshot!.id);
                        await _products.add({"name": name, "price": price, "description": description, "stock": stock});
                      }

                      if (action == 'update') {
                        // Update the product
                        // await _uploadImageToFirebase(documentSnapshot!.id);
                        await _products
                            .doc(documentSnapshot?.id)
                            .update({"name": name, "price": price, "description": description, "stock": stock});
                      }

                      // Clear the text fields
                      _nameController.text = '';
                      _priceController.text = '';
                      _descriptionController.text = '';
                      _stockController.text = '';

                      // Hide the bottom sheet
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    }
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kindacode.com'),
      ),
      // Using StreamBuilder to display all products from Firestore in real-time
      body: StreamBuilder(
        stream: _products.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                    final docID = documentSnapshot.id;
                     // Periksa apakah field 'image_url' ada
            // Periksa apakah field 'description' ada
            final description = documentSnapshot.get('description');
            // Periksa apakah field 'stock' ada
            final stock = documentSnapshot.get('stock');
                return Card(
                  key: ValueKey(docID),
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(documentSnapshot['name']),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Harga: Rp ${documentSnapshot['price'].toStringAsFixed(2)}"), // Format harga dalam Rupiah
                          if (description != null) // Tampilkan deskripsi hanya jika ada
                            Text("Deskripsi: $description"),
                          if (stock != null) // Tampilkan stok hanya jika ada
                            Text("Stok: $stock"),
                            ],
                          ),
                        ),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              // Press this button to edit a single product
                              IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () =>
                                      _createOrUpdate(documentSnapshot)),
                              // This icon button is used to delete a single product
                              IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () =>
                                      _deleteProduct(documentSnapshot.id)),
                            ],
                          ),
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
      ),
      // Add new product
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdate(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
