import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KirimPesananPetaniPage extends StatelessWidget {
  final String orderId;
  final String productName;
  final String imageUrl;
  final double? price;
  final void Function(String orderId)? onSent;

  const KirimPesananPetaniPage({
    super.key,
    required this.orderId,
    required this.productName,
    required this.imageUrl,
    this.price,
    this.onSent,
  });

  // PERBAIKAN DI SINI: Mengembalikan fungsi untuk membaca asset lokal
  Widget _image(String url) {
    if (url.startsWith('http')) {
      return Image.network(url, fit: BoxFit.cover);
    }
    // Jika bukan URL http, anggap sebagai asset lokal (misal: 'assets/tomat.png')
    return Image.asset(url, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER ---
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                color: const Color(0xFFF8F9FA),
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

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    // --- ALERT BOX ---
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF9EE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.inventory_2_outlined,
                              color: Color(0xFF2E6A31), size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Pesanan sedang dikemas! Yuk, pastikan produk siap sebelum dikirim ke pelanggan.',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF2E6A31),
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // --- ID & TANGGAL ---
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('ID Transaksi',
                                  style: GoogleFonts.poppins(
                                      color: Colors.grey[600])),
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
                                  style: GoogleFonts.poppins(
                                      color: Colors.grey[600])),
                              Text('12 Agustus 2025',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // --- DETAIL PRODUK ---
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
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700)),
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
                          const SizedBox(height: 12),
                          const Divider(
                              height: 1,
                              thickness: 1,
                              color: Color(0xFFEEEEEE)),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Kemasan tambahan',
                                  style: GoogleFonts.poppins(
                                      color: Colors.grey[600])),
                              const Icon(Icons.check_box_outlined,
                                  color: Colors.grey, size: 20),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text('Catatan Pembeli',
                              style:
                                  GoogleFonts.poppins(color: Colors.grey[600])),
                          const SizedBox(height: 4),
                          Text('Tidak ada catatan dari pembeli',
                              style: GoogleFonts.poppins(
                                  color: Colors.grey[400], fontSize: 13)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // --- INFORMASI PENGIRIMAN ---
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
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(height: 12),
                          Text('Pembeli',
                              style: GoogleFonts.poppins(
                                  color: Colors.grey[500], fontSize: 12)),
                          const SizedBox(height: 2),
                          Text('Nabila Defany',
                              style: GoogleFonts.poppins(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(height: 2),
                          Text('(+62) 812-3485-6768',
                              style:
                                  GoogleFonts.poppins(color: Colors.black87)),
                          const SizedBox(height: 2),
                          Text('Jalan WayHalim, Bandarlampung, Lampung, 80228',
                              style:
                                  GoogleFonts.poppins(color: Colors.black87)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // --- METODE PEMBAYARAN ---
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
                          Text('Metode Pembayaran',
                              style: GoogleFonts.poppins(
                                  color: Colors.grey[500], fontSize: 12)),
                          const SizedBox(height: 4),
                          Text('BCA Virtual Account',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // --- INFORMASI KURIR ---
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
                          Text('Informasi Kurir',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(height: 12),
                          Text('Kurir Internal : Andri',
                              style:
                                  GoogleFonts.poppins(color: Colors.black87)),
                          const SizedBox(height: 2),
                          Text('(+62) 811-7864-2308',
                              style:
                                  GoogleFonts.poppins(color: Colors.black87)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // --- RINCIAN PEMBAYARAN ---
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
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Subtotal Produk',
                                  style: GoogleFonts.poppins(
                                      color: Colors.grey[600])),
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
                                  style: GoogleFonts.poppins(
                                      color: Colors.grey[600])),
                              Text('Rp0',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Divider(
                              height: 1,
                              thickness: 1,
                              color: Color(0xFFEEEEEE)),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total Pembayaran',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w700)),
                              Text(price != null ? 'Rp${price!.toInt()}' : '-',
                                  style: GoogleFonts.poppins(
                                      color: const Color(0xFF389841),
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // --- BUTTONS ---
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF389841),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          if (onSent != null) onSent!(orderId);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Pesanan telah dikirim')));
                        },
                        child: Text('Kirim Pesanan',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE5F3E7),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Pesanan dibatalkan')));
                        },
                        child: Text('Batalkan Pesanan',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87)),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
