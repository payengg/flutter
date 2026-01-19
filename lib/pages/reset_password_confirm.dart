import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:terraserve_app/pages/login_pages.dart'; // Pastikan path ini benar

class ResetPasswordConfirmPage extends StatelessWidget {
  const ResetPasswordConfirmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // Tombol close di kiri atas
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            // Arahkan ke halaman login jika tombol close ditekan
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginPages()),
              (route) => false,
            );
          },
        ),
        // Judul "TerraServe" di tengah
        title: Text(
          'TerraServe',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Pusatkan konten secara vertikal
            crossAxisAlignment: CrossAxisAlignment.stretch, // Lebarkan konten
            children: [
              const Spacer(flex: 2), // Beri ruang di atas

              // Gambar konfirmasi
              Image.asset(
                'assets/images/confirmation_gambar.png', // PASTIKAN PATH GAMBAR INI BENAR
                height: 200,
              ),
              const SizedBox(height: 48),

              // Teks "Konfirmasi"
              Text(
                'Konfirmasi',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              // Teks deskripsi
              Text(
                'Kata sandi Anda telah diubah. Silakan masuk dengan kata sandi baru Anda.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),

              const Spacer(flex: 3), // Beri ruang lebih banyak sebelum tombol

              // Tombol Login
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Arahkan ke halaman login dan hapus semua halaman sebelumnya
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const LoginPages()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    // --- UBAH WARNA TOMBOL DISINI ---
                    backgroundColor: const Color(0xFF389841),
                    // --------------------------------
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40), // Ruang di bawah tombol
            ],
          ),
        ),
      ),
    );
  }
}
