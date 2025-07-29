// lib/pages/instruksi_ktp_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:terraserve_app/pages/kamera_ktp_page.dart'; // Halaman selanjutnya

class InstruksiKtpPage extends StatelessWidget {
  const InstruksiKtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0, 
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pindahkan foto Identitas Anda ke dalam bingkai yang ditampilkan di layar',
                    style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Text('Hal ini memungkinkan kami memastikan tidak ada yang mencuri dokumen Anda',
                    style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600])),
                const SizedBox(height: 85),
                // --- PERUBAHAN DI SINI ---
                // Mengganti Icon dengan Image.asset
                Center(
                  child: Image.asset(
                    'assets/images/pindai_ktp.png',
                    height: 300, // Anda bisa sesuaikan ukurannya
                  ),
                ),
                // --- AKHIR PERUBAHAN ---
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Ganti halaman ini dengan halaman kamera
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const KameraKtpPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF859F3D),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: Text('Mulai', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
