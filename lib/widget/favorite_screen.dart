import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myapp/module/favorite_provider.dart';
import 'package:myapp/module/favorite_service.dart';
import 'package:myapp/module/item_favorite.dart';
import 'package:provider/provider.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Favorit'),
        centerTitle: true,
        ),
      body: FutureBuilder(
        future: _auth.authStateChanges().first,
        builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (userSnapshot.hasError || !userSnapshot.hasData) {
          return const Center(child: Text('Error fetching user.'));
        }

        final User? user = userSnapshot.data;

        if (user != null) {
          _itemFavoritStream ??= _favoriteService.getFavoritesStream(user.uid);
       
        return StreamBuilder<List<ItemFavorit>>(
          stream: _favoriteService.getFavoritesStream(_auth.currentUser!.uid),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              if (kDebugMode) {
                print('Stream error: ${snapshot.error}');
              }
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
                snapshot.data!;
        
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
                  await favoriteProvider.toggleFavorite(
                        _auth.currentUser!.uid,
                        item.id,
                        item.toMap(), // Mengirim data produk ke toggleFavorite
                      );
                },
              ),
            ],
          ),
        ),
            );
          },
        );
        
          },
        );} else {
          return const Center(child: Text('User not authenticated.'));
        }
      },
      ),
    );
  }
}
