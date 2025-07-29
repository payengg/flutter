// lib/pages/akun_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:terraserve_app/pages/models/user.dart';
import 'package:terraserve_app/pages/edit_profile_page.dart';
import 'package:terraserve_app/pages/login_pages.dart';

class AkunPage extends StatefulWidget {
  final ScrollController? controller;
  final User user;

  const AkunPage({super.key, this.controller, required this.user});

  @override
  State<AkunPage> createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
  late String _userName;
  late String _userEmail;
  late String _userPhone = '';

  @override
  void initState() {
    super.initState();
    _userName = widget.user.name ?? 'Guest';
    _userEmail = widget.user.email ?? 'guest@example.com';
    _userPhone = widget.user.phone ?? '';
  }

  void _navigateToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          currentName: _userName,
          currentEmail: _userEmail,
          currentPhone: _userPhone ?? '',
        ),
      ),
    );

    if (result != null && result is Map<String, String>) {
      setState(() {
        _userName = result['name']!;
        _userEmail = result['email']!;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profil berhasil diperbarui!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
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
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
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
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[100],
        automaticallyImplyLeading: false,
        title: Text(
          'Akun',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: widget.controller,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileCard(context),
            const SizedBox(height: 24),
            _buildSettingsCard(),
            const SizedBox(height: 24),
            Text(
              'More',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            _buildMoreCard(context),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return InkWell(
      onTap: _navigateToEditProfile,
      borderRadius: BorderRadius.circular(7),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF859F3D),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=47'),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _userName,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    _userEmail,
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.edit,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        children: [
          _buildListTile(
              icon: Icons.refresh,
              title: 'Pesanan Ulang',
              subtitle: 'Lihat dan kelola pesanan sebelumnya'),
          _buildListTile(
              icon: Icons.inventory_2_outlined,
              title: 'Pengembalian',
              subtitle: 'Atur dan pantau proses pengembalian barang'),
          _buildNotificationTile(),
          _buildListTile(
              icon: Icons.language,
              title: 'Bahasa',
              subtitle: 'Pilih bahasa yang ingin digunakan'),
          _buildListTile(
              icon: Icons.person_outline,
              title: 'Daftar menjadi Petani',
              subtitle: 'Bergabung untuk mulai menjual hasil pertanian'),
        ],
      ),
    );
  }

  Widget _buildMoreCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        children: [
          _buildListTile(
              icon: Icons.help_outline, title: 'Pusat Bantuan', subtitle: null),
          _buildListTile(
              icon: Icons.info_outline, title: 'Tentang App', subtitle: null),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text(
              'Log out',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
            subtitle: Text(
              'Further secure your account for safety',
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            onTap: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF859F3D)),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          color: textColor ?? Colors.black87,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            )
          : null,
      trailing: subtitle != null
          ? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey)
          : null,
      onTap: () {},
    );
  }

  Widget _buildNotificationTile() {
    return SwitchListTile(
      secondary: const Icon(Icons.notifications_outlined,
          color: const Color(0xFF859F3D)),
      title: Text(
        'Pemberitahuan',
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        'Kelola notifikasi dari aplikasi',
        style: GoogleFonts.poppins(
          color: Colors.grey[600],
          fontSize: 12,
        ),
      ),
      value: true,
      onChanged: (bool value) {},
      activeColor: const Color(0xFF859F3D),
    );
  }
}
