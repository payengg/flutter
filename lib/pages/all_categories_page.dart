import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:terraserve_app/pages/models/category_banner_model.dart';
import 'package:terraserve_app/pages/models/product_category_model.dart';
import 'package:terraserve_app/pages/services/category_banner_service.dart';
import 'package:terraserve_app/pages/services/product_category_service.dart';

// Helper function untuk mengubah Hex String menjadi Color
Color hexToColor(String code) {
  if (code.length == 7 && code.startsWith('#')) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
  return Colors.grey; // Fallback color
}

class AllCategoriesPage extends StatefulWidget {
  const AllCategoriesPage({super.key});

  @override
  State<AllCategoriesPage> createState() => _AllCategoriesPageState();
}

class _AllCategoriesPageState extends State<AllCategoriesPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // --- State untuk data dinamis ---
  List<ProductCategory> _categories = [];
  List<CategoryBannerModel> _banners = [];
  bool _isLoadingCategories = true;
  bool _isLoadingBanners = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _pageController.addListener(() {
      if (_pageController.hasClients && _pageController.page != null) {
        setState(() {
          _currentPage = _pageController.page!.round();
        });
      }
    });
  }

  Future<void> _fetchData() async {
    await Future.wait([_fetchCategories(), _fetchBanners()]);
  }

  Future<void> _fetchCategories() async {
    try {
      final result = await ProductCategoryService().getCategories();
      if (mounted) {
        setState(() {
          result.removeWhere((category) => category.name == 'All');
          _categories = result;
          _isLoadingCategories = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingCategories = false);
        print('Error fetching all categories: $e');
      }
    }
  }

  Future<void> _fetchBanners() async {
    try {
      final result = await CategoryBannerService().getBanners();
      if (mounted) {
        setState(() {
          _banners = result;
          _isLoadingBanners = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingBanners = false);
        print('Error fetching category banners: $e');
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
        title: Text(
          'Kategori',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildPromoSlider(),
            const SizedBox(height: 24),
            Text(
              'Silakan pilih kategori',
              style: GoogleFonts.poppins(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            _isLoadingCategories
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF859F3D)),
                  )
                : _buildCategoryGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoSlider() {
    if (_isLoadingBanners) {
      return Container(
        margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
      );
    }

    if (_banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(
          height: 150,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _banners.length,
            itemBuilder: (context, index) {
              return _buildSinglePromoBanner(_banners[index]);
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_banners.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: _currentPage == index ? 24 : 8,
              decoration: BoxDecoration(
                color: _currentPage == index ? Colors.black : Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSinglePromoBanner(CategoryBannerModel banner) {
    // Menentukan warna teks utama, dengan fallback ke warna putih.
    final Color mainTextColor = banner.titleTextColor != null
        ? hexToColor(banner.titleTextColor!)
        : Colors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(color: hexToColor(banner.backgroundColor)),
          child: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        banner.title.replaceAll('\\n', '\n'),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: mainTextColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        banner.description,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: mainTextColor.withOpacity(0.85),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: banner.buttonBackgroundColor != null
                              ? hexToColor(banner.buttonBackgroundColor!)
                              : Colors.white,
                          foregroundColor: banner.buttonTextColor != null
                              ? hexToColor(banner.buttonTextColor!)
                              : Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 24,
                          ),
                        ),
                        child: Text(
                          banner.buttonText,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: -10,
                bottom: -10,
                child: Image.network(
                  banner.imageUrl,
                  width: 117,
                  height: 138,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    print(
                      'Error loading banner image: ${banner.imageUrl}, Error: $error',
                    );
                    return const SizedBox(width: 117, height: 138);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        return _buildCategoryCard(_categories[index], index);
      },
    );
  }

  Widget _buildCategoryCard(ProductCategory category, int index) {
    final bool isLeftCard = index % 2 == 0;

    final String backgroundImage = isLeftCard
        ? 'assets/images/background_categories_left.png'
        : 'assets/images/background_categories_right.png';

    return InkWell(
      onTap: () {
        print('${category.name} category clicked');
      },
      customBorder: RoundedRectangleBorder(
        borderRadius: isLeftCard
            ? const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              )
            : const BorderRadius.only(
                topRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
              ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(backgroundImage, fit: BoxFit.fill),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  // --- ✅ PERUBAHAN DI SINI ---
                  child: (category.imageUrl ?? '').isEmpty
                      ? const Icon(Icons.category, color: Colors.grey, size: 50)
                      : Image.network(
                          category
                              .imageUrl!, // Menggunakan imageUrl, bukan iconUrl
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    category.name,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
