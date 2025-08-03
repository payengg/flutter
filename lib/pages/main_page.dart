// lib/pages/main_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:terraserve_app/pages/models/user.dart';
import 'package:terraserve_app/pages/akun_page.dart';
import 'package:terraserve_app/pages/dashboard_pages.dart';
import 'package:terraserve_app/pages/favorit_page.dart';
import 'package:terraserve_app/pages/pesan_page.dart';
import 'package:terraserve_app/pages/services/navigation_service.dart';
import 'package:terraserve_app/providers/farmer_application_provider.dart';

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

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    // Lakukan ini di initState: ambil user id dan simpan ke provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final farmerProvider =
          Provider.of<FarmerApplicationProvider>(context, listen: false);
      farmerProvider.setUserId(widget.user.id);
    });

    _pages = [
      DashboardPages(user: widget.user, controller: _scrollController),
      PesanPage(controller: _scrollController),
      const Center(child: Text("Halaman Pesanan")),
      FavoritPage(controller: _scrollController),
      AkunPage(
          user: widget.user,
          token: widget.token,
          controller: _scrollController),
    ];

    _scrollController.addListener(_onScroll);
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

  void _onItemTapped(int index) {
    Provider.of<NavigationService>(context, listen: false).setIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationService>(
      builder: (context, navService, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              _pages[navService.selectedIndex],
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                bottom: _isNavVisible ? 0 : -100,
                left: 0,
                right: 0,
                child: _buildFloatingNavigationBar(navService.selectedIndex),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFloatingNavigationBar(int selectedIndex) {
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
            _buildNavItem(
                icon: Icons.home,
                label: 'Beranda',
                index: 0,
                selectedIndex: selectedIndex),
            _buildNavItem(
                icon: Icons.chat_bubble_outline,
                label: 'Pesan',
                index: 1,
                selectedIndex: selectedIndex),
            _buildNavItem(
                icon: Icons.shopping_basket_outlined,
                label: 'Pesanan',
                index: 2,
                selectedIndex: selectedIndex),
            _buildNavItem(
                icon: Icons.favorite_border,
                label: 'Favorit',
                index: 3,
                selectedIndex: selectedIndex),
            _buildNavItem(
                icon: Icons.person_outline,
                label: 'Akun',
                index: 4,
                selectedIndex: selectedIndex),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required int selectedIndex,
  }) {
    final bool isSelected = selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    isSelected ? const Color(0xFF859F3D) : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey[600],
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
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
