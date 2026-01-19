// lib/pages/set_location_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:terraserve_app/pages/models/address_model.dart';

class SetLocationPage extends StatefulWidget {
  const SetLocationPage({super.key});

  @override
  State<SetLocationPage> createState() => _SetLocationPageState();
}

class _SetLocationPageState extends State<SetLocationPage> {
  int _selectedTagIndex = 0;
  final List<String> _tags = ['Rumah', 'Kantor', 'Toko', 'Lainnya'];
  final List<IconData> _icons = [
    Icons.home_outlined,
    Icons.work_outline,
    Icons.store_outlined,
    Icons.location_on_outlined
  ];

  final TextEditingController _locationController = TextEditingController();

  final MapController _mapController = MapController();
  LatLng _lastMapPosition =
      LatLng(-5.4292, 105.2614); // Default: Bandar Lampung
  bool _isLoadingLocation = false;

  // Warna Hijau Utama
  final Color _primaryGreen = const Color(0xFF389841);

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      Position position = await _determinePosition();
      LatLng newPosition = LatLng(position.latitude, position.longitude);
      _mapController.move(newPosition, 16.0);
      _getAddressFromLatLng(newPosition); // Auto get address
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() => _isLoadingLocation = false);
      }
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        if (mounted) {
          setState(() {
            // Format alamat sederhana
            _locationController.text =
                "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}";
            _lastMapPosition = position;
          });
        }
      }
    } catch (e) {
      print(e);
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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Set Location',
          style: GoogleFonts.poppins(
              color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _lastMapPosition,
                    initialZoom: 16.0,
                    onPositionChanged: (position, hasGesture) {
                      if (hasGesture) {
                        // Optional: update address only on drag end to save API calls
                        // _getAddressFromLatLng(position.center!);
                      }
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.terraserve_app',
                    ),
                  ],
                ),
                // Marker di tengah (statis)
                const Center(
                  child: Icon(
                    Icons.location_pin,
                    color: Color(0xFF389841), // ✅ Ikon Peta Hijau
                    size: 40,
                  ),
                ),
              ],
            ),
          ),
          // Bagian Bawah untuk Detail Alamat
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 20,
                  offset: Offset(0, -5),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Pilih Lokasi',
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Lokasi Anda',
                  style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    hintText: 'Geser peta untuk memilih lokasi',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                    suffixIcon: IconButton(
                      icon: _isLoadingLocation
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Color(0xFF389841)))
                          : const Icon(Icons.my_location,
                              color: Color(0xFF389841)), // ✅ Ikon GPS Hijau
                      onPressed: _getCurrentLocation,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Simpan Sebagai',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                // Pilihan Tag Alamat
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(_tags.length, (index) {
                    return _buildTagChip(
                      icon: _icons[index],
                      label: _tags[index],
                      isSelected: _selectedTagIndex == index,
                      onTap: () {
                        setState(() {
                          _selectedTagIndex = index;
                        });
                      },
                    );
                  }),
                ),
                const SizedBox(height: 24),
                // Tombol Simpan Alamat
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_locationController.text.isNotEmpty) {
                        final newAddress = Address(
                          id: DateTime.now().millisecondsSinceEpoch,
                          street: _locationController.text,
                          city: 'Bandar Lampung',
                          recipientName: 'User Baru',
                          phoneNumber: '+62 812 3456 7890',
                          tag: _tags[_selectedTagIndex],
                        );
                        Navigator.of(context).pop(newAddress);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Mohon pilih lokasi terlebih dahulu')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryGreen, // ✅ Tombol Hijau 389841
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Simpan Alamat',
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
          )
        ],
      ),
    );
  }

  Widget _buildTagChip(
      {required IconData icon,
      required String label,
      required bool isSelected,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // Ukuran Chip agar mirip tombol di gambar
        width: (MediaQuery.of(context).size.width - 48 - 12) / 2,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color:
              isSelected ? _primaryGreen : Colors.grey[100], // ✅ Selected Hijau
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : Colors.black87,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper function untuk menangani izin lokasi
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Layanan lokasi dimatikan.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Izin lokasi ditolak.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Izin lokasi ditolak permanen, tidak dapat meminta izin.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
