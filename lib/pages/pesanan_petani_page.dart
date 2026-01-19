import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:terraserve_app/pages/models/order_model.dart';
import 'package:terraserve_app/providers/order_provider.dart';

// Import halaman-halaman detail yang sudah dibuat
import 'order_detail_petani_page.dart';
import 'kirim_pesanan_petani_page.dart';
import 'lihat_detail_kiriman_page.dart';
import 'lihat_ulasan_page.dart';
import 'lihat_detail_dibatalkan_page.dart';

class PesananPetaniPage extends StatefulWidget {
  final ScrollController? controller;
  const PesananPetaniPage({super.key, this.controller});

  @override
  State<PesananPetaniPage> createState() => _PesananPetaniPageState();
}

class _PesananPetaniPageState extends State<PesananPetaniPage> {
  int _selectedIndex =
      0; // 0:Diproses, 1:Dikemas, 2:Dikirim, 3:Selesai, 4:Dibatalkan

  final List<String> _statuses = [
    'Diproses',
    'Dikemas',
    'Dikirim',
    'Selesai',
    'Dibatalkan'
  ];

  final List<String> _icons = [
    'diproses.png',
    'dikemas.png',
    'dikirim.png',
    'selesai.png',
    'dibatalkan.png',
  ];

  // Data Dummy untuk Simulasi
  final List<Map<String, dynamic>> _simOrders = [
    {
      'id': 'ID13784932',
      'productName': 'Tomat',
      'quantity': '500gr',
      'image': 'assets/images/tomat.png',
      'price': 40000,
      'status': 'diproses',
    },
    {
      'id': 'ID19283932',
      'productName': 'Kangkung',
      'quantity': '500gr',
      'image': 'assets/images/kangkung.png',
      'price': 30000,
      'status': 'diproses',
    }
  ];

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    // Filter untuk Real Data (Provider) - Jika nanti digunakan
    List<Order> filteredOrders = [];
    switch (_selectedIndex) {
      case 0:
        filteredOrders = orderProvider.orders
            .where((o) => o.status == OrderStatus.diproses)
            .toList();
        break;
      case 1:
        filteredOrders = orderProvider.orders
            .where((o) => o.status == OrderStatus.dikemas)
            .toList();
        break;
      case 2:
        filteredOrders = orderProvider.orders
            .where((o) => o.status == OrderStatus.terkirim)
            .toList();
        break;
      case 3:
        filteredOrders = orderProvider.orders
            .where((o) => o.status == OrderStatus.selesai)
            .toList();
        break;
      case 4:
        filteredOrders = orderProvider.orders
            .where((o) => o.status == OrderStatus.dibatalkan)
            .toList();
        break;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text('Pesanan',
            style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 20)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // --- TAB MENU ---
          Container(
            height: 140,
            color: Colors.white,
            width: double.infinity,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
              itemCount: _statuses.length,
              separatorBuilder: (context, index) => const SizedBox(width: 32),
              itemBuilder: (context, index) {
                return _buildTabItem(index);
              },
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

          // --- LIST PESANAN ---
          Expanded(
            child: Container(
              color: const Color(0xFFF5F5F5),
              child: _buildOrderList(filteredOrders),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index) {
    bool isSelected = _selectedIndex == index;
    Color activeColor = const Color(0xFF389841);
    Color inactiveColor = Colors.black54;

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFF0F9EB) : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              'assets/images/${_icons[index]}',
              width: 45,
              height: 45,
              color: isSelected ? activeColor : inactiveColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _statuses[index],
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? activeColor : inactiveColor,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 3,
            width: 50,
            decoration: BoxDecoration(
              color: isSelected ? activeColor : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildOrderList(List<Order> orders) {
    // --- LOGIKA SIMULASI JIKA DATA PROVIDER KOSONG ---
    if (orders.isEmpty) {
      final tabKey = [
        'diproses',
        'dikemas',
        'dikirim',
        'selesai',
        'dibatalkan'
      ][_selectedIndex];

      final filtered = _simOrders.where((o) => o['status'] == tabKey).toList();

      if (filtered.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo_no_pesanan.png',
                  width: 150, height: 150),
              const SizedBox(height: 16),
              Text('Belum ada pesanan',
                  style: GoogleFonts.poppins(color: Colors.grey[600])),
            ],
          ),
        );
      }

      return ListView.separated(
        controller: widget.controller,
        padding: const EdgeInsets.all(16),
        itemCount: filtered.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final m = filtered[index];
          // Helper konversi string -> Enum
          OrderStatus mapStatus(String s) {
            switch (s) {
              case 'diproses':
                return OrderStatus.diproses;
              case 'dikemas':
                return OrderStatus.dikemas;
              case 'dikirim':
                return OrderStatus.terkirim;
              case 'selesai':
                return OrderStatus.selesai;
              case 'dibatalkan':
                return OrderStatus.dibatalkan;
              default:
                return OrderStatus.diproses;
            }
          }

          final order = Order(
            id: m['id'],
            productName: m['productName'],
            quantity: m['quantity'],
            imageUrl: m['image'],
            status: mapStatus(m['status']),
            price: (m['price'] as int).toDouble(),
          );

          // PANGGIL WIDGET CARD SIMULASI
          return _buildSampleOrderCard(order);
        },
      );
    }

