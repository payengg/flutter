import 'package:flutter/material.dart';
// Pastikan import ini mengarah ke file startup_pages.dart yang benar
import 'startup_pages.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // 1. Animasi untuk Logo "Tuing" (Scale dari 0 ke 1 dengan efek membal)
  late Animation<double> _logoTuingAnimation;
  // 2. Animasi untuk Lingkaran Background membesar
  late Animation<double> _bgScaleAnimation;
  // 3. Animasi perubahan warna Logo
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      // Total durasi animasi 2.5 detik
      duration: const Duration(milliseconds: 2500),
    );

    // --- KONFIGURASI ANIMASI BARU (TUING) ---
    // Logo muncul dari ukuran 0.0 ke 1.0 menggunakan elasticOut biar "tuing"
    // Berjalan di awal (0% - 40% durasi)
    _logoTuingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.elasticOut),
      ),
    );

    // Lingkaran hijau membesar (mulai sedikit setelah logo muncul)
    // Berjalan dari 30% - 80% durasi
    _bgScaleAnimation = Tween<double>(begin: 0.0, end: 35.0).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.3, 0.8, curve: Curves.easeInOutExpo)),
    );

    // Warna berubah dari Hijau ke Putih saat lingkaran membesar
    // Berjalan dari 35% - 60% durasi
    _colorAnimation =
        ColorTween(begin: const Color(0xFF4CAF50), end: Colors.white).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.35, 0.6, curve: Curves.easeIn)),
    );

    // Jalankan animasi
    _controller.forward();

    // Listener: Pindah halaman setelah animasi selesai
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Navigasi ke StartupPage (Halaman pertama setelah splash)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const StartupPage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // SizedBox.expand memaksa konten mengisi seluruh layar
      body: SizedBox.expand(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              // PENTING: Ini yang membuat semua anak di dalamnya ditengah persis
              alignment: Alignment.center,
              children: [
                // LAYER 1: Lingkaran Hijau Background
                Transform.scale(
                  scale: _bgScaleAnimation.value,
                  child: Container(
                    width: 50, // Ukuran awal kecil di tengah
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4CAF50), // Warna Hijau TerraServe
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                // LAYER 2: Gambar Logo (Dengan efek "Tuing")
                // Kita gunakan Transform.scale, bukan translate lagi
                Transform.scale(
                  scale:
                      _logoTuingAnimation.value, // Menggunakan animasi elastic
                  child: Image.asset(
                    'assets/images/logo_splash.png', // Pastikan path benar
                    width: 200, // Sesuaikan ukuran logo jika perlu

                    // Logic perubahan warna (Hijau -> Putih)
                    color: _colorAnimation.value,
                    colorBlendMode: BlendMode.srcIn,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
