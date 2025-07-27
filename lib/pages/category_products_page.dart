// lib/pages/category_products_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:terraserve_app/pages/models/product_model.dart';
import 'package:terraserve_app/pages/product_detail_page.dart';
import 'package:terraserve_app/pages/services/product_service.dart';
// ✅ 1. Import ProductCard dari file widget
import 'package:terraserve_app/pages/widgets/product_card.dart';

class CategoryProductsPage extends StatefulWidget {
  final String categoryName;

  const CategoryProductsPage({super.key, required this.categoryName});

  @override
  State<CategoryProductsPage> createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  List<Product> _products = [];
  List<Product> _searchedProducts = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProductsByCategory();

    _searchController.addListener(() {
      _filterProductsByName(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchProductsByCategory() async {
    try {
      final allProducts = await ProductService().getProducts();
      if (mounted) {
        setState(() {
          _products = allProducts
              .where((product) =>
                  product.category?.trim().toLowerCase() ==
                  widget.categoryName.trim().toLowerCase())
              .toList();
          _searchedProducts = List.from(_products);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        print('Error fetching products for category ${widget.categoryName}: $e');
      }
    }
  }

  void _filterProductsByName(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchedProducts = List.from(_products);
      });
    } else {
      final filtered = _products.where((product) {
        return product.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
      setState(() {
        _searchedProducts = filtered;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Cari di kategori ${widget.categoryName}...',
              hintStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
              suffixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF859F3D)))
          : _searchedProducts.isEmpty
              ? Center(
                  child: Text(
                    'Produk tidak ditemukan',
                    style: GoogleFonts.poppins(color: Colors.grey),
                  ),
                )
              : SingleChildScrollView(
                  child: _buildProductGrid(),
                ),
    );
  }

  Widget _buildProductGrid() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: _searchedProducts.map((product) {
          final screenWidth = MediaQuery.of(context).size.width;
          final itemWidth = (screenWidth - 16 - 16 - 16) / 2;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(product: product),
                ),
              );
            },
            child: SizedBox(
              width: itemWidth,
              // ✅ 2. Menggunakan ProductCard yang sudah terpusat
              child: ProductCard(product: product),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ✅ 3. PASTIKAN SELURUH KODE ProductCard DI BAWAH INI SUDAH DIHAPUS DARI FILE INI