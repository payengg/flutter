// lib/pages/shipping_options_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:terraserve_app/pages/schedule_delivery_page.dart'; // Import Schedule Page

class ShippingOptionsPage extends StatefulWidget {
  final String selectedService;
  final String? selectedSchedule;
  const ShippingOptionsPage(
      {super.key, required this.selectedService, this.selectedSchedule});

  @override
  State<ShippingOptionsPage> createState() => _ShippingOptionsPageState();
}

class _ShippingOptionsPageState extends State<ShippingOptionsPage> {
  final Color _primaryGreen = const Color(0xFF389841);
  int _selectedTab = 0; // 0: Antar, 1: Ambil
  int _selectedCourierIndex = 0;

  final List<Map<String, dynamic>> _couriers = [
    {
      'name': 'Standard',
      'price': 0,
      'eta': 'Garansi tiba 14-15 Agustus',
      'originalPrice': 10000,
    },
    {
      'name': 'Instant',
      'price': 12000,
      'eta': 'Pengiriman sampai hanya dalam 2 jam',
      'originalPrice': null,
    },
    {
      'name': 'Hemat',
      'price': null,
      'eta': 'Layanan Tidak Tersedia',
      'originalPrice': null,
    },
  ];

  @override
  void initState() {
    super.initState();
    final index = _couriers
        .indexWhere((element) => element['name'] == widget.selectedService);
    if (index != -1 && _couriers[index]['price'] != null) {
      _selectedCourierIndex = index;
    }
  }

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
          'Opsi Pengiriman',
          style: GoogleFonts.poppins(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tabs
                  Row(
                    children: [
                      _buildTabButton(0, Icons.local_shipping_outlined,
                          'Antar ke alamatmu', 'Gratis'),
                      const SizedBox(width: 12),
                      _buildTabButton(1, Icons.storefront_outlined,
                          'Ambil di Tempat', 'Gratis'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('PILIH JASA PENGIRIMAN',
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[500])),
                  const SizedBox(height: 16),
                  Text('Garansi Tepat Waktu',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  Text('Voucher s/d Rp10.000 jika pesanan terlambat.',
                      style: GoogleFonts.poppins(
                          color: Colors.grey[500], fontSize: 12)),
                  const SizedBox(height: 16),
                  const Divider(height: 1),

                  // Courier List
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _couriers.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      return _buildCourierItem(index);
                    },
                  ),
                  const Divider(height: 1),
                ],
              ),
            ),
          ),

          // Save Button -> Navigate to Schedule
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2))
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  // ✅ Push to ScheduleDeliveryPage
                  final selectedTimeSlot = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScheduleDeliveryPage(
                        currentSchedule: widget.selectedSchedule ?? 'Sekarang',
                      ),
                    ),
                  );

                  // ✅ If a schedule is selected, return BOTH courier and schedule to checkout
                  if (selectedTimeSlot != null && mounted) {
                    Navigator.pop(context, {
                      'courier': _couriers[_selectedCourierIndex],
                      'schedule': selectedTimeSlot
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryGreen,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text('Simpan',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(
      int index, IconData icon, String title, String subtitle) {
    bool isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: isSelected ? _primaryGreen : Colors.grey.shade300,
                width: 1.5),
          ),
          child: Row(
            children: [
              Icon(icon,
                  color: isSelected ? _primaryGreen : Colors.black, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? _primaryGreen : Colors.black)),
                    Text(subtitle,
                        style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: isSelected ? _primaryGreen : Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourierItem(int index) {
    final data = _couriers[index];
    final bool isAvailable = data['price'] != null;
    final bool isSelected = _selectedCourierIndex == index && isAvailable;

    return InkWell(
      onTap: isAvailable
          ? () => setState(() => _selectedCourierIndex = index)
          : null,
      child: Container(
        color: isSelected ? const Color(0xFFF9FFF9) : Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data['name'],
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isAvailable ? Colors.black : Colors.grey)),
                  const SizedBox(height: 4),
                  if (isAvailable)
                    Row(
                      children: [
                        Icon(Icons.local_shipping_outlined,
                            size: 14, color: _primaryGreen),
                        const SizedBox(width: 4),
                        Expanded(
                            child: Text(data['eta'],
                                style: GoogleFonts.poppins(
                                    color: _primaryGreen, fontSize: 12))),
                      ],
                    )
                  else
                    Text(data['eta'],
                        style: GoogleFonts.poppins(
                            color: Colors.grey[400], fontSize: 12)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (data['originalPrice'] != null)
                  Text('Rp${data['originalPrice']}',
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[400],
                          decoration: TextDecoration.lineThrough)),
                if (isAvailable)
                  Text(data['price'] == 0 ? 'Rp0' : 'Rp${data['price']}',
                      style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
