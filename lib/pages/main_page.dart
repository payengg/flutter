// lib/pages/main_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:terraserve_app/pages/models/user.dart';
import 'package:terraserve_app/pages/akun_page.dart';
import 'package:terraserve_app/pages/dashboard_pages.dart';
import 'package:terraserve_app/pages/pesan_page.dart';
import 'package:terraserve_app/pages/services/navigation_service.dart';
import 'package:terraserve_app/providers/farmer_application_provider.dart';
import 'package:terraserve_app/pages/pesanan_page.dart';

class MainPage extends StatefulWidget {
  final User user;
  final String token;

  const MainPage({super.key, required this.user, required this.token});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _isNavVisible = true;
  final ScrollController _scrollController = ScrollController();

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    // Setup Provider Farmer
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final farmerProvider =
          Provider.of<FarmerApplicationProvider>(context, listen: false);
      farmerProvider.setUserId(widget.user.id);
    });

    // Inisialisasi Halaman
    _initPages();

    // Listener Scroll untuk Hide/Show Navbar
    _scrollController.addListener(_onScroll);
  }

  // Dipisahkan agar lebih rapi
  void _initPages() {
    _pages = [
      // Index 0: Dashboard
      DashboardPages(
        user: widget.user,
        controller: _scrollController,
      ),

      // Index 1: Pesan
      PesanPage(controller: _scrollController),

      // Index 2: Pesanan (PENTING: Di sini kita pasang logika backToDashboard)
      PesananPage(
        controller: _scrollController,
        backToDashboard: () {
          // Ketika tombol back di PesananPage ditekan,
          // panggil fungsi untuk pindah tab ke Index 0 (Beranda)
          _onItemTapped(0);
        },
      ),

      // Index 3: Akun
      AkunPage(
        user: widget.user,
        token: widget.token,
        controller: _scrollController,
      ),
    ];
  }

  void _onScroll() {
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

  // Fungsi Pindah Tab
  void _onItemTapped(int index) {
    final navService = Provider.of<NavigationService>(context, listen: false);

    if (index == navService.selectedIndex) {
      // Jika klik tab yang sama, scroll ke atas
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    } else {
      // Pindah Index via Provider
      navService.setIndex(index);
    }

    // Pastikan Navbar muncul saat pindah halaman
    if (!_isNavVisible) {
      setState(() {
        _isNavVisible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationService>(
      builder: (context, navService, child) {
        // Ambil index dari provider agar sinkron
        int currentIndex = navService.selectedIndex;

        // Safety check jika index di luar range
        if (currentIndex >= _pages.length) {
          currentIndex = 0;
        }

        return Scaffold(
          backgroundColor: Colors.white,
          // Menggunakan Stack agar Navbar melayang di atas konten
          body: Stack(
            children: [
              // Halaman Utama
              // Kita gunakan IndexedStack jika ingin state halaman tersimpan (opsional),
              // tapi _pages[currentIndex] seperti kodemu sebelumnya juga oke untuk refresh state.
              _pages[currentIndex],

              // Floating Navigation Bar
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                bottom: _isNavVisible ? 20 : -100, // Sembunyi ke bawah
                left: 20,
                right: 20,
                child: _buildFloatingNavigationBar(currentIndex),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFloatingNavigationBar(int selectedIndex) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(
            imagePath: 'assets/images/nav_home.png',
            label: 'Beranda',
            index: 0,
            selectedIndex: selectedIndex,
          ),
          _buildNavItem(
            imagePath: 'assets/images/nav_chat.png',
            label: 'Pesan',
            index: 1,
            selectedIndex: selectedIndex,
          ),
          _buildNavItem(
            imagePath: 'assets/images/nav_pesanan.png',
            label: 'Pesanan',
            index: 2,
            selectedIndex: selectedIndex,
          ),
          _buildNavItem(
            imagePath: 'assets/images/nav_profile.png',
            label: 'Profil',
            index: 3,
            selectedIndex: selectedIndex,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required String imagePath,
    required String label,
    required int index,
    required int selectedIndex,
  }) {
    final bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: isSelected
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 10)
            : const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF389841) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              imagePath,
              width: 24,
              height: 24,
              color: isSelected ? Colors.white : Colors.grey[400],
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
