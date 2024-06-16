import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myapp/module/favorite_service.dart';
import 'package:myapp/module/item_favorite.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({
    super.key,
  });

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final FavoriteService _favoriteService = FavoriteService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<List<ItemFavorit>>? _itemFavoritStream;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((User? user) async {
      if (user != null) {
        // Periksa apakah subkoleksi favorit sudah ada
        if (!(await _favoriteService.isFavoriteCollectionExists(user.uid))) {
          // Jika belum ada, buat subkoleksi favorit
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('favorit')
              .doc()
              .set({});
        }

        _itemFavoritStream = _favoriteService.getFavoritesStream(user.uid);
      } else {
        _itemFavoritStream = null;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorit')),
      body: StreamBuilder<List<ItemFavorit>>(
        stream: _itemFavoritStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Terjadi kesalahan: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          //Jika snapshot tidak ada data, berikan widget yang sesuai
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada item favorit.'));
          }

          final itemFavorit =
              snapshot.data!; // Aman digunakan karena sudah dicek

          return ListView.builder(
  itemCount: itemFavorit.length,
  itemBuilder: (context, index) {
    final item = itemFavorit[index];
    return Card(
      elevation: 2, // Memberikan efek elevasi pada kartu
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              item.image,
              width: 80, 
              height: 80,
              fit: BoxFit.cover, // Sesuaikan dengan kebutuhan
            ),
            const SizedBox(width: 16), // Jarak antara gambar dan teks
            Expanded( // Mengisi sisa ruang horizontal agar teks tidak terpotong
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('Rp. ${item.price.toStringAsFixed(2)}'),
                  Text('Stok: ${item.stok}'),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                try {
                  await _favoriteService.removeFavorite(_auth.currentUser!.uid, item.id);
                  setState(() {}); // Update the UI after deletion
                } catch (e) {
                  if (kDebugMode) {
                    print('Error deleting favorite: $e');
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  },
);

        },
      ),
    );
  }
}
