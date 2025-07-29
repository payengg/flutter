// lib/pages/daftar_petani_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// ⬇️ 1. TAMBAHKAN IMPORT INI
import 'package:terraserve_app/pages/verifikasi_identitas_page.dart';

class DaftarPetaniPage extends StatelessWidget {
  const DaftarPetaniPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PROGRAM SUKSES PETANI CERDAS',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16, // Ukuran font disesuaikan agar konsisten
                      color: const Color(0xFF859F3D),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureCard(
                    imageAsset: 'assets/images/icon_lapak.png',
                    title: 'Gratis Buka Lapak',
                    description:
                        'Buka lapak Pertanianmu dan mulai jual hasil panen langsung ke konsumen',
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureCard(
                    imageAsset: 'assets/images/icon_usaha.png',
                    title: 'Dukungan Usaha Petani Baru',
                    description:
                        'Dapatkan dukungan berupa subsidi ongkir atau pelatihan digital.',
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureCard(
                    imageAsset: 'assets/images/icon_distribusi.png',
                    title: 'Distribusi Wilayah Lampung',
                    description:
                        'Jangkau pembeli dari berbagai daerah di Provinsi Lampung tanpa repot urus logistik.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // ⬇️ 2. BERIKAN 'context' DI SINI
      bottomNavigationBar: _buildBottomButton(context),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      expandedHeight: 250,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/farmer_banner.png',
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Padding(
              // Padding atas disesuaikan agar tidak terlalu jauh
              padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // MainAxisAlignment diubah agar teks tidak menempel di atas
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Mulai Jual Hasil\nPertanianmu Sekarang!',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24, // Ukuran font disesuaikan
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Nikmati Keuntungan\nProgram Kemitraan Petani Baru',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required String imageAsset,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            imageAsset,
            width: 32,
            height: 32,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ⬇️ 3. TERIMA 'context' DI SINI
  Widget _buildBottomButton(BuildContext context) {
    return Padding(
      // Padding bawah disesuaikan agar tombol tidak terlalu menempel ke bawah
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const VerifikasiIdentitasPage()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF859F3D),
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
        ),
        child: Text(
          'Daftar sebagai Petani',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}