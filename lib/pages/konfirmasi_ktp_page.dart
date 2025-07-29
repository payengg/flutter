// lib/pages/konfirmasi_ktp_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:terraserve_app/pages/kamera_ktp_page.dart';

class KonfirmasiKtpPage extends StatelessWidget {
  final String imagePath;
  const KonfirmasiKtpPage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final imageFile = File(imagePath);

    return Scaffold(
      appBar: AppBar(
        title: Text('Foto KTP', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          // Mengarahkan kembali ke halaman form, bukan kamera
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Harap konfirmasi bahwa info KTP sudah benar dan dilanjutkan',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700])),
            const SizedBox(height: 32),
            
            // --- PERUBAHAN DI SINI UNTUK MENGATASI OVERFLOW ---
            // 1. Bungkus dengan Expanded agar area ini fleksibel
            Expanded(
              child: Center( // 2. Gunakan Center agar container tidak melebar penuh
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.file(imageFile),
                  ),
                ),
              ),
            ),
            // --- AKHIR PERUBAHAN ---

            // Spacer tidak lagi diperlukan, ganti dengan SizedBox untuk jarak
            const SizedBox(height: 24),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Kembali ke halaman kamera untuk mengambil ulang
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const KameraKtpPage()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.grey[400]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text('Coba Lagi', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Kirim hasil (file gambar) kembali ke halaman form
                      Navigator.pop(context, imageFile);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF859F3D),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text('Selesai', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
