import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';

// Pastikan file-file widget ini sudah ada di project kamu
import '../widgets/recommendation_list.dart';
import '../widgets/keyword_chips.dart';
import '../widgets/product_grid.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];

  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchAllProducts();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Fungsi untuk menangani event klik dari KeywordChips
  void setSearchKeyword(String keyword) {
    _searchController.text = keyword;
    // Kursor pindah ke akhir text agar nyaman diedit
    _searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: _searchController.text.length),
    );
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        // Jika kosong, tampilkan 6 produk default (misal: rekomendasi/populer)
        _filteredProducts = _allProducts.take(6).toList();
      } else {
        // Filter berdasarkan nama
        _filteredProducts = _allProducts
            .where((p) => p.name.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  Future<void> _fetchAllProducts() async {
    try {
      final products = await ProductService.fetchAllProducts();
      if (mounted) {
        setState(() {
          _allProducts = products;
          // Inisialisasi awal: ambil 6 produk pertama
          _filteredProducts = products.take(6).toList();
          _isLoading = false;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'Gagal memuat produk. Periksa koneksi internet.';
        });
        print('Error Fetching: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 20, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Temukan Produk',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          physics:
              const BouncingScrollPhysics(), // Efek scroll membal (iOS style)
          children: [
            // --- SEARCH BAR ---
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Cari produk',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: Colors.black54),
                  filled: true,
                  fillColor: const Color(
                      0xFFF5F5F5), // Warna abu-abu muda sesuai gambar
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // --- REKOMENDASI LIST (Horizontal) ---
            // Asumsi widget ini menampilkan list horizontal (Beras, Cabai, dll)
            const RecommendationListWidget(),

            const SizedBox(height: 24),

            // --- KATA KUNCI POPULER (Chips) ---
            const Text(
              'KATA KUNCI POPULER',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.black87,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            KeywordChipsWidget(onKeywordTap: setSearchKeyword),

            const SizedBox(height: 24),

            // --- GRID TITLE ---
            const Text(
              'Rekomendasi untuk Kamu',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),

            // --- PRODUCT GRID ---
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 40),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 40),
                      const SizedBox(height: 8),
                      Text(_error!, style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              )
            else
              ProductGridWidget(
                products: _filteredProducts,
                // PENTING: Rasio ini menentukan bentuk kartu.
                // 0.72 - 0.75 ideal untuk layout Vertikal (Gambar atas, Harga bawah)
                childAspectRatio: 0.72,
              ),

            // Jarak aman di bawah agar tidak kepotong
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
