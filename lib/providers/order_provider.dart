// lib/providers/order_provider.dart

import 'package:flutter/material.dart';
import 'package:terraserve_app/pages/models/cart_item_model.dart';
import 'package:terraserve_app/pages/models/order_model.dart';

class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => _orders;

  // Fungsi untuk menambahkan pesanan baru dari item-item di keranjang
  void addOrderFromCart(List<CartItem> cartItems) {
    // Di aplikasi nyata, semua item dalam satu checkout biasanya punya satu ID pesanan grup
    // Di sini kita buat ID unik sederhana berdasarkan waktu
    String orderGroupId = 'ID${DateTime.now().millisecondsSinceEpoch}';

    for (var cartItem in cartItems) {
      _orders.insert(
        0, // Masukkan ke paling atas daftar
        Order(
          id: orderGroupId,
          productName: cartItem.product.name,
          quantity:
              '${cartItem.quantity} ${cartItem.product.unit ?? ''}', // contoh: "2 pcs", "1 kg"
          imageUrl: cartItem.product.galleries.first, // Ambil gambar pertama
          status: OrderStatus.diproses,
          price: cartItem.product.price * cartItem.quantity,
        ),
      );
    }

    notifyListeners(); // Beri tahu semua yang 'mendengarkan' bahwa ada data baru
  }

  // ===== FUNGSI BARU DITAMBAHKAN DI SINI =====
  // Fungsi untuk mengubah status pesanan dari 'diproses' menjadi 'terkirim'
  void markOrderAsShipped(Order orderToUpdate) {
    // Cari indeks dari pesanan yang mau diubah berdasarkan ID dan nama produk
    // Ini untuk memastikan kita mengubah item yang benar jika ada beberapa item dalam satu ID pesanan
    int index = _orders.indexWhere((order) =>
        order.id == orderToUpdate.id &&
        order.productName == orderToUpdate.productName);

    // Jika pesanan ditemukan di dalam daftar
    if (index != -1) {
      // Buat objek Order baru dengan data yang sama, tetapi statusnya diubah
      _orders[index] = Order(
        id: _orders[index].id,
        productName: _orders[index].productName,
        quantity: _orders[index].quantity,
        imageUrl: _orders[index].imageUrl,
        status: OrderStatus.terkirim, // <-- STATUS DIUBAH DI SINI
        price: _orders[index].price,
      );

      // Beri tahu UI untuk memperbarui tampilannya
      notifyListeners();
    }
  }
  // ===========================================
}
