// lib/pages/verifikasi_identitas_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:terraserve_app/pages/form_identitas_page.dart'; // Import halaman baru

class VerifikasiIdentitasPage extends StatelessWidget {
  const VerifikasiIdentitasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mari verifikasi\nidentitas Anda',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 39,
                color: Colors.black,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 36),
            Text(
              'Untuk dapat mendaftar sebagai petani, kami perlu memverifikasi identitas Anda. Informasi Anda akan dienkripsi dan disimpan dengan aman.',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.black.withOpacity(0.7),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 90),
            Center(
              child: Image.asset(
                'assets/images/icon_ktp.png',
                height: 150,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Aksi navigasi ke halaman formulir
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FormIdentitasPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF389841),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  'Mulai',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
