// lib/pages/payment_details_page.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

// Path import ini disesuaikan dengan struktur folder Anda saat ini
import 'package:terraserve_app/pages/models/bank_model.dart';
import 'package:terraserve_app/pages/models/cart_item_model.dart';
import 'package:terraserve_app/providers/order_provider.dart';
import 'package:terraserve_app/pages/services/cart_service.dart';
import 'package:terraserve_app/pages/services/navigation_service.dart';

class PaymentDetailsPage extends StatefulWidget {
  final Bank selectedBank;
  final List<CartItem> cartItems; // Menerima data dari halaman sebelumnya

  const PaymentDetailsPage({
    super.key,
    required this.selectedBank,
    required this.cartItems, // Menerima data dari halaman sebelumnya
  });

  @override
  State<PaymentDetailsPage> createState() => _PaymentDetailsPageState();
}

class _PaymentDetailsPageState extends State<PaymentDetailsPage> {
  late Timer _timer;
  Duration _countdownDuration = const Duration(hours: 24);

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_countdownDuration.inSeconds <= 0) {
        timer.cancel();
      } else {
        setState(() {
          _countdownDuration = _countdownDuration - const Duration(seconds: 1);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    // Di aplikasi nyata, total pembayaran harus dioper dari halaman checkout
    double totalPembayaran = 0;
    for (var item in widget.cartItems) {
      totalPembayaran += item.product.price * item.quantity;
    }
    // Tambahkan biaya layanan & pengiriman jika ada
    totalPembayaran += 17000; // Contoh: 2000 layanan + 15000 pengiriman

    const String vaNumber = "8810 88101234 567890";

    DateTime paymentDeadline = DateTime.now().add(const Duration(hours: 24));
    String formattedDate =
        DateFormat('E, d MMMM yyyy, HH:mm', 'id_ID').format(paymentDeadline);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.grey[200],
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Instruksi Pembayaran',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTimerCard(formattedDate),
            const SizedBox(height: 16),
            _buildPaymentInfoCard(totalPembayaran, vaNumber),
            const SizedBox(height: 16),
            _buildInstructionsCard(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // 1. TAMBAHKAN PESANAN BARU KE ORDERPROVIDER
                Provider.of<OrderProvider>(context, listen: false)
                    .addOrderFromCart(widget.cartItems);

                // ✅ PERBAIKAN: Panggil removeSelectedItems, bukan clearCart
                Provider.of<CartService>(context, listen: false)
                    .removeSelectedItems();

                // 3. TAMPILKAN DIALOG SUKSES
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      title: Text('Pembayaran Berhasil',
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                      content: Text(
                          'Pembayaran Anda telah kami terima. Pesanan akan segera diproses.',
                          style: GoogleFonts.poppins()),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Provider.of<NavigationService>(context,
                                    listen: false)
                                .setIndex(2);
                            Navigator.of(dialogContext).pop();
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          },
                          child: Text('Lihat Pesanan',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF859F3D))),
                        )
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
              child: Text(
                'Simulasikan Pembayaran Berhasil',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  // ... Sisa kode widget TIDAK BERUBAH ...
  Widget _buildTimerCard(String formattedDate) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF6FFED),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            'Menunggu Pembayaran',
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            'Bayar sebelum: $formattedDate',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
          ),
          const SizedBox(height: 12),
          Text(
            _formatDuration(_countdownDuration),
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 32,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentInfoCard(double total, String va) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total Pembayaran',
              style:
                  GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700])),
          const SizedBox(height: 4),
          Text(
              NumberFormat.currency(
                      locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
                  .format(total),
              style: GoogleFonts.poppins(
                  fontSize: 24, fontWeight: FontWeight.bold)),
          const Divider(height: 32),
          Text('Metode Pembayaran',
              style:
                  GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700])),
          const SizedBox(height: 12),
          Row(
            children: [
              Image.asset(widget.selectedBank.logoAsset, height: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Transfer Bank ${widget.selectedBank.name.replaceFirst("Bank ", "")}',
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Text('Nomor Virtual Account',
              style:
                  GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700])),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF9F9F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(va,
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                        ClipboardData(text: va.replaceAll(' ', '')));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Nomor Virtual Account disalin')),
                    );
                  },
                  child: Text('Salin',
                      style: GoogleFonts.poppins(
                          color: const Color(0xFF859F3D),
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInstructionsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Petunjuk Transfer M-Banking',
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildInstructionStep(
            '1.',
            [const TextSpan(text: 'Masuk aplikasi mobile banking anda.')],
          ),
          _buildInstructionStep(
            '2.',
            [
              const TextSpan(text: 'Pilih menu '),
              const TextSpan(
                  text: 'Transfer, ',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const TextSpan(text: 'lalu pilih '),
              const TextSpan(
                  text: 'virtual account billing.',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          _buildInstructionStep(
            '3.',
            [const TextSpan(text: 'Masukkan Nomor Virtual Account diatas.')],
          ),
          _buildInstructionStep(
            '4.',
            [
              const TextSpan(
                  text:
                      'Pastikan nama penerima dan total tagihan sudah sesuai.')
            ],
          ),
          _buildInstructionStep(
            '5.',
            [
              const TextSpan(
                  text:
                      'Masukkan PIN Mobile Banking Anda dan selesaikan transaksi.')
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionStep(String number, List<TextSpan> texts) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(number, style: GoogleFonts.poppins(fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.poppins(
                    fontSize: 14, color: Colors.black, height: 1.5),
                children: texts,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text.rich(
              TextSpan(
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: Colors.grey[600]),
                  children: [
                    const TextSpan(
                        text:
                            'Dengan melanjutkan pembayaran, Anda menyetujui '),
                    TextSpan(
                      text: 'Syarat & Ketentuan kami.',
                      style: const TextStyle(
                          color: Color(0xFF859F3D),
                          fontWeight: FontWeight.bold),
                    ),
                  ]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF859F3D),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                'Kembali',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ));
  }
}
