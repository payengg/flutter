// lib/pages/schedule_delivery_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScheduleDeliveryPage extends StatefulWidget {
  final String? currentSchedule;
  const ScheduleDeliveryPage({super.key, this.currentSchedule});

  @override
  State<ScheduleDeliveryPage> createState() => _ScheduleDeliveryPageState();
}

class _ScheduleDeliveryPageState extends State<ScheduleDeliveryPage> {
  final Color _primaryGreen = const Color(0xFF389841);

  final List<String> _timeSlots = [
    '08.00 - 10.00',
    '10.00 - 12.00',
    '13.00 - 14.00',
    '14.00 - 16.00',
    '16.00 - 18.00',
    '18.00 - 20.00',
  ];

  late String _selectedSlot;

  @override
  void initState() {
    super.initState();
    _selectedSlot = widget.currentSchedule ?? _timeSlots[0];
    if (widget.currentSchedule == 'Sekarang') {
      _selectedSlot = '';
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
          'Pilih Jadwal Pengiriman',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header Tanggal
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color(0xFFF2FBE0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.poppins(
                        fontSize: 14, color: Colors.grey[600]),
                    children: [
                      const TextSpan(text: 'Pengiriman: '),
                      TextSpan(
                        text: 'Jumat, 15 Agustus 2025',
                        style: TextStyle(
                            color: _primaryGreen, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Silahkan pilih waktu pengiriman',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
                ),
              ],
            ),
          ),

          // Header Pilih Jam
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey[100],
            child: Text(
              'Pilih Jam:',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[700]),
            ),
          ),

          // List Jam
          Expanded(
            child: ListView.separated(
              itemCount: _timeSlots.length,
              separatorBuilder: (context, index) =>
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
              itemBuilder: (context, index) {
                final slot = _timeSlots[index];
                final isSelected = _selectedSlot == slot;
                return ListTile(
                  onTap: () {
                    setState(() {
                      _selectedSlot = slot;
                    });
                  },
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  title: Text(
                    slot,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check, color: _primaryGreen)
                      : null,
                );
              },
            ),
          ),

          // Tombol Simpan
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedSlot.isNotEmpty) {
                    // ✅ Kembalikan data slot yang dipilih
                    Navigator.pop(context, _selectedSlot);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryGreen,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text(
                  'Simpan',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
