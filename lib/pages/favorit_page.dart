// lib/pages/favorit_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:terraserve_app/pages/models/product_model.dart';
import 'package:terraserve_app/pages/product_detail_page.dart';
import 'package:terraserve_app/pages/services/favorite_service.dart';
import 'package:terraserve_app/pages/services/product_service.dart';

class FavoritPage extends StatefulWidget {
  final ScrollController? controller;
  const FavoritPage({super.key, this.controller});

  @override
  State<FavoritPage> createState() => _FavoritPageState();
}

class _FavoritPageState extends State<FavoritPage> {
  final ProductService _productService = ProductService();

  Future<List<Product>> _fetchFavoriteProducts(List<int> favoriteIds) async {
    if (favoriteIds.isEmpty) {
      return [];
    }
    // Pastikan getProducts() mengembalikan List<Product>
    final allProducts = await _productService.getProducts();

    // Filter produk berdasarkan ID yang ada di favoriteIds
    return allProducts
        .where((product) => favoriteIds.contains(product.id))
        .toList();
  }

  // Helper format rupiah
  String _formatCurrency(num price) {
    return "Rp${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteService>(
      builder: (context, favoriteService, child) {
        final favoriteProductIds = favoriteService.favoriteProductIds;

        return Scaffold(
          backgroundColor: const Color(0xFFF9F9F9),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF9F9F9),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  size: 20, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            centerTitle: true,
            title: Text(
              'Favorit',
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            // Teks "X Items" DIHAPUS sesuai permintaan
          ),
          body: FutureBuilder<List<Product>>(
            future: _fetchFavoriteProducts(favoriteProductIds),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF389841)));
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              // --- TAMPILAN JIKA KOSONG (SESUAI GAMBAR) ---
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon Hati Besar
                        Icon(Icons.favorite_border_rounded,
                            size: 80, color: Colors.grey.shade400),
                        const SizedBox(height: 24),

                        // Judul Tebal
                        Text(
                          'Tidak ada item tersimpan!',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.w700, // Bold
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Deskripsi Abu-abu
                        Text(
                          'Anda tidak memiliki item tersimpan. Buka beranda dan tambahkan beberapa item.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontSize: 14,
                            height: 1.5, // Spasi antar baris
                          ),
                        ),
                        const SizedBox(
                            height: 50), // Spacer bawah agar agak naik sedikit
                      ],
                    ),
                  ),
                );
              }

              final favoriteProducts = snapshot.data!;

              return GridView.builder(
                controller: widget.controller,
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.62,
                ),
                itemCount: favoriteProducts.length,
                itemBuilder: (context, index) {
                  final product = favoriteProducts[index];

                  // Ambil data dengan aman dari model
                  String productImage = product.imageUrl;
                  String productName = product.name;
                  dynamic productPrice = product.price;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailPage(product: product)),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
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
                          // --- GAMBAR & LOVE ---
                          Stack(
                            children: [
                              Container(
                                height: 130,
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(16)),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    productImage,
                                    fit: BoxFit.contain,
                                    errorBuilder: (c, e, s) => const Icon(
                                        Icons.image_not_supported,
                                        color: Colors.grey),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: InkWell(
                                  onTap: () {
                                    Provider.of<FavoriteService>(context,
                                            listen: false)
                                        .toggleFavorite(product.id);
                                  },
                                  child: const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // --- INFO PRODUK ---
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatCurrency(productPrice),
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.star_rounded,
                                        color: Colors.amber, size: 18),
                                    const SizedBox(width: 4),
                                    Text(
                                      "${product.rating}",
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      " (120)",
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
