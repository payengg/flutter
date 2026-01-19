import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'intro_pages2.dart'; // Navigasi lanjut ke IntroPages2

class IntroPages extends StatefulWidget {
  const IntroPages({super.key});

  @override
  State<IntroPages> createState() => _IntroPagesState();
}

class _IntroPagesState extends State<IntroPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            // Lanjut ke IntroPages2 (Indikator 3)
            MaterialPageRoute(
              builder: (context) => const IntroPages2(),
            ),
          );
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Bagian Bawah: Gambar Ilustrasi Orang
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/images/intro_pages.png',
                height: MediaQuery.of(context).size.height * 0.6,
                fit: BoxFit.contain,
              ),
            ),

            // Bagian Atas: Background Hijau (Vector) & Teks
            Align(
              alignment: Alignment.topCenter,
              child: Stack(
                children: [
                  // --- BAGIAN YANG DIUBAH ---
                  Image.asset(
                    'assets/images/vector_intro.png',
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: double.infinity,
                    fit: BoxFit.fill,
                    // Kita timpa warna asli gambar dengan warna baru (389841)
                    color: const Color(0xFF389841),
                    colorBlendMode: BlendMode.srcIn,
                  ),
                  // --------------------------

                  Padding(
                    padding: const EdgeInsets.only(
                      top: 60,
                      left: 24,
                      right: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Pesanan Anda, Langsung dari Tangan Petani',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Kami antar hasil panen segar ke rumah Anda dengan aman dan cepat.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bagian Indikator Halaman (Titik-titik bawah)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Indikator Halaman 2 (Rectangle di tengah)
                  Image.asset(
                    'assets/images/Ellipse 1.png',
                    height: 8,
                  ),
                  const SizedBox(width: 6),
                  Image.asset(
                    'assets/images/aaa.png',
                    height: 8,
                    width: 27,
                    // Opsional: Jika indikator aktif juga mau diubah warnanya
                    // color: const Color(0xFF389841),
                  ),
                  const SizedBox(width: 6),
                  Image.asset(
                    'assets/images/Ellipse 2.png',
                    height: 8,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
