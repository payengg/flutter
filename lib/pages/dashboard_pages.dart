import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:terraserve_app/pages/models/banner_model.dart';
import 'package:terraserve_app/pages/models/product_category_model.dart';
import 'package:terraserve_app/pages/models/product_model.dart';
import 'package:terraserve_app/pages/services/banner_service.dart';
import 'package:terraserve_app/pages/services/product_category_service.dart';
import 'package:terraserve_app/pages/services/product_service.dart';
import 'package:terraserve_app/pages/all_categories_page.dart';

// ✅ FUNGSI YANG HILANG DITAMBAHKAN DI SINI
Color hexToColor(String code) {
  if (code.length == 7 && code.startsWith('#')) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
  return Colors.grey; // Fallback color
}

class DashboardPages extends StatefulWidget {
  final Map<String, dynamic> user;
  final ScrollController? controller;

  const DashboardPages({super.key, required this.user, this.controller});

  @override
  State<DashboardPages> createState() => _DashboardPagesState();
}

class _DashboardPagesState extends State<DashboardPages> {
  String _selectedCategory = 'All';

  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  List<ProductCategory> _categories = [];
  List<BannerModel> _banners = [];

  bool _isProductsLoading = true;
  bool _isCategoriesLoading = true;
  bool _isBannersLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await Future.wait([fetchProducts(), fetchCategories(), fetchBanners()]);
  }

  Future<void> fetchProducts() async {
    try {
      final result = await ProductService().getProducts();
      if (mounted) {
        setState(() {
          _products = result;
          _filteredProducts = result;
          _isProductsLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isProductsLoading = false);
      print('Error fetching products: $e');
    }
  }

  Future<void> fetchCategories() async {
    setState(() {
      _isCategoriesLoading = true;
    });
    try {
      // ✅ Panggil fungsi yang benar untuk dashboard
      final result = await ProductCategoryService().getCategoriesForDashboard();
      if (mounted) {
        setState(() {
          _categories = result;
          _isCategoriesLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCategoriesLoading = false;
        });
        print('Error fetching categories: $e');
      }
    }
  }

  Future<void> fetchBanners() async {
    try {
      final result = await BannerService().getBanners();
      if (mounted) {
        setState(() {
          _banners = result;
          _isBannersLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isBannersLoading = false);
      print('Error fetching banners: $e');
    }
  }

  void _filterProducts(String categoryName) {
    setState(() {
      _selectedCategory = categoryName;
      if (categoryName == 'All') {
        _filteredProducts = List.from(_products);
      } else {
        _filteredProducts = _products
            .where((product) => product.category == categoryName)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      controller: widget.controller,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: screenHeight > 700 ? screenHeight + 1 : 701,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildPromoBanner(),
            _buildSearchBar(),
            _buildCategorySection(),
            _isProductsLoading
                ? const Center(
                    heightFactor: 5,
                    child: CircularProgressIndicator(color: Color(0xFF859F3D)),
                  )
                : _buildProductGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 70, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dikirim ke',
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Color(0xFF859F3D),
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Dexter\'s Home',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.black),
                ],
              ),
            ],
          ),
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {},
              icon: Image.asset('assets/images/shopping_bag.png', height: 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    if (_isBannersLoading) {
      return Padding(
        padding: const EdgeInsets.only(
          top: 30.0,
          left: 16.0,
          right: 16.0,
          bottom: 16.0,
        ),
        child: Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
    }

    if (_banners.isEmpty) {
      return const SizedBox.shrink();
    }

    final banner = _banners.first;

    BoxDecoration bannerDecoration;
    if (banner.gradientEndColor == null) {
      bannerDecoration = BoxDecoration(
        color: hexToColor(banner.gradientStartColor),
        borderRadius: BorderRadius.circular(20),
      );
    } else {
      List<Color> gradientColors = [
        hexToColor(banner.gradientStartColor),
        if (banner.gradientMiddleColor != null)
          hexToColor(banner.gradientMiddleColor!),
        hexToColor(banner.gradientEndColor!),
      ];
      bannerDecoration = BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
        borderRadius: BorderRadius.circular(20),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(
        top: 30.0,
        left: 16.0,
        right: 16.0,
        bottom: 16.0,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            height: 150,
            width: double.infinity,
            decoration: bannerDecoration,
            child: Padding(
              padding: const EdgeInsets.only(left: 24, top: 20, right: 140),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    banner.title.replaceAll('\\n', '\n'),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.white.withOpacity(0.25),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: Colors.white, width: 1.5),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: Text(
                      banner.description,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          Positioned(
            right: 5,
            top: -60,
            child: Image.network(
              banner.imageUrl,
              height: 210,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return SizedBox(
                  height: 210,
                  width: 150,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox(height: 210, width: 150),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Cari sayur, buah, atau lainnya...',
          hintStyle: GoogleFonts.poppins(color: Colors.grey),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kategori',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllCategoriesPage(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      'Lihat semua',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF31511E),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF61AD4E),
                      size: 17,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 110,
            child: _isCategoriesLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF859F3D)),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      return _buildCategoryItem(_categories[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(ProductCategory category) {
    final bool isSelected = category.name == _selectedCategory;
    return GestureDetector(
      onTap: () => _filterProducts(category.name),
      child: Container(
        width: 75,
        margin: const EdgeInsets.only(right: 8.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 70,
                width: 70,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F4E8),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: (category.iconUrl ?? '').isEmpty
                    ? const Icon(Icons.category, color: Colors.grey)
                    : category.id == 0
                    ? Image.asset(category.iconUrl!)
                    : Image.network(
                        category.iconUrl!,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error, color: Colors.red),
                      ),
              ),
              const SizedBox(height: 8),
              Text(
                category.name,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w600,
                  color: isSelected ? const Color(0xFF859F3D) : Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
    if (_filteredProducts.isEmpty) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(50),
        child: Text(
          'Produk tidak ditemukan',
          style: GoogleFonts.poppins(color: Colors.grey),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: _filteredProducts.map((product) {
          final screenWidth = MediaQuery.of(context).size.width;
          final itemWidth = (screenWidth - 16 - 16 - 16) / 2;
          return SizedBox(
            width: itemWidth,
            child: ProductCard(product: product),
          );
        }).toList(),
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int _quantity = 0;

  void _increment() => setState(() => _quantity++);
  void _decrement() => setState(() {
    if (_quantity > 0) _quantity--;
  });

  @override
  Widget build(BuildContext context) {
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
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                image: widget.product.galleries.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(widget.product.galleries.first),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: widget.product.galleries.isEmpty
                  ? const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    )
                  : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.product.unit ?? '',
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        'Rp ${widget.product.price.toStringAsFixed(0)}',
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _quantity == 0
                        ? _buildAddButton()
                        : _buildQuantityControls(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4E8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: _increment,
        icon: Image.asset('assets/images/icon_tambah.png', height: 16),
      ),
    );
  }

  Widget _buildQuantityControls() {
    return Row(
      children: [
        Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: _decrement,
            icon: Image.asset('assets/images/icon_minus.png', height: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            '$_quantity',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F4E8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: _increment,
            icon: Image.asset('assets/images/icon_tambah.png', height: 16),
          ),
        ),
      ],
    );
  }
}
