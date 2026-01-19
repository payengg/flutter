import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_pages.dart'; // Navigasi akhir ke LoginPages

class IntroPages2 extends StatelessWidget {
  const IntroPages2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Bagian atas: konten teks & tombol
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 80, 24, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo_terraserve.png',
                    width: 45,
                    height: 47.31,
                  ),
                  const SizedBox(height: 32),
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
                  Text(
                    'Belanja sayur, buah, dan bahan segar kini lebih mudah dan terpercaya.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // --- TOMBOL BELANJA SEKARANG DIPERKECIL ---
                  SizedBox(
                    // Width dan height diatur lebih kecil dari sebelumnya
                    width: 250,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        // Selesai Intro -> Masuk Login
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPages(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF389841),
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
                  // -----------------------------------------
                ],
              ),
            ),
          ),

          // Bagian bawah: gambar
          Expanded(
            flex: 4,
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
                      // Indikator Halaman 3 (Rectangle di kanan)
                      Image.asset('assets/images/Ellipse 1.png', height: 8),
                      const SizedBox(width: 6),
                      Image.asset('assets/images/Ellipse 2.png', height: 8),
                      const SizedBox(width: 6),
                      Image.asset(
                        'assets/images/Rectangle 3.png',
                        height: 8,
                        width: 27,
                        // Opsional: Jika indikator aktif juga mau diubah warnanya
                        // color: const Color(0xFF389841),
                      ),
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
