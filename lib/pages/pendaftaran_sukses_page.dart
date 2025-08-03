// lib/pages/pendaftaran_sukses_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:terraserve_app/pages/services/navigation_service.dart';

class PendaftaranSuksesPage extends StatelessWidget {
  const PendaftaranSuksesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset(
                'assets/images/suksespetani.png',
                height: 250,
              ),
              const SizedBox(height: 32),
              Text(
                'Tunggu dulu, ya! Kamu belum langsung terdaftar sebagai Petani di TerraServe.',
                'Tunggu dulu, ya! Kamu belum langsung terdaftar sebagai Petani di TerraServe.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Dokumenmu sedang kami verifikasi dan proses ini bisa memakan waktu hingga 1x24 jam.',
                'Dokumenmu sedang kami verifikasi dan proses ini bisa memakan waktu hingga 1x24 jam.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Setelah terverifikasi, kamu bisa mulai jualan hasil panen langsung ke konsumen!',
               Text(
                'Setelah terverifikasi, kamu bisa mulai jualan hasil panen langsung ke konsumen!',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF859F3D),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    'Selesai',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
