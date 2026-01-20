import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:terraserve_app/pages/models/category_banner_model.dart';
import 'package:terraserve_app/pages/models/product_category_model.dart';
import 'package:terraserve_app/pages/services/category_banner_service.dart';
import 'package:terraserve_app/pages/services/product_category_service.dart';
import 'package:terraserve_app/pages/category_products_page.dart';

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
      final result = await ProductCategoryService().getAllCategories();
      if (mounted) {
        setState(() {
          _categories = result;
          _isLoadingCategories = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingCategories = false);
        debugPrint('Error fetching categories: $e');
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
        debugPrint('Error fetching banners: $e');
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
    // Menggunakan LayoutBuilder di level tertinggi body untuk constraints yang akurat
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
      // SafeArea penting agar konten bawah tidak tertutup gestur navigasi HP
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double horizontalPadding = constraints.maxWidth * 0.04;
            // Deteksi layar kecil
            final bool isSmallScreen = constraints.maxHeight < 650;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: isSmallScreen ? 12 : 24),

                    // Banner Section
                    _buildPromoSlider(constraints, isSmallScreen),

                    const SizedBox(height: 16),
                    _buildHandle(constraints),
                    const SizedBox(height: 16),

                    Center(
                      child: Text(
                        'Silakan pilih kategori',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Grid Section
                    _isLoadingCategories
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: CircularProgressIndicator(
                                color: Color(0xFF859F3D),
                              ),
                            ),
                          )
                        : _buildCategoryGrid(constraints),

                    // Bottom Padding
                    SizedBox(height: isSmallScreen ? 20 : 40),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHandle(BoxConstraints constraints) {
    return Center(
      child: Container(
        width: constraints.maxWidth * 0.12,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildPromoSlider(BoxConstraints constraints, bool isSmallScreen) {
    // Tinggi banner disesuaikan agar tidak terlalu besar di layar kecil
    final double bannerHeight = isSmallScreen ? 160 : 180;

    if (_isLoadingBanners) {
      return Container(
        height: bannerHeight,
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
          height: bannerHeight,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _banners.length,
            itemBuilder: (context, index) {
              return _buildSinglePromoBanner(
                  _banners[index], constraints, bannerHeight);
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

  Widget _buildSinglePromoBanner(
      CategoryBannerModel banner, BoxConstraints constraints, double height) {
    final Color mainTextColor = banner.titleTextColor != null
        ? hexToColor(banner.titleTextColor!)
        : Colors.black;

    final Color buttonBgColor = banner.buttonBackgroundColor != null
        ? hexToColor(banner.buttonBackgroundColor!)
        : Colors.white;

    final Color buttonTextColor = banner.buttonTextColor != null
        ? hexToColor(banner.buttonTextColor!)
        : Colors.black;

    // Lebar gambar banner (sekitar 35% lebar layar)
    final double bannerImageWidth = constraints.maxWidth * 0.35;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: height,
        decoration: BoxDecoration(color: hexToColor(banner.backgroundColor)),
        child: Stack(
          children: [
            // Konten Teks & Tombol (Kiri)
            Positioned.fill(
              right: bannerImageWidth, // Memberi ruang untuk gambar di kanan
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center Vertikal
                  children: [
                    // Menggunakan Flexible agar teks tidak error overflow
                    Flexible(
                      child: Text(
                        banner.title.replaceAll('\\n', '\n'),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: mainTextColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Flexible(
                      child: Text(
                        banner.description,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: mainTextColor.withOpacity(0.85),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 36, // Tinggi tombol fix
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonBgColor,
                          foregroundColor: buttonTextColor,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          banner.buttonText,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Gambar Banner (Kanan)
            Positioned(
              right: 0,
              bottom: 0,
              top: 0,
              width: bannerImageWidth,
              child: Padding(
                padding: const EdgeInsets.all(
                    8.0), // Padding agar gambar tidak nempel tepi
                child: Image.network(
                  banner.imageUrl,
                  fit: BoxFit.contain, // Contain agar gambar utuh
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(BoxConstraints constraints) {
    // Flatten categories logic
    List<Widget> categoryCards = [];
    for (var category in _categories) {
      if (category.subCategories.isNotEmpty) {
        for (var subCategory in category.subCategories) {
          categoryCards.add(
            _buildCategoryCard(
              name: subCategory.name,
              imageUrl: subCategory.imageUrl,
              index: categoryCards.length,
              constraints: constraints,
            ),
          );
        }
      } else {
        categoryCards.add(
          _buildCategoryCard(
            name: category.name,
            imageUrl: category.imageUrl ?? '',
            index: categoryCards.length,
            constraints: constraints,
          ),
        );
      }
    }

    final double gridPadding = constraints.maxWidth * 0.01;
    final double crossAxisSpacing = constraints.maxWidth * 0.04;
    final double mainAxisSpacing = 16.0;

    return GridView.builder(
      padding: EdgeInsets.all(gridPadding),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categoryCards.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: constraints.maxWidth > 500 ? 3 : 2,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        // Aspek rasio penting: Lebar / Tinggi.
        // 1.0 = Kotak sempurna. 0.9 = Sedikit lebih tinggi (memberi ruang teks).
        childAspectRatio: 0.95,
      ),
      itemBuilder: (context, index) {
        return categoryCards[index];
      },
    );
  }

  Widget _buildCategoryCard({
    required String name,
    required String imageUrl,
    required int index,
    required BoxConstraints constraints,
  }) {
    final bool isLeftCard = index % 2 == 0;
    // Menggunakan index grid untuk menentukan shape background
    final String backgroundImage = isLeftCard
        ? 'assets/images/background_categories_left.png'
        : 'assets/images/background_categories_right.png';

    // Ukuran icon dinamis
    final double iconSize = constraints.maxWidth * 0.15;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryProductsPage(categoryName: name),
          ),
        );
      },
      borderRadius: isLeftCard
          ? const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0))
          : const BorderRadius.only(
              topRight: Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0)),
      child: Container(
        decoration: BoxDecoration(
            // Tambahkan shadow tipis agar card lebih pop-up
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 3))
            ]),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: isLeftCard
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0))
                    : const BorderRadius.only(
                        topRight: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0)),
                child: Image.asset(backgroundImage, fit: BoxFit.fill),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon Area
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: SizedBox(
                        height: iconSize,
                        width: iconSize,
                        child: imageUrl.isEmpty
                            ? Icon(Icons.category,
                                color: Colors.grey, size: iconSize * 0.8)
                            : Image.network(
                                imageUrl,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.error, size: iconSize * 0.8),
                              ),
                      ),
                    ),
                  ),

                  // Text Area
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text(
                        name,
                        textAlign: TextAlign.center,
                        maxLines: 2, // Batasi 2 baris
                        overflow: TextOverflow
                            .ellipsis, // Titik-titik jika kepanjangan
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          height: 1.1, // Line height rapat
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
