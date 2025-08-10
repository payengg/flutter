// lib/pages/pesanan_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:terraserve_app/pages/models/order_model.dart';
import 'package:terraserve_app/providers/order_provider.dart';
import 'package:terraserve_app/pages/order_tracking_page.dart'; // <-- 1. TAMBAHKAN IMPORT INI

// Enum dan Class Order sudah dipindahkan ke file model sendiri

class PesananPage extends StatefulWidget {
  // ✅ 1. TAMBAHKAN VARIABEL UNTUK MENERIMA CONTROLLER
  final ScrollController? controller;

  const PesananPage({super.key, this.controller}); // ✅ 2. PERBARUI CONSTRUCTOR

  @override
  State<PesananPage> createState() => _PesananPageState();
}

// ✅ 3. TAMBAHKAN SingleTickerProviderStateMixin UNTUK TAB CONTROLLER
class _PesananPageState extends State<PesananPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Inisialisasi TabController di sini
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose(); // Hapus controller saat widget dihancurkan
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    final processedOrders = orderProvider.orders
        .where((o) => o.status == OrderStatus.diproses)
        .toList();
    final shippedOrders = orderProvider.orders
        .where((o) => o.status == OrderStatus.terkirim)
        .toList();
    final canceledOrders = orderProvider.orders
        .where((o) => o.status == OrderStatus.dibatalkan)
        .toList();

    // Hapus DefaultTabController karena kita sudah manual
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Pesanan',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController, // ✅ 4. GUNAKAN TAB CONTROLLER
          padding: const EdgeInsets.symmetric(horizontal: 16),
          indicator: BoxDecoration(
            color: const Color(0xFFE6F0D8),
            borderRadius: BorderRadius.circular(12),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: const Color(0xFF4B6028),
          unselectedLabelColor: Colors.grey[600],
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          unselectedLabelStyle:
              GoogleFonts.poppins(fontWeight: FontWeight.normal),
          tabs: const [
            Tab(text: 'Sedang Diproses'),
            Tab(text: 'Terkirim'),
            Tab(text: 'Dibatalkan'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController, // ✅ 5. GUNAKAN TAB CONTROLLER
        children: [
          _buildOrderList(processedOrders),
          _buildOrderList(shippedOrders),
          _buildOrderList(canceledOrders),
        ],
      ),
    );
  }

  Widget _buildOrderList(List<Order> orders) {
    if (orders.isEmpty) {
      return Center(
          child: Text('Tidak ada pesanan di kategori ini',
              style: GoogleFonts.poppins()));
    }
    return ListView.separated(
      // ✅ 6. GUNAKAN SCROLL CONTROLLER DARI MAIN_PAGE
      controller: widget.controller,
      padding: const EdgeInsets.fromLTRB(
          16, 16, 16, 100), // Padding bawah agar tidak tertutup nav bar
      itemCount: orders.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _buildOrderCard(orders[index]);
      },
    );
  }

  // Sisa kode (widget _buildOrderCard dan _buildCardFooter) di bawah ini tidak ada yang diubah sama sekali.
  Widget _buildOrderCard(Order order) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Pesanan Anda',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              Text(order.id,
                  style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    order.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => const Icon(
                        Icons.image_not_supported_outlined,
                        size: 50,
                        color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.productName,
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(order.quantity,
                        style: GoogleFonts.poppins(color: Colors.grey)),
                    if (order.status == OrderStatus.dibatalkan &&
                        order.price != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        NumberFormat.currency(
                                locale: 'id_ID',
                                symbol: 'Rp ',
                                decimalDigits: 0)
                            .format(order.price),
                        style: GoogleFonts.poppins(
                            color: const Color(0xFF859F3D),
                            fontWeight: FontWeight.bold),
                      ),
                    ]
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),
          _buildCardFooter(order),
        ],
      ),
    );
  }

  Widget _buildCardFooter(Order order) {
    switch (order.status) {
      case OrderStatus.diproses:
        return Row(
          children: [
            Expanded(
              child: Text(
                'Konfirmasi pesanan Anda segera setelah tiba.',
                style:
                    GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () {
                Provider.of<OrderProvider>(context, listen: false)
                    .markOrderAsShipped(order);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF859F3D),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Pesanan diterima',
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OrderTrackingPage()),
                );
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.all(10),
                side: BorderSide(color: Colors.grey[300]!),
              ),
              child: Image.asset('assets/images/gps_pesanan.png',
                  width: 20, height: 20),
            ),
          ],
        );
      case OrderStatus.terkirim:
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                'Beri ulasan untuk produk yang telah sampai.',
                style:
                    GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF859F3D)),
              child: Text('Tinggalkan ulasan',
                  style:
                      GoogleFonts.poppins(color: Colors.white, fontSize: 12)),
            ),
          ],
        );
      case OrderStatus.dibatalkan:
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                'Pesanan telah dibatalkan oleh Anda.',
                style:
                    GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF859F3D)),
              child: Text('Beli lagi',
                  style:
                      GoogleFonts.poppins(color: Colors.white, fontSize: 12)),
            ),
          ],
        );
    }
  }
}
