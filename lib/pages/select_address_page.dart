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
  // Warna Hijau Utama sesuai request
  final Color _primaryGreen = const Color(0xFF389841);

  // Data dummy untuk daftar alamat
  final List<Address> _addresses = [
    Address(
      id: 1,
      street: 'Jalan Menuju Tuhan, Bandar Lampung',
      city: 'Lampung, 80228',
      recipientName: 'Nabila Defany',
      phoneNumber: '+62 851 8819 0911',
      tag: 'Rumah',
    ),
    Address(
      id: 2,
      street: 'Jalan Menuju Langit, Bandar Lampung',
      city: 'Lampung, 80228',
      recipientName: 'Nabila Defany',
      phoneNumber: '+62 851 8819 0911',
      tag: 'Kantor',
    ),
    Address(
      id: 3,
      street: 'Jalan WayHalim, Bandarlampung',
      city: 'Lampung, 80228',
      recipientName: 'Nabila Defany',
      phoneNumber: '+62 851 8819 0911',
      tag: 'Toko',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedAddressId = widget.currentAddressId;
  }

  void _onAddressSelected(int id) {
    setState(() {
      _selectedAddressId = id;
    });
  }

  void _saveAndPop() {
    // Cari object Address berdasarkan ID yang dipilih
    final selectedAddress = _addresses.firstWhere(
      (element) => element.id == _selectedAddressId,
      orElse: () => _addresses[0],
    );
    // Kembalikan data alamat ke halaman sebelumnya (Checkout)
    Navigator.of(context).pop(selectedAddress);
  }

  void _navigateAndAddLocation() async {
    final newAddress = await Navigator.push<Address>(
      context,
      MaterialPageRoute(builder: (context) => const SetLocationPage()),
    );

    if (newAddress != null) {
      setState(() {
        _addresses.add(newAddress);
        _selectedAddressId = newAddress.id;
      });
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Pilih Alamat',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // List Alamat
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _addresses.length,
              itemBuilder: (context, index) {
                final address = _addresses[index];
                return _buildAddressCard(address);
              },
            ),
          ),

          // Bagian Tombol Bawah
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Tombol Tambah Lokasi
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _navigateAndAddLocation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryGreen, // ✅ Warna Hijau 389841
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
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
                const SizedBox(height: 12),
                // Tombol Simpan
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _saveAndPop,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryGreen, // ✅ Warna Hijau 389841
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Simpan',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(Address address) {
    final bool isSelected = _selectedAddressId == address.id;

    return GestureDetector(
      onTap: () => _onAddressSelected(address.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            // ✅ Border Hijau jika dipilih
            color: isSelected ? _primaryGreen : Colors.grey.shade200,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Radio Button Custom
                Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(top: 2, right: 12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? _primaryGreen : Colors.black54,
                      width: 1.5,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _primaryGreen, // ✅ Dot Hijau
                            ),
                          ),
                        )
                      : null,
                ),

                // Info Alamat
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Alamat Pengiriman',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                          // Tombol Ubah
                          Text(
                            'Ubah',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _primaryGreen, // ✅ Teks Ubah Hijau
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${address.street}, ${address.city}',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.black,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: address.recipientName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            TextSpan(
                              text: '  •  ${address.phoneNumber}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Tag Rumah/Kantor
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          // ✅ Background Tag Hijau Muda
                          color: const Color(0xFFF0F9EB),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          address.tag,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color:
                                Colors.black87, // Teks tag hitam agar kontras
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
