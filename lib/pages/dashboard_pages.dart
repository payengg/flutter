import 'package:flutter/material.dart';
import 'package:terraserve_app/pages/login_pages.dart'; // Untuk kembali ke login

class DashboardPages extends StatelessWidget {
  // Menerima data user dari halaman login
  final Map<String, dynamic> user;

  const DashboardPages({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // Mengambil nama dari data user, beri nilai default jika tidak ada
    final String userName = user['name'] ?? 'Pengguna';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: const Color(0xFF859F3D),
        foregroundColor: Colors.white,
        actions: [
          // Tombol Logout
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // TODO: Panggil API logout di sini

              // Kembali ke halaman login
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPages()),
                (Route<dynamic> route) =>
                    false, // Hapus semua halaman sebelumnya
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Selamat Datang!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              userName, // Tampilkan nama user
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}