import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LihatDetailKirimanPage extends StatelessWidget {
  final String orderId;
  final String productName;
  final String imageUrl;
  final double? price;
  final VoidCallback? onOrderReceived; // Callback untuk simulasi selesai

  const LihatDetailKirimanPage({
    super.key,
    required this.orderId,
    required this.productName,
    required this.imageUrl,
    this.price,
    this.onOrderReceived,
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

              // --- ALERT BOX ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5F3E7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.inventory_2_outlined,
                        color: Color(0xFF2E6A31), size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Pesanan telah dikirim! Yuk, pantau pengiriman hingga sampai ke pelanggan.',
                        style: GoogleFonts.poppins(
                            color: const Color(0xFF2E6A31),
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // --- INFO ID & TANGGAL ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildRowInfo('ID Transaksi', orderId, isBoldVal: true),
                    const SizedBox(height: 12),
                    _buildRowInfo('Tanggal Pesanan', '12 Agustus 2025',
                        isBoldVal: true),
                    const SizedBox(height: 12),
                    _buildRowInfo('Tanggal Kirim', '15 Agustus 2025',
                        isBoldVal: true),
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

              // --- KEMASAN & CATATAN ---
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
                        Text('Kemasan tambahan',
                            style: GoogleFonts.poppins(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500)),
                        const Icon(Icons.check_box_outlined,
                            color: Color(0xFF389841)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1, color: Color(0xFFEEEEEE)),
                    const SizedBox(height: 12),
                    Text('Catatan Pembeli',
                        style: GoogleFonts.poppins(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text('Tidak ada catatan dari pembeli',
                        style: GoogleFonts.poppins(
                            color: Colors.grey[400], fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // --- INFO PENGIRIMAN, PEMBAYARAN, KURIR ---
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
                    Text('Pembeli',
                        style: GoogleFonts.poppins(
                            color: Colors.grey[500], fontSize: 12)),
                    Text('Nabila Defany',
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    Text('(+62) 812-3485-6768',
                        style: GoogleFonts.poppins(
                            fontSize: 13, color: Colors.black87)),
                    Text('Jalan WayHalim, Bandarlampung, Lampung, 80228',
                        style: GoogleFonts.poppins(
                            fontSize: 13, color: Colors.black87)),
                    const SizedBox(height: 16),
                    const Divider(thickness: 1, color: Color(0xFFEEEEEE)),
                    const SizedBox(height: 16),
                    Text('Metode Pembayaran',
                        style: GoogleFonts.poppins(
                            color: Colors.grey[500], fontSize: 12)),
                    Text('BCA Virtual Account',
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 16),
                    const Divider(thickness: 1, color: Color(0xFFEEEEEE)),
                    const SizedBox(height: 16),
                    Text('Informasi Kurir',
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Text('Kurir Internal : Andri',
                        style: GoogleFonts.poppins(
                            fontSize: 13, fontWeight: FontWeight.w500)),
                    Text('(+62) 811-7864-2308',
                        style: GoogleFonts.poppins(
                            fontSize: 13, color: Colors.black87)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // --- TOMBOL LIHAT MAPS ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Membuka Maps...')),
                    );
                  },
                  icon: const Icon(Icons.map_outlined, color: Colors.white),
                  label: Text('Lihat Maps',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF389841),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // --- RINCIAN PEMBAYARAN (SUDAH DIPERBAIKI) ---
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
                    // Subtotal
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
                    // Ongkir
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
                    // Total
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

              // --- TOMBOL SIMULASI PESANAN DITERIMA ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    if (onOrderReceived != null) {
                      onOrderReceived!();
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    side:
                        const BorderSide(color: Color(0xFF389841), width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Simulasikan Pesanan Diterima',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF389841))),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRowInfo(String label, String value, {bool isBoldVal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.poppins(color: Colors.grey[600])),
        Text(value,
            style: GoogleFonts.poppins(
                fontWeight: isBoldVal ? FontWeight.w600 : FontWeight.w400,
                color: Colors.black87)),
      ],
    );
  }
}