    // --- JIKA ADA REAL DATA (PROVIDER) ---
    return ListView.separated(
      controller: widget.controller,
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildOrderCard(orders[index]);
      },
    );
  }

  // =========================================================
  // WIDGET CARD UNTUK SIMULASI (UTAMA)
  // =========================================================
  Widget _buildSampleOrderCard(Order order) {
    final idx = _simOrders.indexWhere((o) => o['id'] == order.id);
    final simStatus =
        idx != -1 ? _simOrders[idx]['status'] as String : 'diproses';

    // 1. JIKA STATUS "SELESAI"
    if (simStatus == 'selesai') {
      return _buildSelesaiCard(order);
    }

    // 2. JIKA STATUS "DIBATALKAN"
    if (simStatus == 'dibatalkan') {
      return _buildDibatalkanCard(order);
    }

    // 3. STATUS LAIN (DIPROSES, DIKEMAS, DIKIRIM)
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(order.id,
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: Colors.grey[600])),
              Text('12 Aug 2025, 15.00 WIB',
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: Colors.grey[400])),
            ],
          ),
          const SizedBox(height: 8),
          // Gambar & Nama
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade100,
                  image: DecorationImage(
                    image: AssetImage(order.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.productName,
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(order.quantity,
                        style: GoogleFonts.poppins(
                            color: Colors.grey[500], fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 12),

          // --- LOGIKA FOOTER (HARGA/TOMBOL) ---
          Builder(builder: (context) {
            // A. STATUS "DIKIRIM" -> (Teks kiri, Tombol Map & Detail kanan)
            if (simStatus == 'dikirim') {
              return Row(
                children: [
                  Expanded(
                    child: Text(
                      'Konfirmasi pesanan Anda segera setelah tiba.',
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: Colors.grey[500]),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () {
                        // Ke Halaman Detail Kiriman (Maps & Simulasi Selesai)
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LihatDetailKirimanPage(
                              orderId: order.id,
                              productName: order.productName,
                              imageUrl: order.imageUrl,
                              price: order.price,
                              onOrderReceived: () {
                                // Callback saat simulasi 'Terima Pesanan' diklik
                                final idx = _simOrders
                                    .indexWhere((o) => o['id'] == order.id);
                                if (idx != -1) {
                                  setState(() {
                                    _simOrders[idx]['status'] = 'selesai';
                                    _selectedIndex = 3; // Pindah ke Tab Selesai
                                  });
                                  Navigator.pop(context); // Tutup detail
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Pesanan Selesai!')),
                                  );
                                }
                              },
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF389841),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text('Lihat Detail',
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 36,
                    width: 36,
                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Membuka Tracking...')));
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        side: const BorderSide(color: Color(0xFF389841)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Icon(Icons.map_outlined,
                          color: Color(0xFF389841), size: 20),
                    ),
                  ),
                ],
              );
            }

            // B. STATUS STANDAR (Diproses/Dikemas) -> (Harga kiri, 1 Tombol kanan)
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Harga',
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: Colors.grey[600])),
                    const SizedBox(height: 4),
                    Text(_formatPrice(order.price),
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () {
                      if (simStatus == 'dikemas') {
                        // Ke Halaman Kirim
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => KirimPesananPetaniPage(
                                      orderId: order.id,
                                      productName: order.productName,
                                      imageUrl: order.imageUrl,
                                      price: order.price,
                                      onSent: (orderId) {
                                        final idx = _simOrders.indexWhere(
                                            (o) => o['id'] == orderId);
                                        if (idx != -1) {
                                          setState(() {
                                            _simOrders[idx]['status'] =
                                                'dikirim';
                                          });
                                        }
                                      },
                                    )));
                      } else {
                        // Ke Halaman Detail (Bisa Batalkan)
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderDetailPetaniPage(
                                      order: order,
                                      onUpdateStatus: (orderId, newStatus) {
                                        final idx = _simOrders.indexWhere(
                                            (o) => o['id'] == orderId);
                                        if (idx != -1) {
                                          setState(() {
                                            _simOrders[idx]['status'] =
                                                newStatus;
                                            // --- PINDAH TAB JIKA DIBATALKAN ---
                                            if (newStatus == 'dibatalkan') {
                                              _selectedIndex = 4;
                                            }
                                          });
                                        }
                                      },
                                    )));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF389841),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    child: Text(
                        simStatus == 'dikemas'
                            ? 'Kirim Produk'
                            : 'Lihat Detail',
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  // =========================================================
  // CARD KHUSUS STATUS "SELESAI"
  // =========================================================
  Widget _buildSelesaiCard(Order order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2))
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Pesanan Anda',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600, fontSize: 14)),
              Text(order.id,
                  style: GoogleFonts.poppins(
                      color: Colors.grey[400], fontSize: 12)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade100,
                  image: DecorationImage(
                    image: AssetImage(order.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order.productName,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700, fontSize: 15)),
                  Text(order.quantity,
                      style: GoogleFonts.poppins(
                          color: Colors.grey[500], fontSize: 12)),
                ],
              ),
              const Spacer(),
              Text(_formatPrice(order.price),
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Beri ulasan untuk produk yang telah sampai.',
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: Colors.grey[400]),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LihatUlasanPage(
                        productName: order.productName,
                        imageUrl: order.imageUrl,
                        orderId: order.id,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF389841),
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text('Lihat Ulasan',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================
  // CARD KHUSUS STATUS "DIBATALKAN"
  // =========================================================
  Widget _buildDibatalkanCard(Order order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2))
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Pesanan Anda',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600, fontSize: 14)),
              Text(order.id,
                  style: GoogleFonts.poppins(
                      color: Colors.grey[400], fontSize: 12)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade100,
                  image: DecorationImage(
                    image: AssetImage(order.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order.productName,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700, fontSize: 15)),
                  Text(order.quantity,
                      style: GoogleFonts.poppins(
                          color: Colors.grey[500], fontSize: 12)),
                ],
              ),
              const Spacer(),
              Text(_formatPrice(order.price),
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 12),

          // ALERT BOX MERAH
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.cancel_outlined, color: Colors.red, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dibatalkan oleh Petani',
                          style: GoogleFonts.poppins(
                              color: const Color(0xFFD32F2F),
                              fontWeight: FontWeight.w600,
                              fontSize: 13)),
                      Text('Alasan : Stok habis atau kendala lain',
                          style: GoogleFonts.poppins(
                              color: Colors.grey[600], fontSize: 11)),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Tombol Lihat Detail (Hijau) - Pojok Kanan
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LihatDetailDibatalkanPage(
                              orderId: order.id,
                              productName: order.productName,
                              imageUrl: order.imageUrl,
                              price: order.price,
                            )));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF389841), // Hijau
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Lihat Detail',
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // CARD UNTUK REAL DATA
  // =========================================================
  Widget _buildOrderCard(Order order) {
    if (order.status == OrderStatus.selesai) {
      return _buildSelesaiCard(order);
    }
    if (order.status == OrderStatus.dibatalkan) {
      return _buildDibatalkanCard(order);
    }

    // Default card
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Pesanan Dari',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black)),
              Text(order.id,
                  style: GoogleFonts.poppins(
                      color: Colors.grey[400], fontSize: 12)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(order.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => const Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.grey)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.productName,
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    Text('500gr',
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: Colors.grey[500])),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Harga',
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: Colors.grey[600])),
                const SizedBox(height: 4),
                Text(_formatPrice(order.price),
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(
              height: 36,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              OrderDetailPetaniPage(order: order)));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF389841),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                child: Text('Lihat Detail',
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            ),
          ])
        ],
      ),
    );
  }

  String _formatPrice(double? v) {
    if (v == null) return 'Rp -';
    final intVal = v.toInt();
    final formatted = intVal
        .toString()
        .replaceAllMapped(RegExp(r"\B(?=(\d{3})+(?!\d))"), (m) => '.');
    return 'Rp $formatted';
  }
}
