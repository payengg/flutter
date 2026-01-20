import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_pages.dart';

class IntroPages2 extends StatelessWidget {
  const IntroPages2({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Tambahkan SafeArea untuk menghindari poni HP & Navigasi bawah
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  // Pastikan tinggi minimal setinggi layar (agar spacer berfungsi)
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // --- BAGIAN ATAS (Konten) ---
                      Expanded(
                        flex: 6,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: constraints.maxWidth * 0.08,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Logo
                              Image.asset(
                                'assets/images/logo_terraserve.png',
                                width: constraints.maxWidth * 0.15,
                                height: constraints.maxWidth * 0.15,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 24),

                              // Judul
                              Text(
                                'Hasil Panen Segar, Langsung dari Petani ke Rumah Anda',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  // Gunakan fitted box logic manual atau font size dinamis yang aman
                                  fontSize:
                                      constraints.maxWidth < 360 ? 18 : 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Deskripsi
                              Text(
                                'Belanja sayur, buah, dan bahan segar kini lebih mudah dan terpercaya.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize:
                                      constraints.maxWidth < 360 ? 12 : 14,
                                  color: Colors.grey[600],
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 40),

                              // --- TOMBOL (DIPERBAIKI) ---
                              // Hapus ConstrainedBox yang kaku, gunakan Container responsif
                              SizedBox(
                                width: double.infinity,
                                height: 50, // Tinggi fix yang nyaman disentuh
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPages(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF389841),
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    'Belanja Sekarang',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),

                      // --- BAGIAN BAWAH (Gambar) ---
                      // Tidak perlu Expanded berlebih yang memicu overflow
                      Expanded(
                        flex: 4,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              'assets/images/intro_pages2.png',
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                            // Indikator
                            Positioned(
                              bottom: 30,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildDot('assets/images/Ellipse 1.png'),
                                  const SizedBox(width: 8),
                                  _buildDot('assets/images/Ellipse 2.png'),
                                  const SizedBox(width: 8),
                                  Image.asset(
                                    'assets/images/Rectangle 3.png',
                                    height: 8,
                                    width: 28,
                                    fit: BoxFit.fill,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDot(String assetPath) {
    return Image.asset(
      assetPath,
      height: 8,
      width: 8,
      fit: BoxFit.contain,
    );
  }
}
