// lib/pages/reviews_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Penilaian & Ulasan',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- HEADER RATING SUMMARY ---
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA), // Background abu sangat muda
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // Kolom Bintang Progress Bar
                Expanded(
                  child: Column(
                    children: [
                      _buildRatingBar(5, 0.8),
                      _buildRatingBar(4, 0.6),
                      _buildRatingBar(3, 0.3),
                      _buildRatingBar(2, 0.1),
                      _buildRatingBar(1, 0.05),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                // Kolom Angka Besar
                Column(
                  children: [
                    Text(
                      '4.0',
                      style: GoogleFonts.poppins(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                          5,
                          (index) => Icon(
                                Icons.star,
                                color:
                                    index < 4 ? Colors.amber : Colors.grey[300],
                                size: 16,
                              )),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '52 Reviews',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // --- DAFTAR ULASAN ---
          _buildReviewItem(
            name: 'Dexter Zionxy',
            date: '10 Agustus 2025',
            rating: 5,
            comment:
                'Baru pertama kali pakai Terraserve dan langsung terkesan! Banyak pilihan produk, dan bayam segarnya benar-benar top! 👍🏻',
            imageAsset:
                'assets/images/user_avatar.png', // Ganti dengan aset avatar user
            productImage: 'assets/images/bayam.png', // Ganti dengan aset produk
          ),
          _buildReviewItem(
            name: 'Rinie Williamson',
            date: '02 Mei 2025',
            rating: 4,
            comment:
                'Sayurannya segar dan pengirimannya cepat, hanya saja kemasannya sedikit rusak. Semoga ke depan lebih rapi.',
            imageAsset: 'assets/images/user_avatar_2.png',
          ),
          _buildReviewItem(
            name: 'Jane Cooper',
            date: '03 Desember 2025',
            rating: 4,
            comment:
                'Bayamnya sangat segar, pemesanan mudah, kurir ramah, Pasti order lagi..',
            imageAsset: 'assets/images/user_avatar_3.png',
            productImage: 'assets/images/bayam.png',
            secondProductImage: 'assets/images/bayam_merah.png',
          ),
          _buildReviewItem(
            name: 'Lauren Ariana',
            date: '22 Maret 2025',
            rating: 4,
            comment:
                'Kesegaran bayamnya juara, pesanan diproses cepat, dan pengantaran aman. Recommended banget!',
            imageAsset: 'assets/images/user_avatar_4.png',
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int star, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text('$star',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600, fontSize: 12)),
          const SizedBox(width: 4),
          const Icon(Icons.star, color: Colors.amber, size: 12),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: value,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                minHeight: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem({
    required String name,
    required String date,
    required int rating,
    required String comment,
    required String imageAsset,
    String? productImage,
    String? secondProductImage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(
                  imageAsset), // Pastikan aset ada atau ganti NetworkImage
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Row(
                    children: [
                      Row(
                        children: List.generate(
                            5,
                            (index) => Icon(
                                  Icons.star,
                                  color: index < rating
                                      ? Colors.amber
                                      : Colors.grey[300],
                                  size: 14,
                                )),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        date,
                        style: GoogleFonts.poppins(
                            color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.more_vert, color: Colors.black54),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          comment,
          style: GoogleFonts.poppins(
              color: Colors.grey[700], fontSize: 13, height: 1.5),
        ),
        if (productImage != null) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              _buildReviewImage(productImage),
              if (secondProductImage != null) ...[
                const SizedBox(width: 8),
                _buildReviewImage(secondProductImage),
              ],
            ],
          ),
        ],
        const SizedBox(height: 16),
        const Divider(color: Color(0xFFEEEEEE), thickness: 1),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildReviewImage(String imagePath) {
    return Container(
      width: 60,
      height: 60,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) => const Icon(Icons.image_not_supported,
              size: 30, color: Colors.grey),
        ),
      ),
    );
  }
}
