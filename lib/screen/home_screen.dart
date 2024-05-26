import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const Center(
      child: Text('Home Screen'),
    ),
    const Center(
      child: Text('Search Screen'),
    ),
    const Center(
      child: Text('Cart Screen'),
    ),
    const Center(
      child: Text('Profile Screen'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(left: screenSize.width * 0.05),
          child: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: [
          for (int i = 0; i < _pages.length; i++) // Loop untuk membuat item
            BottomNavigationBarItem(
              icon: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: _selectedIndex == i
                              ? const Color(0xffA95EFA)
                              :  Colors.transparent,
                          width: 5.0,
                        
                      ),
                    ),
                    child: Icon(
                      [
                        Icons.home,
                        Icons.search,
                        Icons.shopping_cart,
                        Icons.person
                      ][i],
                      color: _selectedIndex == i ? const Color(0xffA95EFA) : Colors.black, // Daftar ikon sesuai indeks
                    ),
                  ),
                ],
              ),
              label: [
                'Home',
                'Search',
                'Cart',
                'Profile'
              ][i], // Daftar label sesuai indeks
            ),
        ],
      ),
    );
  }
}
