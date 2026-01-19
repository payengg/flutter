// lib/pages/pesanan_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:terraserve_app/pages/models/order_model.dart';
import 'package:terraserve_app/providers/order_provider.dart';
import 'package:terraserve_app/pages/order_detail_page.dart';

class PesananPage extends StatefulWidget {
  final ScrollController? controller;
  // Callback untuk kembali ke Dashboard (MainPage Index 0)
  final VoidCallback? backToDashboard;

  const PesananPage({
    super.key,
    this.controller,
    this.backToDashboard,
  });

  @override
  State<PesananPage> createState() => _PesananPageState();
}

class _PesananPageState extends State<PesananPage> {
  int _selectedIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    // Filter Logic
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
        automaticallyImplyLeading: false,
        // ✅ PERBAIKAN LOGIKA TOMBOL BACK
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.black, size: 20),
          onPressed: () {
            // Prioritas 1: Jalankan fungsi kembali ke Dashboard (Pindah Tab)
            // Ini akan menjaga Navbar tetap ada karena hanya berpindah tab di MainPage
            if (widget.backToDashboard != null) {
              widget.backToDashboard!();
            }
            // Prioritas 2: Jika halaman ini tidak sengaja di-push (tanpa navbar), lakukan pop biasa
            else if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          'Pesanan',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          // Tab Status
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

          // List Pesanan
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
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
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
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo_no_pesanan.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada pesanan',
              style: GoogleFonts.poppins(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }
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

  Widget _buildOrderCard(Order order) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailPage(order: order),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pesanan Anda',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                Text(
                  order.id,
                  style: GoogleFonts.poppins(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      order.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => const Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.productName,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "500gr", // Dummy Berat
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _getStatusText(order.status),
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailPage(order: order),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF389841),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: Text(
                      'Lihat Detail',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.diproses:
        return 'Pesanan anda akan segera diproses.';
      case OrderStatus.dikemas:
        return 'Pesanan sedang dikemas oleh penjual.';
      case OrderStatus.terkirim:
        return 'Pesanan sedang dalam perjalanan.';
      case OrderStatus.selesai:
        return 'Pesanan telah diterima.';
      case OrderStatus.dibatalkan:
        return 'Pesanan telah dibatalkan.';
      default:
        return 'Status pesanan diperbarui.';
    }
  }
}
