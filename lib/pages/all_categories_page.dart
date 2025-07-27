import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:terraserve_app/pages/models/category_banner_model.dart';
import 'package:terraserve_app/pages/models/product_category_model.dart';
import 'package:terraserve_app/pages/services/category_banner_service.dart';
import 'package:terraserve_app/pages/services/product_category_service.dart';

// Helper untuk hex color
Color hexToColor(String code) {
  if (code.length == 7 && code.startsWith('#')) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
  return Colors.grey;
}

class AllCategoriesPage extends StatefulWidget {
  const AllCategoriesPage({super.key});

  @override
  State<AllCategoriesPage> createState() => _AllCategoriesPageState();
}

class _AllCategoriesPageState extends State<AllCategoriesPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

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
        print('Error fetching categories: $e');
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
        print('Error fetching banners: $e');
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
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              _buildPromoSlider(),
              const SizedBox(height: 0),
              _buildHandle(),
              const SizedBox(height: 0),
              Center(
                child: Text(
                  'Silakan pilih kategori',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              _isLoadingCategories
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF859F3D),
                      ),
                    )
                  : _buildCategoryGrid(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildPromoSlider() {
    if (_isLoadingBanners) {
      return Container(
        height: 150,
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
          height: 160,
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
                color: _currentPage == index
                    ? Colors.black
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSinglePromoBanner(CategoryBannerModel banner) {
    final Color mainTextColor = banner.titleTextColor != null
        ? hexToColor(banner.titleTextColor!)
        : Colors.black;

    final Color buttonBgColor = banner.buttonBackgroundColor != null
        ? hexToColor(banner.buttonBackgroundColor!)
        : Colors.white;

    final Color buttonTextColor = banner.buttonTextColor != null
        ? hexToColor(banner.buttonTextColor!)
        : Colors.black;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: hexToColor(banner.backgroundColor),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              right: 100,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16), // Padding disesuaikan
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      banner.title.replaceAll('\\n', '\n'),
                      style: GoogleFonts.poppins(
                        // ✅ STYLING: Disesuaikan menjadi medium-bold (w600)
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: mainTextColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      banner.description,
                      style: GoogleFonts.poppins(
                        // ✅ STYLING: Ukuran 16 dan tidak bold
                        fontSize: 12,
                        color: mainTextColor.withOpacity(0.85),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(), // Mendorong tombol ke bawah
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonBgColor,
                        foregroundColor: buttonTextColor,
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        banner.buttonText,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: SizedBox(
                width: 130,
                height: 155,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Image.network(
                    banner.imageUrl,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
            ),
          ],
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
                  child: (category.imageUrl ?? '').isEmpty
                      ? const Icon(Icons.category,
                          color: Colors.grey, size: 50)
                      : Image.network(
                          category.imageUrl!,
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
