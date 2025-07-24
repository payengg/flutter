import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:terraserve_app/pages/login_pages.dart'; // ✅ Import halaman login

class IntroPages2 extends StatelessWidget {
  const IntroPages2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // --- BAGIAN ATAS: KONTEN (LOGO, TEKS, TOMBOL) ---
          Expanded(
            flex: 5, // Memberi ruang lebih untuk konten teks
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 80, 24, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/logo_terraserve.png',
                    width: 45,
                    height: 47.31,
                  ),
                  const SizedBox(height: 32),

                  // Judul
                  Text(
                    'Hasil Panen Segar, Langsung dari Petani ke Rumah Anda',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Subjudul
                  Text(
                    'Belanja sayur, buah, dan bahan segar kini lebih mudah dan terpercaya.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Tombol Belanja Sekarang
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPages()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF859F3D),
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
                ],
              ),
            ),
          ),

          // --- BAGIAN BAWAH: GAMBAR SAYUR ---
          Expanded(
            flex: 4, // Proporsi untuk gambar
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/intro_pages2.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/Ellipse 1.png', height: 8),
                      const SizedBox(width: 6),
                      Image.asset('assets/images/Ellipse 2.png', height: 8),
                      const SizedBox(width: 6),
                      Image.asset('assets/images/Rectangle 3.png', height: 8, width: 27),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
