import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:terraserve_app/pages/cart_page.dart';
import 'package:terraserve_app/pages/models/banner_model.dart';
import 'package:terraserve_app/pages/models/product_category_model.dart';
import 'package:terraserve_app/pages/models/product_model.dart';
import 'package:terraserve_app/pages/product_detail_page.dart';
import 'package:terraserve_app/pages/search_page.dart';
import 'package:terraserve_app/pages/services/banner_service.dart';
import 'package:terraserve_app/pages/services/product_category_service.dart';
import 'package:terraserve_app/pages/services/product_service.dart';
import 'package:terraserve_app/pages/all_categories_page.dart';
import 'package:terraserve_app/pages/widgets/product_card.dart';
import 'package:terraserve_app/pages/models/user.dart';

Color hexToColor(String code) {
  if (code.length == 7 && code.startsWith('#')) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
  return Colors.grey;
}

class DashboardPages extends StatefulWidget {
  final User user;
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

  void _filterProducts(String parentCategoryName) {
    setState(() {
      _selectedCategory = parentCategoryName;

      if (parentCategoryName == 'All') {
        _filteredProducts = List.from(_products);
        return;
      }

      final selectedParentCategory = _categories.firstWhere(
        (cat) => cat.name == parentCategoryName,
        orElse: () => ProductCategory(id: -1, name: '', subCategories: []),
      );

      final subCategoryNames =
          selectedParentCategory.subCategories.map((sub) => sub.name).toList();

      _filteredProducts = _products.where((product) {
        return product.category == parentCategoryName ||
            subCategoryNames.contains(product.category);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    // ✅ PERBAIKAN: Hapus widget Scaffold yang tidak perlu.
    // Sekarang, halaman ini hanya mengembalikan konten yang akan
    // ditempatkan di dalam Scaffold dari MainPage.
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartPage()),
                );
              },
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
        padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
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
      padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
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
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchPage()),
          );
        },
        child: AbsorbPointer(
          child: TextField(
            enabled: false,
            decoration: InputDecoration(
              hintText: 'Cari sayur, buah, atau lainnya...',
              hintStyle: GoogleFonts.poppins(color: Colors.grey),
              suffixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
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
        width: 85,
        margin: const EdgeInsets.only(right: 8.0),
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
            Flexible(
              child: Text(
                category.name,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? const Color(0xFF859F3D) : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
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
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailPage(product: product),
                  ),
                );
              },
              child: ProductCard(product: product),
            ),
          );
        }).toList(),
      ),
    );
  }
}
