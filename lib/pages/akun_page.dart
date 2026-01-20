// lib/pages/akun_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:terraserve_app/pages/models/user.dart';
import 'package:terraserve_app/pages/edit_profile_page.dart';
import 'package:terraserve_app/pages/login_pages.dart';
import 'package:terraserve_app/pages/daftar_petani_page.dart';
import 'package:terraserve_app/pages/services/api_service.dart';
import 'package:terraserve_app/pages/toko_saya_page.dart';
<<<<<<< HEAD
=======
// ✅ Import Halaman Favorit
import 'package:terraserve_app/pages/favorit_page.dart';
>>>>>>> 27f823c514beaffddb5177255c7eeab7585d42e7

class AkunPage extends StatefulWidget {
  final ScrollController? controller;
  final User user;
  final String token;

  const AkunPage({
    super.key,
    this.controller,
    required this.user,
    required this.token,
  });

  @override
  State<AkunPage> createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
  late User _currentUser;
  bool _isLoading = false;
  bool _isNotificationEnabled = false;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
    _refreshUserData();
  }

  Future<void> _refreshUserData() async {
    if (mounted) setState(() => _isLoading = true);

    try {
      User? updatedUser = await ApiService.fetchUser(widget.token);
      if (updatedUser != null && mounted) {
        setState(() {
          _currentUser = updatedUser;
        });
      }
    } catch (e) {
      print("Gagal refresh user: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _navigateToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          token: widget.token,
          currentName: _currentUser.name ?? '',
          currentEmail: _currentUser.email ?? '',
          currentPhone: _currentUser.phone ?? '',
          currentAddress: _currentUser.address ?? '',
        ),
      ),
    );

    if (result != null) {
      _refreshUserData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil berhasil diperbarui!'),
            backgroundColor: Color(0xFF389841),
          ),
        );
      }
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Konfirmasi Keluar',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Apakah Anda yakin ingin keluar?',
            style: GoogleFonts.poppins(),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Batal',
                style: GoogleFonts.poppins(color: Colors.grey[700]),
              ),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text(
                'Keluar',
                style: GoogleFonts.poppins(
                    color: Colors.red, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPages()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isPetani = _currentUser.role?.toLowerCase() == 'petani';

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF9F9F9),
        automaticallyImplyLeading: false,
        title: Text(
          'Akun',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Center(
                child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Color(0xFF389841))),
              ),
            )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshUserData,
        color: const Color(0xFF389841),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: widget.controller,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(isPetani),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    // ✅ NAVIGASI FAVORIT DIPERBAIKI DI SINI
                    _buildMenuItem(
                      icon: Icons.favorite_border,
                      title: 'Favorit',
                      subtitle: 'Lihat Produk Favorit',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FavoritPage()),
                        );
                      },
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.assignment_return_outlined,
                      title: 'Pengembalian',
                      subtitle: 'Atur dan pantau proses pengembalian barang',
                      onTap: () {},
                    ),
                    _buildDivider(),
                    _buildNotificationSwitchItem(),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.g_translate,
                      title: 'Bahasa',
                      subtitle: 'Pilih bahasa yang ingin digunakan',
                      onTap: () {},
                    ),
                    _buildDivider(),

                    if (isPetani)
                      _buildMenuItem(
                        icon: Icons.store_mall_directory,
                        title: 'Toko Saya',
                        subtitle: 'Kelola produk dan pesanan toko anda',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TokoSayaPage(),
                            ),
                          );
                        },
                      )
                    else
                      _buildMenuItem(
                        icon: Icons.person_outline,
                        title: 'Daftar menjadi Petani',
                        subtitle:
                            'Bergabung untuk mulai menjual hasil pertanian',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DaftarPetaniPage(),
                            ),
                          ).then((_) {
                            _refreshUserData();
                          });
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Lainnya',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    _buildMenuItem(
                      icon: Icons.notifications_none,
                      title: 'Pusat Bantuan',
                      onTap: () {},
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.help_outline,
                      title: 'Tentang App',
                      onTap: () {},
                    ),
                    _buildDivider(),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.logout,
                            color: Colors.red, size: 22),
                      ),
                      title: Text(
                        'Log out',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.red,
                        ),
                      ),
                      onTap: () => _showLogoutDialog(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(bool isPetani) {
    return InkWell(
      onTap: _navigateToEditProfile,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF389841), // Warna Hijau Utama
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const CircleAvatar(
                radius: 32,
                backgroundImage: AssetImage('assets/images/user_avatar.png'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currentUser.name ?? 'Guest',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '@${(_currentUser.name ?? 'guest').toLowerCase().replaceAll(' ', '')}',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                  if (isPetani)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        "Penjual Terverifikasi",
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontSize: 10),
                      ),
                    )
                ],
              ),
            ),
            const Icon(Icons.edit, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Color(0xFFF0F4E8),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: const Color(0xFF389841), size: 22),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: Colors.black87,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: GoogleFonts.poppins(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            )
          : null,
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildNotificationSwitchItem() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Color(0xFFF0F4E8),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.notifications_none,
            color: Color(0xFF389841), size: 22),
      ),
      title: Text(
        'Pemberitahuan',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        'Kelola notifikasi dari aplikasi',
        style: GoogleFonts.poppins(
          color: Colors.grey[500],
          fontSize: 12,
        ),
      ),
      trailing: Switch(
        value: _isNotificationEnabled,
        onChanged: (val) {
          setState(() {
            _isNotificationEnabled = val;
          });
        },
        activeColor: Colors.white,
        activeTrackColor: const Color(0xFF389841),
        inactiveThumbColor: Colors.grey[400],
        inactiveTrackColor: Colors.grey[200],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFFF5F5F5),
      indent: 70,
    );
  }
}
