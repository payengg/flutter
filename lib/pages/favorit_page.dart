// lib/pages/favorit_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:terraserve_app/pages/models/product_model.dart';
import 'package:terraserve_app/pages/product_detail_page.dart';
import 'package:terraserve_app/pages/services/favorite_service.dart';
import 'package:terraserve_app/pages/services/product_service.dart';
import 'package:terraserve_app/pages/widgets/favorite_product_card.dart';

class FavoritPage extends StatefulWidget {
  // ✅ 1. Tambahkan controller di constructor
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
    final allProducts = await _productService.getProducts();
    return allProducts.where((product) => favoriteIds.contains(product.id)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteService>(
      builder: (context, favoriteService, child) {
        final favoriteProductIds = favoriteService.favoriteProductIds;

        return Scaffold(
          backgroundColor: const Color(0xFFF9F9F9),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Favorit',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  '${favoriteProductIds.length} Items',
                  style: GoogleFonts.poppins(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          body: FutureBuilder<List<Product>>(
            future: _fetchFavoriteProducts(favoriteProductIds),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF859F3D)));
              }
              if (snapshot.hasError) {
                return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    'Anda belum punya produk favorit.',
                    style: GoogleFonts.poppins(color: Colors.grey),
                  ),
                );
              }

              final favoriteProducts = snapshot.data!;

              return GridView.builder(
                // ✅ 2. Pasang controller di sini
                controller: widget.controller,
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.65,
                ),
                itemCount: favoriteProducts.length,
                itemBuilder: (context, index) {
                  final product = favoriteProducts[(favoriteProducts.length - 1) - index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProductDetailPage(product: product)),
                      );
                    },
                    child: FavoriteProductCard(product: product),
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