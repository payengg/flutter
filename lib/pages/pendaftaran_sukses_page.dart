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
            children: [
              const Spacer(),
              Image.asset('assets/images/suksespetani.png', height: 250),
              const SizedBox(height: 32),
              Text(
                'Pendaftaran Berhasil!',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Akun petani Anda sedang ditinjau. Kami akan memberitahu Anda jika sudah disetujui.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final navService =
                        Provider.of<NavigationService>(context, listen: false);

                    // ✅ === PERBAIKAN UTAMA ADA DI SINI === ✅
                    //
                    // Kita paksa listener di MainPage untuk berjalan dengan cara beralih ke
                    // index sementara (0) lalu langsung kembali ke index tujuan (4).
                    // Ini memastikan fungsi _onTabChange di MainPage terpanggil dan
                    // navbar yang mungkin tersembunyi karena scroll, akan muncul lagi.
                    //
                    navService.setIndex(
                        0); // 1. Beralih SEMENTARA untuk memicu perubahan.
                    navService.setIndex(
                        4); // 2. Langsung set ke tujuan AKHIR (Akun Page).

                    // 3. Tutup semua halaman pendaftaran dan kembali ke MainPage.
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF389841),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3,
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
