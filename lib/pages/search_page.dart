import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:terraserve_app/pages/models/product_model.dart';
import 'package:terraserve_app/pages/product_detail_page.dart';
import 'package:terraserve_app/pages/services/product_service.dart';
import 'package:terraserve_app/pages/widgets/product_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Product> _allProducts = [];
  List<Product> _searchedProducts = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchAllProducts();

    _searchController.addListener(() {
      _filterProductsByName(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchAllProducts() async {
    try {
      final products = await ProductService().getProducts();
      if (mounted) {
        setState(() {
          _allProducts = products;
          _searchedProducts = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      print('Error fetching all products for search: $e');
    }
  }

  void _filterProductsByName(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchedProducts = [];
      });
    } else {
      final filtered = _allProducts.where((product) {
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
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Cari produk apa saja...',
            hintStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF859F3D)))
          // ✅ PERUBAHAN: Body dibungkus SingleChildScrollView agar bisa di-scroll
          : SingleChildScrollView(
              child: _buildProductGrid(),
            ),
    );
  }

  // ✅ PERUBAHAN: Menggunakan layout Wrap seperti di Dashboard
  Widget _buildProductGrid() {
    if (_searchedProducts.isEmpty) {
      // Tampilkan pesan yang sesuai berdasarkan apakah pengguna sudah mengetik atau belum
      return Container(
        height: MediaQuery.of(context).size.height * 0.5,
        alignment: Alignment.center,
        child: Text(
          _searchController.text.isNotEmpty
              ? 'Produk "${_searchController.text}" tidak ditemukan'
              : 'Mulai ketik untuk mencari produk.',
          style: GoogleFonts.poppins(color: Colors.grey),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: _searchedProducts.map((product) {
          final screenWidth = MediaQuery.of(context).size.width;
          // Kalkulasi lebar item sama seperti di dashboard
          final itemWidth = (screenWidth - 16 - 16 - 16) / 2;
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(product: product),
                ),
              );
            },
            child: SizedBox(
              width: itemWidth,
              child: ProductCard(product: product),
            ),
          );
        }).toList(),
      ),
    );
  }
}