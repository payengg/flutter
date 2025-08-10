// lib/pages/toko_saya_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TokoSayaPage extends StatelessWidget {
  const TokoSayaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: const Color(0xFF859F3D),
            pinned: true,
            expandedHeight: 150.0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon:
                    const Icon(Icons.chat_bubble_outline, color: Colors.white),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Toko Saya',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              titlePadding: const EdgeInsets.only(left: 0, bottom: 16.0),
              background: Container(
                color: const Color(0xFF859F3D),
                // TODO: Ganti dengan gambar background Anda
                // child: Image.asset(
                //   'assets/images/toko_background.png',
                //   fit: BoxFit.cover,
                //   color: Colors.black.withOpacity(0.3),
                //   colorBlendMode: BlendMode.darken,
                // ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildProfileHeader(),
                  const SizedBox(height: 16),
                  _buildOrderStatus(context),
                  const SizedBox(height: 16),
                  _buildSellerNotifications(),
                  const SizedBox(height: 16),
                  _buildMenuIcons(),
                  const SizedBox(height: 16),
                  _buildRecommendations(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=seller'),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Itunuoluwa Abidoye',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'terraserve.id/Itunuoluwa.Abidoye',
                  style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildOrderStatus(BuildContext context) {
    return _buildSectionCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Status Pesanan',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              Text('Riwayat Penjualan >',
                  style: GoogleFonts.poppins(
                      color: const Color(0xFF859F3D), fontSize: 12)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatusItem(context, '0', 'Perlu Dikirim'),
              _buildStatusItem(context, '0', 'Terkirim'),
              _buildStatusItem(context, '0', 'Pembatalan'),
              _buildStatusItem(context, '0', 'Pengembalian'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(BuildContext context, String count, String label) {
    return Column(
      children: [
        Text(count,
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 4),
        Text(label,
            style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildSellerNotifications() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F0D8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Bagian Kiri
          Column(
            children: [
              const Icon(Icons.storefront, size: 32, color: Color(0xFF4B6028)),
              const SizedBox(height: 4),
              Text('TERRASERVE',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF4B6028))),
            ],
          ),
          const SizedBox(width: 16),
          // Bagian Kanan (3 item)
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 16),
              decoration: const BoxDecoration(
                  border:
                      Border(left: BorderSide(color: Colors.white, width: 2))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNotificationItem(
                      'KELASONLINE', 'Belajar jualan online setiap hari'),
                  _buildNotificationItem(
                      'Komunitas', 'Temukan koneksi terraserve lainnya'),
                  _buildNotificationItem(
                      'Informasi', 'Lihat informasi terkini'),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNotificationItem(String title, String subtitle) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    color: const Color(0xFF4B6028))),
            Text(subtitle,
                style:
                    GoogleFonts.poppins(fontSize: 10, color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuIcons() {
    return _buildSectionCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMenuItem(icon: Icons.inventory_2_outlined, label: 'Produk'),
          _buildMenuItem(
              icon: Icons.account_balance_wallet_outlined, label: 'Keuangan'),
          _buildMenuItem(
              icon: Icons.bar_chart_outlined, label: 'Performa Toko'),
          _buildMenuItem(icon: Icons.help_outline, label: 'Pusat Bantuan'),
        ],
      ),
    );
  }

  Widget _buildMenuItem({required IconData icon, required String label}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.grey[200],
          child: Icon(icon, color: const Color(0xFF859F3D)),
        ),
        const SizedBox(height: 8),
        Text(label, style: GoogleFonts.poppins(fontSize: 12)),
      ],
    );
  }

  Widget _buildRecommendations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Rekomendasi untuk anda',
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: [
            _buildRecommendationCard(Icons.campaign, 'Iklan Terraserve',
                'Tingkatkan penjualan produkmu dengan iklan.', 'Coba Sekarang'),
            _buildRecommendationCard(
                Icons.school,
                'Pelatihan Penjual Petani',
                'Ikuti kelas online seputar teknik pemasaran.',
                'Coba Sekarang'),
            _buildRecommendationCard(Icons.groups, 'Gabung Komunitas Petani',
                'Terhubung dan belajar bareng petani lain.', 'Gabung Sekarang'),
            _buildRecommendationCard(Icons.trending_up, 'Pantau Tren Pasar',
                'Lihat produk yang sedang banyak dicari.', 'Cek Sekarang'),
          ],
        )
      ],
    );
  }

  Widget _buildRecommendationCard(
      IconData icon, String title, String subtitle, String buttonText) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6FFED),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: const Color(0xFF859F3D)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 13)),
              Text(subtitle,
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: Colors.grey[700])),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF859F3D),
                padding: const EdgeInsets.symmetric(vertical: 4),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(buttonText,
                  style:
                      GoogleFonts.poppins(fontSize: 12, color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}
