// lib/pages/checkout_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:terraserve_app/pages/models/address_model.dart';
import 'package:terraserve_app/pages/models/cart_item_model.dart';
import 'package:terraserve_app/pages/schedule_delivery_page.dart';
import 'package:terraserve_app/pages/select_address_page.dart';
import 'package:terraserve_app/pages/shipping_options_page.dart';
import 'package:terraserve_app/pages/services/cart_service.dart';
import 'package:terraserve_app/pages/payment_method_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  Address? _selectedAddress;
  String _deliverySchedule = 'Sekarang';

  // State for Shipping
  String _shippingType = 'Standard';
  double _shippingCost = 0;
  String _shippingEta = '2 Jam';

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

  // Ensure this function is used if you want direct access to schedule page,
  // otherwise the flow is through Shipping Options.
  void _navigateToSchedulePage() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => ScheduleDeliveryPage(
          currentSchedule: _deliverySchedule,
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _deliverySchedule = result;
      });
    }
  }

  // ✅ Navigation Flow: Shipping Options -> Schedule -> Checkout
  void _navigateToShippingOptions() async {
    // The result will be a Map containing both courier and schedule info
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => ShippingOptionsPage(
          selectedService: _shippingType,
          selectedSchedule: _deliverySchedule,
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        // Update Shipping Info
        final courier = result['courier'];
        _shippingType = courier['name'];
        _shippingCost = (courier['price'] as num).toDouble();
        _shippingEta = _shippingType == 'Instant' ? '2 Jam' : '14-15 Agus';

        // Update Schedule Info from the chained navigation
        _deliverySchedule = result['schedule'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);
    const double biayaLayanan = 2000;

    final double totalPembayaran =
        cartService.totalPrice + biayaLayanan + _shippingCost;

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

              // Direct access to schedule page (optional, based on your design preferences)
              GestureDetector(
                onTap: _navigateToSchedulePage,
                child: _buildScheduleSection(),
              ),
              const SizedBox(height: 24),

              // ✅ Trigger the flow: Shipping Options -> Schedule
              GestureDetector(
                onTap: _navigateToShippingOptions,
                child: _buildDeliveryDurationSection(),
              ),

              const SizedBox(height: 24),
              _buildOrderSummary(cartService.selectedItems),
              const SizedBox(height: 24),
              _buildPaymentSummary(
                  cartService, biayaLayanan, _shippingCost, totalPembayaran),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomSheet: _buildBottomButton(context, cartService.selectedItems),
    );
  }

  // ... (Rest of the widgets: _buildOrderSummary, _buildBottomButton, _buildAddressSection, _buildScheduleSection, _buildDeliveryDurationSection, _buildPaymentSummary, _buildSummaryRow, _buildSectionCard, DashedDivider)
  // Ensure _buildScheduleSection uses _deliverySchedule variable

  Widget _buildScheduleSection() {
    return _buildSectionCard(
      child: Row(
        children: [
          const Icon(Icons.schedule, color: Color(0xFF389841)),
          const SizedBox(width: 8),
          Text('Jadwal pengiriman',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(_deliverySchedule,
              style: GoogleFonts.poppins(color: Colors.grey[600])),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  // Other widgets remain the same as previously provided...
  // Place _buildOrderSummary, _buildBottomButton, etc. here.

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
                              color: const Color(0xFF389841),
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
                cartItems: selectedItems,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF389841),
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

  Widget _buildAddressSection() {
    if (_selectedAddress == null) return const SizedBox.shrink();
    final address = _selectedAddress!;

    return _buildSectionCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2.0),
            child: Icon(Icons.location_on_outlined, color: Color(0xFF389841)),
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
                        text: '   •   ${address.phoneNumber}',
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
                        color: const Color(0xFF389841),
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
                  Text(_shippingType, // Tampilkan Standard / Instant
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  Text(
                    _shippingCost == 0
                        ? 'Gratis'
                        : 'Rp${_shippingCost.toStringAsFixed(0)}', // Tampilkan Harga
                    style: GoogleFonts.poppins(
                        color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(_shippingEta, // Tampilkan ETA
                        style: GoogleFonts.poppins(
                            fontSize: 12, fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.arrow_forward_ios,
                      size: 16, color: Colors.grey),
                ],
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
            child: Divider(color: Colors.grey, thickness: 0.5),
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
            color: isTotal ? const Color(0xFF389841) : Colors.black,
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
