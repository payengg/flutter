import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LihatDetailDibatalkanPage extends StatelessWidget {
  final String orderId;
  final String productName;
  final String imageUrl;
  final double? price;

  const LihatDetailDibatalkanPage({
    super.key,
    required this.orderId,
    required this.productName,
    required this.imageUrl,
    this.price,
  });

  Widget _image(String url) {
    if (url.startsWith('http')) {
      return Image.network(url, fit: BoxFit.cover);
    }
    return Image.asset(url, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        'Detail Pesanan',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // --- ALERT BOX MERAH ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2), // Merah muda background
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Pesanan dibatalkan oleh pembeli. Proses pesanan dihentikan.',
                  style: GoogleFonts.poppins(
                      color: const Color(0xFFD32F2F), // Merah teks
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 16),

              // --- BOX 1: ID & TANGGAL ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('ID Transaksi',
                            style:
                                GoogleFonts.poppins(color: Colors.grey[600])),
                        Text(orderId,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tanggal Pesanan',
                            style:
                                GoogleFonts.poppins(color: Colors.grey[600])),
                        Text('12 Agustus 2025',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // --- BOX 2: DETAIL PRODUK ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Detail Produk',
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade100,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: _image(imageUrl),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(productName,
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w700)),
                              const SizedBox(height: 4),
                              Text('x1',
                                  style: GoogleFonts.poppins(
                                      color: Colors.grey[600])),
                            ],
                          ),
                        ),
                        Text(price != null ? 'Rp${price!.toInt()}' : '-',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // --- BOX 3: INFO PENGIRIMAN & PEMBAYARAN ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Informasi Pengiriman',
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text('Nabila Defany',
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    Text('(+62) 812-3485-6768',
                        style: GoogleFonts.poppins(
                            fontSize: 13, color: Colors.grey[600])),
                    Text('Jalan WayHalim, Bandarlampung, Lampung, 80228',
                        style: GoogleFonts.poppins(
                            fontSize: 13, color: Colors.grey[600])),
                    const SizedBox(height: 16),
                    const Divider(thickness: 1, color: Color(0xFFEEEEEE)),
                    const SizedBox(height: 16),
                    Text('Metode Pembayaran',
                        style: GoogleFonts.poppins(
                            color: Colors.grey[500], fontSize: 12)),
                    Text('BCA Virtual Account',
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // --- BOX 4: RINCIAN PEMBAYARAN ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Rincian Pembayaran',
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Subtotal Produk',
                            style:
                                GoogleFonts.poppins(color: Colors.grey[600])),
                        Text(price != null ? 'Rp${price!.toInt()}' : '-',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Ongkos Kirim',
                            style:
                                GoogleFonts.poppins(color: Colors.grey[600])),
                        Text('Rp0',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(thickness: 1, color: Color(0xFFEEEEEE)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Pembayaran',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700)),
                        Text(price != null ? 'Rp${price!.toInt()}' : '-',
                            style: GoogleFonts.poppins(
                                color: const Color(0xFF389841), // Hijau
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
