import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Pastikan import file halaman lain sesuai struktur project Anda
import 'upload_product_page.dart';
import 'pesanan_petani_page.dart';

class TokoSayaPage extends StatelessWidget {
  const TokoSayaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding; // Untuk deteksi poni/notch
    final isSmallDevice = size.height < 650;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      // Menggunakan SingleChildScrollView agar seluruh halaman bisa discroll
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. HEADER SECTION (Responsive & Safe Area aware)
            SizedBox(
              // Tinggi header dinamis berdasarkan layar
              height: size.height * (isSmallDevice ? 0.35 : 0.40),
              child: Stack(
                children: [
                  // Background Banner
                  Container(
                    height: size.height * (isSmallDevice ? 0.28 : 0.32),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      image: DecorationImage(
                        image: AssetImage('assets/images/bannertoko.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Overlay Content
                  Column(
                    children: [
                      // Custom App Bar (Memperhitungkan Poni HP)
                      Padding(
                        padding: EdgeInsets.only(
                          top: padding.top + 10, // Jarak aman dari atas (poni)
                          left: 16,
                          right: 16,
                          bottom: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios,
                                  color: Colors.white),
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

                      // Card Profil Toko
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
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
                                    radius: 30,
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
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          'terraserve.id/petaniyanti',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
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
                              const Divider(
                                  height: 1, color: Color(0xFFEEEEEE)),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(
                                      Icons.notifications_active_outlined,
                                      color: Color(0xFF859F3D),
                                      size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Pemberitahuan Penjualan',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
                  // A. Pemberitahuan Penjual (Naik sedikit ke atas)
                  Transform.translate(
                    offset: const Offset(0, -20),
                    child: _buildSellerNotificationCards(),
                  ),

                  // Gunakan Transform lagi atau hilangkan spacing jika ingin naik
                  Transform.translate(
                    offset: const Offset(0, -20),
                    child: Column(
                      children: [
                        // B. Statistik Grid (FIXED: Menggunakan GridView)
                        _buildStatisticsGrid(),

                        const SizedBox(height: 20),

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

                        // Jarak aman paling bawah
                        SizedBox(height: padding.bottom + 40),
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
    return Container(
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
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          // Menggunakan Row dengan Expanded agar responsif
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGreenCard(
                  'Kelas Online', 'Belajar Jualan', 'assets/images/box1.png'),
              const SizedBox(width: 8),
              _buildGreenCard(
                  'Komunitas', 'Cari Koneksi', 'assets/images/box2.png'),
              const SizedBox(width: 8),
              _buildGreenCard(
                  'Informasi', 'Info Terkini', 'assets/images/box3.png'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGreenCard(String title, String subtitle, String assetImage) {
    // FIX: Menggunakan LayoutBuilder atau Flexible untuk isi card
    return Expanded(
      child: Container(
        height: 140, // Tinggi fix agar seragam
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF389841), Color(0xFFAEE636)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            // Background Daun
            Positioned(
              right: -10,
              top: -10,
              child: Opacity(
                opacity: 0.3,
                child: Image.asset('assets/images/daunn.png', width: 80),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(assetImage,
                      height: 40, width: 40, fit: BoxFit.contain),
                  const SizedBox(height: 8),
                  FittedBox(
                    child: Text(
                      title,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 10,
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

  // FIX: Grid Statistik yang stabil & anti-overpixel
  Widget _buildStatisticsGrid() {
    return GridView.count(
      crossAxisCount: 2, // 2 kolom
      shrinkWrap: true, // Agar bisa dalam scrollview
      physics: const NeverScrollableScrollPhysics(), // Scroll ikut parent
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio:
          1.5, // Rasio Lebar : Tinggi (1.5 = persegi panjang lebar)
      padding: EdgeInsets.zero,
      children: [
        _buildStatCard(Icons.shopping_cart_outlined, 'Jumlah Pesanan', '1,204'),
        _buildStatCard(Icons.inventory_2_outlined, 'Total Produk', '29'),
        _buildStatCard(Icons.people_outline, 'Total Konsumen', '350'),
        _buildStatCard(
            Icons.monetization_on_outlined, 'Pendapatan', 'Rp 25,9jt'),
      ],
    );
  }

  Widget _buildStatCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF4B6028), size: 28),
          const Spacer(),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(color: Colors.grey, fontSize: 11),
          ),
          const SizedBox(height: 4),
          // FIX: FittedBox membuat angka mengecil jika terlalu panjang
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
          ),
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
            blurRadius: 5,
          ),
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
          // FIX: Gunakan Row dengan MainAxisAlignment spaceBetween agar rapi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatusItem('10', 'Dikemas'),
              _buildStatusItem('79', 'Terkirim'),
              _buildStatusItem('30', 'Batal'), // Disingkat agar muat
              _buildStatusItem('0', 'Retur'), // Disingkat agar muat
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
          height: 45,
          width: 55, // Lebar fixed yang aman
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFF4F8E6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: FittedBox(
            // Safety untuk angka besar
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                count,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: const Color(0xFF4B6028)),
              ),
            ),
          ),
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
          height: 55,
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
                      color: Color(0xFF389841), size: 26),
                  const SizedBox(width: 8),
                  Text(
                    'Tambah Produk',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 12, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text('7 Hari', style: GoogleFonts.poppins(fontSize: 11)),
                  const Icon(Icons.keyboard_arrow_down,
                      size: 14, color: Colors.grey),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Grafik Batang Sederhana
        SizedBox(
          height: 150, // Beri tinggi pasti agar chart tidak error
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildBar('Sn', 0.4),
              _buildBar('Sl', 0.3),
              _buildBar('Rb', 0.6),
              _buildBar('Km', 0.4),
              _buildBar('Jm', 0.8, isHighlight: true),
              _buildBar('Sb', 0.5),
              _buildBar('Mg', 0.7),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBar(String label, double heightPercentage,
      {bool isHighlight = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        LayoutBuilder(builder: (ctx, constraint) {
          return Container(
            width: 20,
            height: 100 * heightPercentage, // Tinggi maksimal chart 100px
            decoration: BoxDecoration(
              color: isHighlight
                  ? const Color(0xFF389841)
                  : const Color(0xFFDAE998),
              borderRadius: BorderRadius.circular(6),
            ),
          );
        }),
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
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        GoogleFonts.poppins(color: Colors.grey, fontSize: 11)),
                const SizedBox(height: 2),
                Text(subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: GoogleFonts.poppins(
                        fontSize: 10, color: Colors.black87)),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: iconColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: Text(buttonText,
                          style: GoogleFonts.poppins(
                              fontSize: 11, color: Colors.white)),
                    ),
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
