// lib/pages/select_address_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:terraserve_app/pages/models/address_model.dart';
import 'package:terraserve_app/pages/set_location_page.dart';

class SelectAddressPage extends StatefulWidget {
  final int currentAddressId;
  const SelectAddressPage({super.key, required this.currentAddressId});

  @override
  State<SelectAddressPage> createState() => _SelectAddressPageState();
}

class _SelectAddressPageState extends State<SelectAddressPage> {
  late int _selectedAddressId;

  // Data dummy untuk daftar alamat
  final List<Address> _addresses = [
    Address(
      id: 1,
      street: 'Jalan Menuju Tuhan, Bandar Lampung',
      city: 'Lampung, 80228',
      recipientName: 'Dexter Morgan',
      phoneNumber: '+62 851 8819 0911',
      tag: 'Rumah',
    ),
    Address(
      id: 2,
      street: 'Jalan Menuju Langit, Bandar Lampung',
      city: 'Lampung, 80228',
      recipientName: 'Dexter Morgan',
      phoneNumber: '+62 851 8819 0911',
      tag: 'Kantor',
    ),
    Address(
      id: 3,
      street: 'Jalan WayHalim, Bandarlampung',
      city: 'Lampung, 80228',
      recipientName: 'Dexter Morgan',
      phoneNumber: '+62 851 8819 0911',
      tag: 'Toko',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedAddressId = widget.currentAddressId;
  }

  void _onAddressSelected(Address address) {
    // Kirim data alamat yang dipilih kembali ke halaman checkout
    Navigator.of(context).pop(address);
  }

  // ✅ 1. Buat fungsi async untuk navigasi dan menerima alamat baru
  void _navigateAndAddLocation() async {
    // Tunggu hasil (alamat baru) dari SetLocationPage
    final newAddress = await Navigator.push<Address>(
      context,
      MaterialPageRoute(builder: (context) => const SetLocationPage()),
    );

    // Jika ada alamat baru yang dikirim kembali, tambahkan ke daftar
    if (newAddress != null) {
      setState(() {
        _addresses.add(newAddress);
        // Otomatis pilih alamat yang baru ditambahkan
        _selectedAddressId = newAddress.id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          'Pilih Alamat',
          style: GoogleFonts.poppins(
              color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _addresses.length,
                itemBuilder: (context, index) {
                  final address = _addresses[index];
                  return _buildAddressCard(address);
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                // ✅ 2. Panggil fungsi navigasi yang baru
                onPressed: _navigateAndAddLocation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF859F3D),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Tambah Lokasi',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard(Address address) {
    final bool isSelected = _selectedAddressId == address.id;
    return GestureDetector(
      onTap: () => _onAddressSelected(address),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: isSelected
              ? Border.all(color: const Color(0xFF859F3D), width: 1.5)
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(top: 2, right: 12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: isSelected
                        ? const Color(0xFF859F3D)
                        : Colors.grey.shade400,
                    width: 1.5),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF859F3D),
                        ),
                      ),
                    )
                  : null,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Alamat Pengiriman',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey)),
                      Text('Ubah',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF859F3D))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('${address.street}, ${address.city}',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, height: 1.4)),
                  const SizedBox(height: 8),
                  Text(
                      '${address.recipientName}   •   ${address.phoneNumber}',
                      style: GoogleFonts.poppins(
                          color: Colors.grey[600], fontSize: 12)),
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(address.tag,
                        style: GoogleFonts.poppins(
                            fontSize: 12, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
