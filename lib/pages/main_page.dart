import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:terraserve_app/pages/Dashboard_Pages.dart'; // Pastikan import ini benar

class MainPage extends StatefulWidget {
  // ✅ 1. Deklarasikan variabel 'user' sebagai properti kelas
  final Map<String, dynamic> user;

  // ✅ 2. Gunakan 'this.user' di constructor
  const MainPage({super.key, required this.user});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Variabel untuk melacak tab mana yang sedang aktif
  int _selectedIndex = 0;

  // ✅ 3. Gunakan 'late final' agar bisa mengakses 'widget.user'
  late final List<Widget> _pages;

  // ✅ 4. Inisialisasi daftar halaman di dalam initState
  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      // Gunakan widget.user untuk meneruskan data ke DashboardPage
      DashboardPages(user: widget.user),
      const Center(child: Text('Halaman Pesan')),
      const Center(child: Text('Halaman Pesanan')),
      const Center(child: Text('Halaman Favorit')),
      const Center(child: Text('Halaman Akun')),
    ];
  }

  // Fungsi yang dipanggil saat tab ditekan
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: _pages[_selectedIndex],
      bottomNavigationBar: _buildFloatingNavigationBar(),
    );
  }

  Widget _buildFloatingNavigationBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 19),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(0xFF859F3D),
            unselectedItemColor: Colors.grey[500],
            selectedLabelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: GoogleFonts.poppins(),
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                activeIcon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF859F3D),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.home, color: Colors.white),
                ),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.chat_bubble_outline),
                activeIcon: const Icon(Icons.chat_bubble),
                label: 'Pesan',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.shopping_basket_outlined),
                activeIcon: const Icon(Icons.shopping_basket),
                label: 'Pesanan',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.favorite_border),
                activeIcon: const Icon(Icons.favorite),
                label: 'Favorit',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_outline),
                activeIcon: const Icon(Icons.person),
                label: 'Akun',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
