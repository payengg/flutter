// lib/pages/widgets/product_card.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:terraserve_app/pages/models/cart_item_model.dart';
import 'package:terraserve_app/pages/models/product_model.dart';
import 'package:terraserve_app/pages/services/cart_service.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);

    // Cek item di keranjang
    final itemInCart = cartService.items.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product, quantity: 0),
    );
    final quantity = itemInCart.quantity;

    // --- LOGIKA DISKON DARI BACKEND ---
    int discountPercent = product.discount ?? 0;
    bool hasDiscount = discountPercent > 0;

    double originalPrice = 0;
    if (hasDiscount) {
      originalPrice = product.price / ((100 - discountPercent) / 100);
    }

    // Helper untuk format rupiah biar kodenya rapi
    String formatRupiah(double price) {
      return price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- BAGIAN GAMBAR & BADGE ---
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    image: product.galleries.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(product.galleries.first),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: product.galleries.isEmpty
                      ? const Center(
                          child: Icon(Icons.image_not_supported,
                              color: Colors.grey),
                        )
                      : null,
                ),
              ),
              if (hasDiscount)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF94C57),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '$discountPercent%',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10, // Ukuran font badge disesuaikan
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // --- INFO PRODUK ---
          Padding(
            padding: const EdgeInsets.all(
                10.0), // Padding sedikit dikecilkan biar muat
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama Produk
                Text(
                  product.name,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 14), // Font nama 14
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 2),

                // Unit
                Text(
                  product.unit ?? '',
                  style: GoogleFonts.poppins(
                      color: Colors.grey[500], fontSize: 11), // Font unit 11
                ),

                const SizedBox(height: 6),

                // Baris Harga & Tombol Add
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // ✅ BAGIAN HARGA (Menggunakan Expanded & Wrap)
                    Expanded(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 4, // Jarak antar harga
                        runSpacing: 0, // Jarak antar baris jika turun ke bawah
                        children: [
                          // Harga Jual (Sekarang)
                          Text(
                            'Rp${formatRupiah(product.price)}',
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  14, // Ukuran font dikecilkan sedikit (16 -> 14)
                            ),
                          ),
                          // Harga Coret (Sebelahnya)
                          if (hasDiscount)
                            Text(
                              'Rp${formatRupiah(originalPrice)}',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFFF94C57),
                                fontSize:
                                    10, // Ukuran font dikecilkan (12 -> 10)
                                decoration: TextDecoration.lineThrough,
                                decorationColor: const Color(0xFFF94C57),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Tombol Tambah
                    quantity == 0
                        ? _buildAddButton(context, product)
                        : _buildQuantityControls(context, itemInCart),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context, Product product) {
    final cartService = Provider.of<CartService>(context, listen: false);
    return Container(
      height: 32, // Ukuran tombol diperkecil sedikit agar proporsional
      width: 32,
      decoration: BoxDecoration(
        color: const Color(0xFF389841).withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          cartService.addToCart(product);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${product.name} ditambahkan ke keranjang!'),
              duration: const Duration(seconds: 1),
              backgroundColor: const Color(0xFF389841),
            ),
          );
        },
        icon: const Icon(Icons.add, color: Color(0xFF389841), size: 20),
      ),
    );
  }

  Widget _buildQuantityControls(BuildContext context, CartItem item) {
    final cartService = Provider.of<CartService>(context, listen: false);
    return Row(
      children: [
        Container(
          height: 28,
          width: 28,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () => cartService.decrementQuantity(item),
            icon: const Icon(Icons.remove, color: Colors.grey, size: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Text(
            '${item.quantity}',
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        Container(
          height: 28,
          width: 28,
          decoration: BoxDecoration(
            color: const Color(0xFF389841).withOpacity(0.2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () => cartService.incrementQuantity(item),
            icon: const Icon(Icons.add, color: Color(0xFF389841), size: 16),
          ),
        ),
      ],
    );
  }
}
