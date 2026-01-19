import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LihatUlasanPage extends StatelessWidget {
  final String productName;
  final String imageUrl;
  final String orderId;

  const LihatUlasanPage({
    super.key,
    required this.productName,
    required this.imageUrl,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text('Ulasan Pembeli',
            style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- INFO PRODUK ---
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFEEEEEE)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade200,
                      image: DecorationImage(
                        image: _getImageProvider(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(productName,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700, fontSize: 14)),
                        Text('ID: $orderId',
                            style: GoogleFonts.poppins(
                                color: Colors.grey[500], fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- RATING & ULASAN ---
            Row(
              children: [
                const Icon(Icons.star_rounded, color: Colors.amber, size: 32),
                const SizedBox(width: 8),
                Text('5.0',
                    style: GoogleFonts.poppins(
                        fontSize: 24, fontWeight: FontWeight.w700)),
                const SizedBox(width: 8),
                Text('/ 5.0',
                    style: GoogleFonts.poppins(
                        fontSize: 14, color: Colors.grey[400])),
              ],
            ),
            const SizedBox(height: 8),
            Text('Sangat Memuaskan',
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black)),
            const SizedBox(height: 24),
            const Divider(thickness: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 24),

            // --- USER REVIEW CARD ---
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFFE8F5E9),
                  child: Text('ND',
                      style: TextStyle(
                          color: Color(0xFF2E6A31),
                          fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nabila Defany',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600, fontSize: 14)),
                    Text('15 Agustus 2025',
                        style: GoogleFonts.poppins(
                            color: Colors.grey[500], fontSize: 12)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Sayurnya seger banget, warnanya masih bagus pas sampe. Pengiriman juga cepet dan aman. Makasih pak tani, bakal langganan terus disini!',
              style: GoogleFonts.poppins(
                  color: Colors.black87, fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 16),
            // Foto Ulasan (Simulasi)
            Row(
              children: [
                _buildPhotoReview(imageUrl),
                const SizedBox(width: 8),
                _buildPhotoReview(imageUrl),
              ],
            ),
            const SizedBox(height: 32),

            // --- BALASAN PETANI (OPTIONAL) ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F9EB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Balasan Anda:',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2E6A31),
                          fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(
                      'Alhamdulillah, terima kasih kak Nabila atas ulasannya! Ditunggu pesanan selanjutnya ya.',
                      style: GoogleFonts.poppins(
                          color: const Color(0xFF2E6A31), fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoReview(String url) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade100,
        image: DecorationImage(
          image: _getImageProvider(url),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  ImageProvider _getImageProvider(String url) {
    if (url.startsWith('http')) {
      return NetworkImage(url);
    }
    return AssetImage(url);
  }
}
