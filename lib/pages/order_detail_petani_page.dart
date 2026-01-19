import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:terraserve_app/pages/models/order_model.dart';

class OrderDetailPetaniPage extends StatelessWidget {
  final Order order;
  final void Function(String orderId, String newStatus)? onUpdateStatus;
  const OrderDetailPetaniPage(
      {super.key, required this.order, this.onUpdateStatus});

  Widget _imageWidget(String url) {
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
          // Padding horizontal kecil (8) agar box terlihat 'mentok' tapi tetap rapi
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
                      icon: const Icon(Icons.arrow_back_ios,
                          color: Colors.black87),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text('Detail Pesanan',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 18, fontWeight: FontWeight.w700)),
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
                    color: const Color(0xFFEFF9EE),
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                    'Pesanan baru masuk! Yuk, segera diproses agar cepat sampai ke pelanggan.',
                    style: GoogleFonts.poppins(color: const Color(0xFF2E6A31))),
              ),
              const SizedBox(height: 16),

              // --- BOX 1: ID & TANGGAL ---
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('ID Transaksi',
                            style:
                                GoogleFonts.poppins(color: Colors.grey[600])),
                        Text(order.id,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text('Tanggal Pesanan',
                        style: GoogleFonts.poppins(color: Colors.grey[600])),
                    const SizedBox(height: 8),
                    Text('12 Agustus 2025',
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // --- BOX 2: PRODUK ---
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade100),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _imageWidget(order.imageUrl)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(order.productName,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w700)),
                            const SizedBox(height: 6),
                            Text('x1',
                                style: GoogleFonts.poppins(
                                    color: Colors.grey[600])),
                          ]),
                    ),
                    Text(
                        order.price != null
                            ? 'Rp${order.price!.toInt().toString()}'
                            : '-',
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // --- BOX 3: INFO PENGIRIMAN & METODE PEMBAYARAN (GABUNG) ---
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bagian Pengiriman
                    Text('Informasi Pengiriman',
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Text('Nabila Defany',
                        style: GoogleFonts.poppins(color: Colors.grey[700])),
                    const SizedBox(height: 6),
                    Text('+62 812-3485-6768',
                        style: GoogleFonts.poppins(
                            color: Colors.grey[500], fontSize: 12)),
                    const SizedBox(height: 6),
                    Text('Jalan WayHalim, Bandarlampung, Lampung, 80228',
                        style: GoogleFonts.poppins(
                            color: Colors.grey[500], fontSize: 12)),

                    // Garis Pemisah
                    const SizedBox(height: 16),
                    const Divider(thickness: 1, color: Color(0xFFEEEEEE)),
                    const SizedBox(height: 16),

                    // Bagian Pembayaran
                    Text('Metode Pembayaran',
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Text('BCA Virtual Account',
                        style: GoogleFonts.poppins(color: Colors.grey[700])),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // --- BOX 4: RINCIAN PEMBAYARAN ---
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Rincian Pembayaran',
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Subtotal Produk',
                                style: GoogleFonts.poppins(
                                    color: Colors.grey[600])),
                            Text(
                                order.price != null
                                    ? 'Rp${order.price!.toInt()}'
                                    : '-',
                                style: GoogleFonts.poppins()),
                          ]),
                      const SizedBox(height: 6),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Ongkos Kirim',
                                style: GoogleFonts.poppins(
                                    color: Colors.grey[600])),
                            Text('Rp0', style: GoogleFonts.poppins()),
                          ]),
                      const SizedBox(height: 8),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Pembayaran',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w700)),
                            Text(
                                order.price != null
                                    ? 'Rp${order.price!.toInt()}'
                                    : '-',
                                style: GoogleFonts.poppins(
                                    color: const Color(0xFF389841),
                                    fontWeight: FontWeight.w700)),
                          ])
                    ]),
              ),
              const SizedBox(height: 18),

              // --- TOMBOL KEMAS ---
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (onUpdateStatus != null)
                      onUpdateStatus!(order.id, 'dikemas');
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pesanan dikemas')));
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF389841),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: Text('Kemas Pesanan',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 12),

              // --- TOMBOL BATALKAN ---
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton(
                  onPressed: () {
                    // Update status menjadi 'dibatalkan'
                    if (onUpdateStatus != null) {
                      onUpdateStatus!(order.id, 'dibatalkan');
                    }
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pesanan dibatalkan')));
                  },
                  style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: Text('Batalkan Proses',
                      style: GoogleFonts.poppins(color: Colors.black87)),
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
