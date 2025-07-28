// lib/pages/set_location_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_map/flutter_map.dart'; // ✅ 1. Impor flutter_map
import 'package:latlong2/latlong.dart';      // ✅ 2. Impor latlong2
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
  LatLng _lastMapPosition = LatLng(-5.4292, 105.2614); // Default: Bandar Lampung
  bool _isLoadingLocation = false;

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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())));
    } finally {
      if(mounted){
        setState(() => _isLoadingLocation = false);
      }
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        if(mounted){
          setState(() {
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
                        _getAddressFromLatLng(position.center!);
                      }
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      // ✅ Ganti nilai di bawah ini dengan package name aplikasi Anda
                      userAgentPackageName: 'com.example.terraserve_app', 
                    ),
                  ],
                ),
                const Center(
                  child: Icon(
                    Icons.location_pin,
                    color: Colors.red,
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
                const SizedBox(height: 16),
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
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.my_location, color: Color(0xFF859F3D)),
                      onPressed: _getCurrentLocation,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Save As',
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
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
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF859F3D),
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF859F3D) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey[700],
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