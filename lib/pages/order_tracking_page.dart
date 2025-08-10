// lib/pages/order_tracking_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

class OrderTrackingPage extends StatelessWidget {
  const OrderTrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Titik A: Universitas Lampung, Titik B: Way Halim
    final LatLng startPoint = LatLng(-5.3585, 105.2415);
    final LatLng endPoint = LatLng(-5.3833, 105.2758);

    // ✅ PERUBAHAN: Tambahkan beberapa titik di antara untuk membuat rute melengkung
    final List<LatLng> routePoints = [
      startPoint,
      LatLng(-5.3675, 105.2470), // Titik di Jl. Zainal Abidin Pagar Alam
      LatLng(-5.3780, 105.2600), // Titik di dekat belokan Jl. Teuku Umar
      LatLng(-5.3810, 105.2715), // Titik di Jl. Sultan Agung
      endPoint,
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Bagian Peta
          FlutterMap(
            options: MapOptions(
              // ✅ PERUBAHAN: Sesuaikan pusat dan zoom agar seluruh rute terlihat
              initialCenter: LatLng(-5.374, 105.258),
              initialZoom: 14.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.terraserve.app',
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: routePoints, // Gunakan daftar titik yang baru
                    strokeWidth: 5.0,
                    color: Colors.black87,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: startPoint,
                    child: const Icon(Icons.store_mall_directory,
                        color: Colors.green, size: 40),
                  ),
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: endPoint,
                    child: const Icon(Icons.location_on,
                        color: Colors.green, size: 40),
                  ),
                ],
              ),
            ],
          ),

          // Tombol Kembali
          Positioned(
            top: 50,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.8),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),

          // Bottom Sheet Detail Pengiriman
          DraggableScrollableSheet(
            initialChildSize: 0.35,
            minChildSize: 0.35,
            maxChildSize: 0.6,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.0),
                    topRight: Radius.circular(24.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20.0),
                  children: [
                    Text(
                      'Pelacakan Pesanan',
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    _buildDriverInfo(),
                    const Divider(height: 30),
                    _buildDeliveryDetail(
                      icon: Icons.location_on_outlined,
                      title: 'Alamat Pengiriman',
                      subtitle:
                          'Jalan Way Halim, Bandar Lampung, Lampung, 80228',
                    ),
                    const SizedBox(height: 20),
                    _buildDeliveryDetail(
                      icon: Icons.timer_outlined,
                      title: 'Delivery Time',
                      subtitle: '03:00PM (Max 20 min)',
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ... Sisa kode (_buildDriverInfo, _buildDeliveryDetail) tidak ada perubahan ...
  Widget _buildDriverInfo() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(
              'https://i.pravatar.cc/150?u=ucup'), // Gambar profil dummy
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ucup',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'Petani',
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            // TODO: Fungsi untuk menelepon
          },
          icon: const Icon(Icons.phone, color: Colors.green, size: 28),
        )
      ],
    );
  }

  Widget _buildDeliveryDetail(
      {required IconData icon,
      required String title,
      required String subtitle}) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.green.withOpacity(0.1),
          child: Icon(icon, color: Colors.green),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.poppins(color: Colors.grey)),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, fontSize: 11),
              ),
            ],
          ),
        )
      ],
    );
  }
}
