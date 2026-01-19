// lib/pages/toko_saya_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'upload_product_page.dart';
import 'pesanan_petani_page.dart';

class TokoSayaPage extends StatelessWidget {
  const TokoSayaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. HEADER SECTION (Banner + AppBar + Profile)
            SizedBox(
              height: 280, // Tinggi area header
              child: Stack(
                children: [
                  // A. BACKGROUND IMAGE (Banner Toko)
                  Container(
                    height: 220,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      image: DecorationImage(
                        image: AssetImage('assets/images/bannertoko.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // B. KONTEN DI ATAS BANNER
                  Column(
                    children: [
                      // Custom AppBar
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 50, 16, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios,
                                  color: Colors.white, size: 20),
                              onPressed: () => Navigator.pop(context),
                            ),
                            Text(
                              'Toko Saya',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Icon(Icons.refresh, color: Colors.white),
                          ],
                        ),
                      ),

                      // Profile Card
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 28,
                                  backgroundImage: NetworkImage(
                                      'https://i.pravatar.cc/150?u=yanti'),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Petani Yanti',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        'terraserve.id/petaniyanti',
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xFF389841)),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Lihat Toko',
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFF389841),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Divider(height: 1, color: Color(0xFFEEEEEE)),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.notifications_active_outlined,
                                    color: Color(0xFF859F3D), size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Pemberitahuan Penjualan',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 2. BODY CONTENT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // A. Pemberitahuan Penjual (Naik -20)
                  _buildSellerNotificationCards(),

                  // ✅ UPDATE DISINI: Mengubah offset dari -35 menjadi -55
                  // Ini akan menarik seluruh konten di bawah ini LEBIH NAIK lagi ke atas
                  Transform.translate(
                    offset: const Offset(0, -55),
                    child: Column(
                      children: [
                        // B. Statistik Grid
                        _buildStatisticsGrid(),
                        // kecilkan jarak agar box "Status Pesanan" lebih dekat
                        const SizedBox(height: 5),

                        // C. Status Pesanan
                        _buildOrderStatusSection(context),
                        const SizedBox(height: 20),

                        // D. Akses Cepat
                        _buildQuickAccessButton(context),
                        const SizedBox(height: 20),

                        // E. Statistika Bisnis
                        _buildBusinessStatistics(),
                        const SizedBox(height: 20),

                        // F. List Menu
                        _buildListItem('Penjualan Produk Terbaik',
                            'Bayam Hijau & Bayam Merah'),
                        _buildListItem('Konsumen baru', '12 minggu ini'),
                        _buildListItem('Total Transaksi', '132 Bulan ini'),
                        const SizedBox(height: 20),

                        // G. Banner Bawah
                        _buildBottomBanner(
                          icon: Icons.campaign,
                          title: 'Iklan Terraserve',
                          subtitle:
                              'Tingkatkan penjualan produkmu dengan iklan yang tepat sasaran.',
                          buttonText: 'Coba Sekarang',
                          color: const Color(0xFFF1F8E9),
                          iconColor: const Color(0xFF389841),
                        ),
                        const SizedBox(height: 16),
                        _buildBottomBanner(
                          icon: Icons.computer,
                          title: 'Pelatihan Kelas Video Petani',
                          subtitle:
                              'Mulai dari penggunaan aplikasi hingga teknik bertani modern.',
                          buttonText: 'Mulai',
                          color: const Color(0xFFF1F8E9),
                          iconColor: const Color(0xFF389841),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildSellerNotificationCards() {
    // Ditarik ke atas -20 pixel biar nempel Header
    return Transform.translate(
      offset: const Offset(0, -20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pemberitahuan Penjual',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildGreenCard(
                    'Kelas Online',
                    'Belajar Jualan\nOnline via Video',
                    'assets/images/box1.png'),
                const SizedBox(width: 10),
                _buildGreenCard('Komunitas', 'Temukan koneksi\nTerraserve',
                    'assets/images/box2.png'),
                const SizedBox(width: 10),
                _buildGreenCard('Informasi', 'Lihat informasi\nterkini',
                    'assets/images/box3.png'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGreenCard(String title, String subtitle, String assetImage) {
    // Per-bagian ukuran: icon lebih besar untuk box1 & box2, daunn agak diperkecil
    final double iconSize =
        (assetImage.contains('box1.png') || assetImage.contains('box2.png'))
            ? 96
            : 66;
    const double leafWidth = 130; // agak diperkecil dari 150
    return Expanded(
      child: Container(
        height: 175,
        decoration: BoxDecoration(
          // Gradasi Atas ke Bawah
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF389841), // Hijau Tua
              Color(0xFFAEE636), // Hijau Lime
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // 1. GAMBAR DAUN (lebih besar dan ditampilkan DI ATAS ikon)

              // 2. KONTEN (Icon & Teks) - TENGAH
              Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Area icon dengan tinggi tetap supaya posisi teks sejajar
                      SizedBox(
                        height: 64,
                        child: Center(
                          child: Image.asset(
                            assetImage,
                            width: iconSize,
                            height: iconSize,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Judul
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 4),

                      // Subtitle
                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.95),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              // Daun overlay yang lebih besar, ditempatkan setelah konten agar muncul DI ATAS ikon
              Align(
                alignment: const Alignment(0, -0.28),
                child: Opacity(
                  opacity: 0.45,
                  child: Image.asset(
                    'assets/images/daunn.png',
                    width: leafWidth,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.6,
      children: [
        _buildStatCard(Icons.shopping_cart_outlined, 'Jumlah Pesanan', '1,204'),
        _buildStatCard(Icons.inventory_2_outlined, 'Total Produk', '29'),
        _buildStatCard(Icons.people_outline, 'Total Konsumen', '350'),
        _buildStatCard(
            Icons.monetization_on_outlined, 'Pendapatan', 'Rp 25,9 Juta'),
      ],
    );
  }

  Widget _buildStatCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 5),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF4B6028), size: 24),
          const SizedBox(height: 8),
          Text(title,
              style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildOrderStatusSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 5),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Status Pesanan',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PesananPetaniPage())),
                child: Text('Lihat Pesanan >',
                    style:
                        GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatusItem('10', 'Dikemas'),
              _buildStatusItem('79', 'Terkirim'),
              _buildStatusItem('30', 'Dibatalkan'),
              _buildStatusItem('0', 'Pengembalian'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(String count, String label) {
    return Column(
      children: [
        Container(
          height: 50,
          width: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFF4F8E6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: Text(count,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: const Color(0xFF4B6028))),
        ),
        const SizedBox(height: 8),
        Text(label,
            style:
                GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildQuickAccessButton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Akses Cepat',
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UploadProductPage()),
              ),
              borderRadius: BorderRadius.circular(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_circle,
                      color: Color(0xFF389841), size: 28),
                  const SizedBox(width: 8),
                  Text(
                    'Tambah Produk',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBusinessStatistics() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Statistika Bisnis',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text('7 Hari Terakhir',
                      style: GoogleFonts.poppins(fontSize: 12)),
                  const Icon(Icons.keyboard_arrow_down,
                      size: 16, color: Colors.grey),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildBar('Senin', 60, const Color(0xFFDAE998)),
            _buildBar('Selasa', 40, const Color(0xFFDAE998)),
            _buildBar('Rabu', 70, const Color(0xFFDAE998)),
            _buildBar('Kamis', 50, const Color(0xFFDAE998)),
            _buildBar('Jumat', 100, const Color(0xFF389841)),
            _buildBar('Sabtu', 60, const Color(0xFFDAE998)),
            _buildBar('Minggu', 80, const Color(0xFFDAE998)),
          ],
        ),
      ],
    );
  }

  Widget _buildBar(String label, double height, Color color) {
    return Column(
      children: [
        Container(
          width: 25,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 10, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildListItem(String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 5),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 4),
              Text(subtitle,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildBottomBanner({
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonText,
    required Color color,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: iconColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: GoogleFonts.poppins(
                        fontSize: 11, color: Colors.black87)),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: iconColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                      minimumSize: const Size(0, 32),
                    ),
                    child: Text(buttonText,
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: Colors.white)),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
