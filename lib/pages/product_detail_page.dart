// lib/pages/product_detail_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:terraserve_app/pages/cart_page.dart';
import 'package:terraserve_app/pages/checkout_page.dart'; // ✅ Import CheckoutPage
import 'package:terraserve_app/pages/farmer_profile_page.dart';
import 'package:terraserve_app/pages/models/product_model.dart';
import 'package:terraserve_app/pages/reviews_page.dart';
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

  // Warna Hijau Utama
  final Color _primaryGreen = const Color(0xFF389841);

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
                  _buildSellerInfo(),
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

  // ... (Kode _buildSliverAppBar, _buildProductInfo, dll tetap sama) ...
  // Saya singkat bagian atas untuk fokus ke bagian yang Anda minta diubah.

  Widget _buildSliverAppBar() {
    final favoriteService = Provider.of<FavoriteService>(context);
    final bool isFavorited = favoriteService.isFavorite(widget.product.id);

    return SliverAppBar(
      expandedHeight: 350.0,
      backgroundColor: Colors.white,
      elevation: 0,
      pinned: true,
      leading: Container(
        margin: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5)
          ],
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 18, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5)
            ],
          ),
          child: IconButton(
            icon: Icon(
              isFavorited ? Icons.favorite : Icons.favorite_border,
              color: isFavorited ? Colors.red : _primaryGreen,
              size: 20,
            ),
            onPressed: () {
              favoriteService.toggleFavorite(widget.product.id);
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5)
            ],
          ),
          child: IconButton(
            icon: Icon(Icons.shopping_cart_outlined,
                size: 20, color: _primaryGreen),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedImageIndex = index;
                });
              },
              itemCount: widget.product.galleries.isNotEmpty
                  ? widget.product.galleries.length
                  : 1,
              itemBuilder: (context, index) {
                if (widget.product.galleries.isEmpty) {
                  return const Center(
                      child: Icon(Icons.image_not_supported,
                          size: 100, color: Colors.grey));
                }
                return Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Image.network(
                    widget.product.galleries[index],
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.image_not_supported,
                        size: 100,
                        color: Colors.grey),
                  ),
                );
              },
            ),
            if (widget.product.galleries.length > 1)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      List.generate(widget.product.galleries.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      height: 6,
                      width: _selectedImageIndex == index ? 20 : 6,
                      decoration: BoxDecoration(
                        color: _selectedImageIndex == index
                            ? _primaryGreen
                            : Colors.grey[300],
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
        Row(
          children: [
            _buildVariantThumbnail(
                widget.product.galleries.isNotEmpty
                    ? widget.product.galleries.first
                    : '',
                true),
            const SizedBox(width: 8),
            _buildVariantThumbnail(
                'https://via.placeholder.com/50/FF0000/FFFFFF?text=Red', false),
            const Spacer(),
            Text(
              '120 Terjual',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
            )
          ],
        ),
        const SizedBox(height: 16),
        Text(
          widget.product.name,
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Rp ${widget.product.price.toStringAsFixed(0)}',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Detail Produk',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          widget.product.description?.replaceAll(RegExp(r'<[^>]*>'), '') ??
              'Segar dan bergizi, bayam hijau & merah ini cocok untuk berbagai jenis masakan sehat sehari-hari.\n\nSetiap ikat dipetik langsung dari kebun lokal, bebas pestisida, dan dikemas dengan hati-hati untuk menjaga kesegarannya.',
          style: GoogleFonts.poppins(
              fontSize: 13, color: Colors.grey[600], height: 1.5),
        ),
      ],
    );
  }

  Widget _buildVariantThumbnail(String imageUrl, bool isSelected) {
    return Container(
      width: 50,
      height: 50,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? _primaryGreen : Colors.transparent,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) =>
              const Icon(Icons.image, size: 20, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildSellerInfo() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FarmerProfilePage()),
        );
      },
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/images/farmer.png'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.seller?.name ?? 'Petani Yanti',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 12),
                    Text(' 4.8',
                        style: GoogleFonts.poppins(
                            fontSize: 10, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 4),
                    Text('| 2 jam lalu',
                        style: GoogleFonts.poppins(
                            fontSize: 10, color: Colors.grey)),
                  ],
                ),
                Text(
                  'LAMPUNG SELATAN',
                  style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.chat_bubble_outline, color: _primaryGreen),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ReviewsPage()),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Penilaian & Ulasan',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildSingleReview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '4.5/5',
              style: GoogleFonts.poppins(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Penilaian',
                    style: GoogleFonts.poppins(
                        fontSize: 12, fontWeight: FontWeight.bold)),
                Text('105 Penilaian',
                    style:
                        GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
              ],
            )
          ],
        ),
        const SizedBox(height: 16),
        const Divider(height: 1),
        const SizedBox(height: 16),
        Text(
          'Pengalaman Belanja yang Luar Biasa!',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          'Saya baru pertama kali pakai app Terraserve, dan saya sangat terkesan dengan banyaknya pilihan produk yang tersedia, salah satu nya bayam segar ini topp👍👍👍👍👍',
          style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 13),
        ),
        const SizedBox(height: 8),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: NetworkImage(widget.product.galleries.isNotEmpty
                  ? widget.product.galleries.first
                  : ''),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(5,
              (index) => const Icon(Icons.star, color: Colors.amber, size: 16)),
        ),
        const SizedBox(height: 4),
        Text(
          'Dexter, 27 Juli 2025',
          style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildViewAllReviewsButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ReviewsPage()),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Lihat Semua 105 Ulasan',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.grey[200], thickness: 1, height: 1);
  }

  // --- POPUP VARIAN (MODAL) ---
  void _showVariantModalSheet(BuildContext context) {
    int selectedVariant = 0;
    int selectedWeight = 0;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Varian',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildVariantOption(
                        0,
                        'Bayam Hijau',
                        'https://via.placeholder.com/50/00FF00/FFFFFF?text=Hijau',
                        selectedVariant == 0,
                        (idx) => setState(() => selectedVariant = idx),
                      ),
                      const SizedBox(width: 16),
                      _buildVariantOption(
                        1,
                        'Bayam Merah',
                        'https://via.placeholder.com/50/FF0000/FFFFFF?text=Merah',
                        selectedVariant == 1,
                        (idx) => setState(() => selectedVariant = idx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Berat',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    children: [
                      _buildWeightOption(0, '100 gr', selectedWeight == 0,
                          (idx) => setState(() => selectedWeight = idx)),
                      _buildWeightOption(1, '250 gr', selectedWeight == 1,
                          (idx) => setState(() => selectedWeight = idx)),
                      _buildWeightOption(2, '500 gr', selectedWeight == 2,
                          (idx) => setState(() => selectedWeight = idx)),
                      _buildWeightOption(3, '1 Kg', selectedWeight == 3,
                          (idx) => setState(() => selectedWeight = idx)),
                    ],
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // 1. Tambahkan ke keranjang dulu agar ada datanya
                        final cartService =
                            Provider.of<CartService>(context, listen: false);
                        cartService.addToCart(widget.product);

                        // 2. Tutup Modal
                        Navigator.pop(context);

                        // 3. ✅ Navigasi Langsung ke CheckoutPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CheckoutPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Lanjut',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildVariantOption(int index, String label, String imageUrl,
      bool isSelected, Function(int) onTap) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? _primaryGreen : Colors.grey.shade300,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.network(
              imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => const Icon(Icons.image, size: 50),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: isSelected ? _primaryGreen : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightOption(
      int index, String label, bool isSelected, Function(int) onTap) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey.shade300 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  // --- BOTTOM SHEET ---
  Widget _buildBottomSheet() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: OutlinedButton(
              onPressed: () {
                final cartService =
                    Provider.of<CartService>(context, listen: false);
                cartService.addToCart(widget.product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        '${widget.product.name} ditambahkan ke keranjang!'),
                    backgroundColor: _primaryGreen,
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade400),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart_outlined,
                      color: Colors.black54, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'Keranjang',
                    style: GoogleFonts.poppins(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: () {
                _showVariantModalSheet(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryGreen,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_bag_outlined,
                      color: Colors.white, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'Beli Sekarang',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
