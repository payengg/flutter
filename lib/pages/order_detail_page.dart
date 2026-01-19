import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:terraserve_app/pages/models/order_model.dart';

class OrderDetailPage extends StatelessWidget {
  final Order order;

  const OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // Formatter untuk mata uang Rupiah
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    // Warna Hijau Utama
    const Color mainGreen = Color(0xFF389841);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Detail Pesanan',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Banner Status
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: mainGreen.withOpacity(0.15), // Hijau muda transparan
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getStatusDescription(order.status),
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 2. ID Transaksi & Tanggal
            _buildInfoRow('ID Transaksi', order.id), // Gunakan ID dari order
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
            ),
            _buildInfoRow('Tanggal Pesanan', '12 Agustus 2025'), // Dummy Date
            const SizedBox(height: 24),

            // 3. Detail Produk
            Text(
              'Detail Produk',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFEEEEEE)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Gambar Produk
                  Container(
                    width: 60,
                    height: 60,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        order.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Nama & Qty
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.productName,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'x1', // Dummy quantity
                          style: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Harga
                  Text(
                    currencyFormatter.format(order.price ?? 0),
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 4. Informasi Pengiriman
            Text(
              'Informasi Pengiriman',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFEEEEEE)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nabila Defany', // Dummy Name
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '(+62) 812-3485-6768', // Dummy Phone
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Jalan WayHalim, Bandarlampung, Lampung, 80228', // Dummy Address
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 5. Metode Pembayaran
            Text(
              'Metode Pembayaran',
              style: GoogleFonts.poppins(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'BCA Virtual Account', // Dummy Method
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            const Divider(thickness: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 24),

            // 6. Rincian Pembayaran
            Text(
              'Rincian Pembayaran',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            _buildPaymentRow(
                'Subtotal Produk', currencyFormatter.format(order.price ?? 0)),
            const SizedBox(height: 8),
            _buildPaymentRow('Ongkos Kirim', 'Rp0'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Pembayaran',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  currencyFormatter.format(order.price ?? 0),
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: mainGreen, // Warna Hijau sesuai gambar
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // 7. Estimasi Tiba Banner (Bawah)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: mainGreen.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Estimasi tiba pada 13 Agustus 2025',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper untuk baris Info (ID Transaksi & Tanggal)
  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(color: Colors.grey[500], fontSize: 13),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black),
        ),
      ],
    );
  }

  // Helper untuk baris Rincian Pembayaran
  Widget _buildPaymentRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(color: Colors.grey[500], fontSize: 13),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black),
        ),
      ],
    );
  }

  // Helper Text Status
  String _getStatusDescription(OrderStatus status) {
    switch (status) {
      case OrderStatus.diproses:
        return 'Status terbaru : Pesanan Anda sedang di proses untuk dikemas!';
      case OrderStatus.terkirim:
        return 'Status terbaru : Pesanan Anda sedang dalam perjalanan!';
      case OrderStatus.dibatalkan:
        return 'Status terbaru : Pesanan Anda telah dibatalkan.';
      default:
        return 'Status pesanan diperbarui.';
    }
  }
}
