import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'; // Import ini diperlukan untuk ScrollDirection
import 'package:google_fonts/google_fonts.dart';
import 'package:terraserve_app/pages/Dashboard_Pages.dart';

class MainPage extends StatefulWidget {
  final Map<String, dynamic> user;

  const MainPage({super.key, required this.user});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  bool _isNavVisible = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Cek arah scroll
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_isNavVisible) {
        setState(() {
          _isNavVisible = false;
        });
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_isNavVisible) {
        setState(() {
          _isNavVisible = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // Daftar halaman yang akan ditampilkan
  late final List<Widget> _pages = [
    DashboardPages(user: widget.user, controller: _scrollController),
    const Center(child: Text("Halaman Pesan")),
    const Center(child: Text("Halaman Pesanan")),
    const Center(child: Text("Halaman Favorit")),
    const Center(child: Text("Halaman Akun")),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _pages[_selectedIndex],
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: _isNavVisible ? 0 : -100,
            left: 0,
            right: 0,
            child: _buildFloatingNavigationBar(),
          ),
        ],
      ),
    );
  }

  // ✅ WIDGET NAVBAR TELAH DIPERBARUI TOTAL
  Widget _buildFloatingNavigationBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(icon: Icons.home, label: 'Beranda', index: 0),
            _buildNavItem(icon: Icons.chat_bubble_outline, label: 'Pesan', index: 1),
            _buildNavItem(icon: Icons.shopping_basket_outlined, label: 'Pesanan', index: 2),
            _buildNavItem(icon: Icons.favorite_border, label: 'Favorit', index: 3),
            _buildNavItem(icon: Icons.person_outline, label: 'Akun', index: 4),
          ],
        ),
      ),
    );
  }

  // ✅ WIDGET BARU UNTUK SETIAP ITEM NAVIGASI
  Widget _buildNavItem({required IconData icon, required String label, required int index}) {
    final bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Lingkaran hijau di belakang ikon (hanya muncul jika terpilih)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF859F3D) : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey[600],
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            // Teks label
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                color: isSelected ? Colors.black : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
