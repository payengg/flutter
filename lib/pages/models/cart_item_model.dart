// lib/pages/models/cart_item_model.dart

import 'package:terraserve_app/pages/models/product_model.dart';

class CartItem {
  final Product product;
  int quantity;
  bool isSelected; // ✅ Tambahkan properti ini

  // ✅ Set isSelected menjadi true secara default saat item ditambahkan
  CartItem({required this.product, this.quantity = 1, this.isSelected = true});
}