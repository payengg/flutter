// lib/pages/services/cart_service.dart

import 'package:flutter/material.dart';
import 'package:terraserve_app/pages/models/cart_item_model.dart';
import 'package:terraserve_app/pages/models/product_model.dart';

class CartService with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;
  int get itemCount => _items.length;

  // ✅ Total harga sekarang hanya menghitung item yang dipilih
  double get totalPrice {
    double total = 0.0;
    for (var item in _items) {
      if (item.isSelected) {
        total += item.product.price * item.quantity;
      }
    }
    return total;
  }

  // ✅ Fungsi untuk mengecek apakah semua item terpilih
  bool get areAllItemsSelected {
    if (_items.isEmpty) return false;
    return _items.every((item) => item.isSelected);
  }

  // ✅ Fungsi baru untuk mengubah status seleksi item
  void toggleItemSelected(CartItem item) {
    item.isSelected = !item.isSelected;
    notifyListeners();
  }

  // ✅ Fungsi baru untuk memilih/membatalkan semua item
  void toggleSelectAll(bool select) {
    for (var item in _items) {
      item.isSelected = select;
    }
    notifyListeners();
  }

  void addToCart(Product product) {
    for (var item in _items) {
      if (item.product.id == product.id) {
        item.quantity++;
        notifyListeners();
        return;
      }
    }
    _items.add(CartItem(product: product)); // isSelected otomatis true
    notifyListeners();
  }

  void removeFromCart(CartItem cartItem) {
    _items.remove(cartItem);
    notifyListeners();
  }

  void incrementQuantity(CartItem cartItem) {
    cartItem.quantity++;
    notifyListeners();
  }

  void decrementQuantity(CartItem cartItem) {
    if (cartItem.quantity > 1) {
      cartItem.quantity--;
    } else {
      removeFromCart(cartItem);
    }
    notifyListeners();
  }
}