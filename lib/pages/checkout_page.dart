// lib/pages/checkout_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:terraserve_app/pages/models/address_model.dart';
import 'package:terraserve_app/pages/models/cart_item_model.dart';
import 'package:terraserve_app/pages/select_address_page.dart';
import 'package:terraserve_app/pages/services/cart_service.dart';
import 'package:terraserve_app/pages/payment_method_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  Address? _selectedAddress;

  @override
  void initState() {
    super.initState();
    _selectedAddress = Address(
      id: 1,
      street: 'Jalan Menuju Kebaikan, Bandar Lampung',
      city: 'Lampung, 35141',
      recipientName: 'Budi Santoso',
      phoneNumber: '+62 812 3456 7890',
      tag: 'Rumah',
    );
  }

  void _navigateToSelectAddress() async {
    final result = await Navigator.push<Address>(
      context,
      MaterialPageRoute(
        builder: (context) => SelectAddressPage(
          currentAddressId: _selectedAddress?.id ?? 0,
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _selectedAddress = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Di sini kita dengarkan perubahan agar UI update jika ada perubahan di cart
    final cartService = Provider.of<CartService>(context);
    const double biayaLayanan = 2000;
    const double biayaPengiriman = 15000;
    // totalPrice dari cartService sudah otomatis menghitung item yang dipilih saja
    final double totalPembayaran =
        cartService.totalPrice + biayaLayanan + biayaPengiriman;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Checkout',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _navigateToSelectAddress,
                child: _buildAddressSection(),
              ),
              const SizedBox(height: 16),
              _buildScheduleSection(),
              const SizedBox(height: 24),
              _buildDeliveryDurationSection(),
              const SizedBox(height: 24),
              // PERUBAHAN 1: Tampilkan ringkasan dari item yang dipilih
              _buildOrderSummary(cartService.selectedItems),
              const SizedBox(height: 24),
              _buildPaymentSummary(
                  cartService, biayaLayanan, biayaPengiriman, totalPembayaran),
              const SizedBox(height: 100), // Ruang untuk tombol bawah
            ],
          ),
        ),
      ),
      bottomSheet: _buildBottomButton(context, cartService.selectedItems),
    );
  }

  Widget _buildOrderSummary(List<CartItem> selectedItems) {
    return _buildSectionCard(
      child: Column(
        children: List.generate(selectedItems.length, (index) {
          final item = selectedItems[index];
          return Padding(
            padding: EdgeInsets.only(
                bottom: index == selectedItems.length - 1 ? 0 : 16.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(item.product.galleries.first,
                      width: 50, height: 50, fit: BoxFit.cover),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.product.name,
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                      Text(item.product.unit ?? '',
                          style: GoogleFonts.poppins(
                              color: Colors.grey, fontSize: 12)),
                      Text('Rp${item.product.price.toStringAsFixed(0)}',
                          style: GoogleFonts.poppins(
                              color: const Color(0xFF61AD4E),
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Text('${item.quantity} pcs',
                    style: GoogleFonts.poppins(color: Colors.grey)),
              ],
            ),
          );
        }),
      ),
      color: Colors.white,
    );
  }

  Widget _buildBottomButton(
      BuildContext context, List<CartItem> selectedItems) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: ElevatedButton(
        // PERUBAHAN 2: Kirim data item yang dipilih ke halaman selanjutnya
        onPressed: () {
          if (selectedItems.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content:
                      Text('Pilih setidaknya satu item untuk di-checkout.')),
            );
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentMethodPage(
                cartItems: selectedItems, // <-- DATA DIKIRIM DI SINI
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF859F3D),
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          'Lanjutkan ke Pembayaran',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Sisa widget lain (_buildAddressSection, _buildPaymentSummary, dll) tidak perlu diubah
  // ... (salin sisa widget Anda yang lain ke sini)
  Widget _buildAddressSection() {
    if (_selectedAddress == null) return const SizedBox.shrink();
    final address = _selectedAddress!;

    return _buildSectionCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2.0),
            child: Icon(Icons.location_on_outlined, color: Color(0xFF859F3D)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Alamat Pengiriman',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Text('${address.street}, ${address.city}',
                    style: GoogleFonts.poppins(
                        fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    style:
                        GoogleFonts.poppins(fontSize: 12, color: Colors.black),
                    children: [
                      TextSpan(
                        text: address.recipientName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: '   •   ${address.phoneNumber}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: const Color(0xFFF0F4E8),
                    borderRadius: BorderRadius.circular(5)),
                child: Text(address.tag,
                    style: GoogleFonts.poppins(
                        color: const Color(0xFF859F3D),
                        fontSize: 12,
                        fontWeight: FontWeight.w500)),
              ),
              const SizedBox(height: 40),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildScheduleSection() {
    return _buildSectionCard(
      child: Row(
        children: [
          const Icon(Icons.schedule, color: Color(0xFF859F3D)),
          const SizedBox(width: 8),
          Text('Jadwal pengiriman',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
          const Spacer(),
          Text('Sekarang', style: GoogleFonts.poppins(color: Colors.grey[600])),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildDeliveryDurationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Durasi pengiriman',
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        _buildSectionCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Standard',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  Text('Gratis',
                      style: GoogleFonts.poppins(
                          color: Colors.grey[600], fontSize: 12)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(5)),
                child: Text('2 Jam',
                    style: GoogleFonts.poppins(
                        fontSize: 12, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentSummary(CartService cartService, double layanan,
      double pengiriman, double total) {
    return _buildSectionCard(
      color: const Color(0xFFF9F9F9),
      child: Column(
        children: [
          _buildSummaryRow('Subtotal', cartService.totalPrice),
          const SizedBox(height: 8),
          _buildSummaryRow('Biaya layanan', layanan),
          const SizedBox(height: 8),
          _buildSummaryRow('Biaya pengiriman', pengiriman),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: DashedDivider(),
          ),
          _buildSummaryRow('Total', total, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black : Colors.grey[600],
          ),
        ),
        Text(
          'Rp${value.toStringAsFixed(0)}',
          style: GoogleFonts.poppins(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? const Color(0xFF61AD4E) : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard(
      {required Widget child, Color color = Colors.white}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: child,
    );
  }
}

class DashedDivider extends StatelessWidget {
  const DashedDivider({super.key, this.height = 1, this.color = Colors.grey});
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 5.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}
