// lib/pages/product_detail_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:terraserve_app/pages/cart_page.dart';
import 'package:terraserve_app/pages/farmer_profile_page.dart'; // ✅ 1. Impor halaman profil petani
import 'package:terraserve_app/pages/models/product_model.dart';
import 'package:terraserve_app/pages/services/cart_service.dart';
import 'package:terraserve_app/pages/services/favorite_service.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _selectedImageIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildProductInfo(),
                  const SizedBox(height: 24),
                  _buildDivider(),
                  const SizedBox(height: 24),
                  _buildSellerInfo(), // Widget ini sekarang bisa diklik
                  const SizedBox(height: 24),
                  _buildDivider(),
                  const SizedBox(height: 24),
                  _buildReviewsSection(),
                  const SizedBox(height: 24),
                  _buildSingleReview(),
                  const SizedBox(height: 24),
                  _buildViewAllReviewsButton(),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomSheet(),
    );
  }

  Widget _buildSliverAppBar() {
    final favoriteService = Provider.of<FavoriteService>(context);
    final bool isFavorited = favoriteService.isFavorite(widget.product.id);

    return SliverAppBar(
      expandedHeight: 300.0,
      backgroundColor: Colors.white,
      elevation: 0,
      pinned: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: Icon(
            isFavorited ? Icons.favorite : Icons.favorite_border,
            color: isFavorited ? Colors.red : Colors.black,
          ),
          onPressed: () {
            favoriteService.toggleFavorite(widget.product.id);
          },
        ),
        IconButton(
          icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartPage()),
            );
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _selectedImageIndex = index;
                  });
                },
                itemCount: widget.product.galleries.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    widget.product.galleries[index],
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
                  );
                },
              ),
            ),
            if (widget.product.galleries.length > 1)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(widget.product.galleries.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: _selectedImageIndex == index ? 24 : 8,
                      decoration: BoxDecoration(
                        color: _selectedImageIndex == index ? Colors.black : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  }),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.product.name,
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Rp${widget.product.price.toStringAsFixed(0)}',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF859F3D),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Detail Produk',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          widget.product.description?.replaceAll(RegExp(r'<[^>]*>'), '') ?? 'Tidak ada deskripsi untuk produk ini.',
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
        ),
      ],
    );
  }

  // ✅ 2. Bungkus widget dengan InkWell dan tambahkan navigasi
  Widget _buildSellerInfo() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FarmerProfilePage()),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage('assets/images/farmer.png'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.seller?.name ?? 'Petani Yanti',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Lampung Selatan',
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                // Logika untuk chat
              },
              icon: const Icon(Icons.chat_bubble_outline, color: Color(0xFF859F3D)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Penilaian & Ulasan',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(
                  '4.5/5',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Text(
                  '(105 Penilaian)',
                  style: GoogleFonts.poppins(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        const Icon(Icons.keyboard_arrow_down),
      ],
    );
  }

  Widget _buildSingleReview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pengalaman Belanja yang Luar Biasa!',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Saya baru pertama kali pakai app Terraserve, dan saya sangat terkesan...',
          style: GoogleFonts.poppins(color: Colors.grey[700]),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('assets/images/user_avatar.png'),
            ),
            const SizedBox(width: 8),
            Text(
              'Dexter, 29 Juli 2025',
              style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildViewAllReviewsButton() {
    return Center(
      child: TextButton(
        onPressed: () {},
        child: Text(
          'Lihat Semua 105 Ulasan',
          style: GoogleFonts.poppins(
            color: const Color(0xFF859F3D),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.grey[200], thickness: 1);
  }

  void _showVariantModalSheet(
    BuildContext context, {
    required String primaryActionText,
    VoidCallback? onPrimaryAction,
  }) {
    int selectedVariantIndex = 0;
    int selectedWeightIndex = 0;

    final List<Map<String, dynamic>> variants = [
      {'name': 'Bayam Hijau', 'icon': Icons.eco},
      {'name': 'Bayam Merah', 'icon': Icons.local_florist},
    ];
    final List<String> weights = ['100 gr', '250 gr', '500 gr', '1 kg'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Pilih Varian', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 16),
                  Text('Varian', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(variants.length, (index) {
                      bool isSelected = selectedVariantIndex == index;
                      return GestureDetector(
                        onTap: () => setModalState(() => selectedVariantIndex = index),
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFF0F4E8) : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: isSelected ? const Color(0xFF859F3D) : Colors.grey.shade300),
                          ),
                          child: Column(
                            children: [
                              Icon(variants[index]['icon'], size: 30),
                              const SizedBox(height: 4),
                              Text(variants[index]['name'], style: GoogleFonts.poppins(fontSize: 12)),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  Text('Berat', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: List.generate(weights.length, (index) {
                      bool isSelected = selectedWeightIndex == index;
                      return GestureDetector(
                        onTap: () => setModalState(() => selectedWeightIndex = index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF859F3D) : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            weights[index],
                            style: GoogleFonts.poppins(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.w500),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      final cartService = Provider.of<CartService>(context, listen: false);
                      cartService.addToCart(widget.product);
                      Navigator.of(context).pop();
                      
                      if (primaryActionText == 'Tambah ke Keranjang') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${widget.product.name} ditambahkan ke keranjang!'),
                            duration: const Duration(seconds: 1),
                            backgroundColor: const Color(0xFF859F3D),
                          ),
                        );
                      }
                      
                      onPrimaryAction?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF859F3D),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: Text(primaryActionText, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
          )
        ],
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF859F3D),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () {
                _showVariantModalSheet(
                  context,
                  primaryActionText: 'Tambah ke Keranjang',
                );
              },
              icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white), 
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                _showVariantModalSheet(
                  context,
                  primaryActionText: 'Beli Langsung',
                  onPrimaryAction: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CartPage()),
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF859F3D),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                'Beli Langsung Rp${widget.product.price.toStringAsFixed(0)}',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
