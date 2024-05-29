import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/auth/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  User? _user;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Armchair',
      'imageAsset': 'assets/images/armchair.png',
      'stok': '100+ Product'
    },
    {
      'name': 'Sofa Red',
      'imageAsset': 'assets/images/sofa_red.png',
      'stok': '15+ Product'
    },
    {
      'name': 'Sofa Grey',
      'imageAsset': 'assets/images/sofa_green.png',
      'stok': '10+ Product'
    },
  ];
  final List<Map<String, dynamic>> products = [
    {
      'name': 'Wood Frame',
      'imageAsset': 'assets/images/wood_frame.png',
      'price': 'Rp. 2.600.000'
    },
    {
      'name': 'Yellow Armchair',
      'imageAsset': 'assets/images/yellow_armchair.png',
      'price': 'Rp. 1.600.000'
    },
    {
      'name': 'Sofa Grey',
      'imageAsset': 'assets/images/sofa_green.png',
      'price': 'Rp. 1.600.000'
    },
  ];
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _authService.fetchUserData();

    _pages = [
      SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Browse by Categories',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.dmSans(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      // Tambahkan aksi yang diinginkan saat kategori di-tap
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              categories[index]['imageAsset'],
                              height: 150,
                              width: 200,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              categories[index]['name'],
                              style: GoogleFonts.dmSans(
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(categories[index]['stok']),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Recommended for You',
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
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                products[index]['imageAsset'],
                                height: 120,
                                width: 200,
                              ),
                              const SizedBox(height: 8),
                              Text(products[index]['name'],
                                  style: GoogleFonts.dmSans(
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(products[index]['price']),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      const Center(
        child: Text('Search Screen'),
      ),
      const Center(
        child: Text('Cart Screen'),
      ),
      StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              final user = snapshot.data;
              return user!= null ?
              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData && snapshot.data!.exists) {
                    final userData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(_user?.photoURL ?? ''),
                          ),
                          const SizedBox(height: 16),
                          Text(
                              'Nama: ${userData['displayName'] ?? user.displayName ?? ''}'), 
                          const SizedBox(height: 8),
                          Text('Email: ${user.email}'),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _signOut,
                            child: const Text('Sign Out'),
                          ),
                        ]));
                  } else {
                    return const Center(child: Text('Anda belum login.'));
                  }
                },
              ): const Center();
            } else {
              return const Text('Anda belum login.');
            }
          })
    ];
  }

  Future<void> fetchUserData() async {
    if (_user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .get();
      if (userDoc.exists) {
        setState(() {});
      }
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      _user = null;
    });
    if (mounted) {
      Navigator.pushReplacementNamed(
          context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          SizedBox(
            width: 20,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.qr_code_scanner),
            ),
          ),
          SizedBox(
            width: 80,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.menu),
            ),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: SingleChildScrollView(
        child: BottomNavigationBar(
          iconSize: 24,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: const Color(0xffA95EFA),
          unselectedItemColor: Colors.black,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: [
            for (int i = 0; i < _pages.length; i++)
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(
                      5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _selectedIndex == i
                          ? const Color(0xffA95EFA)
                          : Colors.transparent,
                      width: 2.0,
                    ),
                  ),
                  child: Icon(
                    [
                      Icons.home,
                      Icons.search,
                      Icons.shopping_cart,
                      Icons.person
                    ][i],
                    size: 24,
                    color: _selectedIndex == i ? Colors.blueGrey : Colors.black,
                  ),
                ),
                label: ['Home', 'Search', 'Cart', 'Profile'][i],
              ),
          ],
        ),
      ),
    );
  }
}
