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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: SizedBox(
          height: 85,
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey[500],
            selectedLabelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            unselectedLabelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
            ),
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                label: 'Beranda',
                icon: Image.asset(
                  'assets/images/icon_rumah.png',
                  width: 24,
                  height: 24,
                  color: Colors.grey[500],
                ),
                activeIcon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF859F3D),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/icon_rumah.png',
                    width: 24,
                    height: 24,
                    color: Colors.white,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                label: 'Pesan',
                icon: Image.asset(
                  'assets/images/icon_pesan.png',
                  width: 24,
                  height: 24,
                  color: Colors.grey[500],
                ),
                activeIcon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF859F3D),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/icon_pesan.png',
                    width: 24,
                    height: 24,
                    color: Colors.white,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                label: 'Pesanan',
                icon: Image.asset(
                  'assets/images/icon_pesanan.png',
                  width: 24,
                  height: 24,
                  color: Colors.grey[500],
                ),
                activeIcon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF859F3D),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/icon_pesanan.png',
                    width: 24,
                    height: 24,
                    color: Colors.white,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                label: 'Favorit',
                icon: Image.asset(
                  'assets/images/icon_favorit.png',
                  width: 24,
                  height: 24,
                  color: Colors.grey[500],
                ),
                activeIcon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF859F3D),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/icon_favorit.png',
                    width: 24,
                    height: 24,
                    color: Colors.white,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                label: 'Akun',
                icon: Image.asset(
                  'assets/images/icon_akun.png',
                  width: 24,
                  height: 24,
                  color: Colors.grey[500],
                ),
                activeIcon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF859F3D),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/icon_akun.png',
                    width: 24,
                    height: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
