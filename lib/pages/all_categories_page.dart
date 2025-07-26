import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- DATA DUMMY UNTUK HALAMAN INI ---
final List<Map<String, String>> dummyAllCategories = [
  {'name': 'Padi & Beras', 'image': 'assets/images/beras_kategori.png'},
  {'name': 'Buah', 'image': 'assets/images/buah_kategori.png'},
  {'name': 'Sayuran Daun', 'image': 'assets/images/sayuran_daun.png'},
  {'name': 'Sayuran Buah', 'image': 'assets/images/sayuran_buah.png'},
  {'name': 'Daun Aromatik', 'image': 'assets/images/daun_aromatik.png'},
  {'name': 'Rempah', 'image': 'assets/images/rempah_kategori.png'},
  {'name': 'Umbi & Kacang', 'image': 'assets/images/umbi_kacang_kategori.png'},
  {'name': 'Cabai', 'image': 'assets/images/cabai_kategori.png'},
  {'name': 'Bawang', 'image': 'assets/images/bawang_kategori.png'},
  {'name': 'Kopi', 'image': 'assets/images/kopi_kategori.png'},
];
// --- END DATA DUMMY ---

class AllCategoriesPage extends StatefulWidget {
  const AllCategoriesPage({super.key});

  @override
  State<AllCategoriesPage> createState() => _AllCategoriesPageState();
}

class _AllCategoriesPageState extends State<AllCategoriesPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Widget> _promoBanners = [
    _buildSinglePromoBanner(),
    _buildSinglePromoBanner(), // Contoh banner ke-2
    _buildSinglePromoBanner(), // Contoh banner ke-3
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.hasClients && _pageController.page != null) {
        setState(() {
          _currentPage = _pageController.page!.round();
        });
      }
    });
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
            _buildHandle(),
            const SizedBox(height: 16),
            Text(
              'Silakan pilih kategori',
              style: GoogleFonts.poppins(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            _buildCategoryGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoSlider() {
    return Column(
      children: [
        SizedBox(
          height: 150, // Tinggi area banner disesuaikan
          child: PageView.builder(
            controller: _pageController,
            itemCount: _promoBanners.length,
            itemBuilder: (context, index) {
              return _promoBanners[index];
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_promoBanners.length, (index) {
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

  static Widget _buildSinglePromoBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFDEEDC), // Warna peach
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            // Konten Teks dan Tombol
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Nanas yang segar dan berair,',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: const Color(0xFFE58941), // Warna oranye tua
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ledakan rasa tropis dalam satu gigitan.',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFFF2A66A), // Warna oranye muda
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF31511E), // Warna hijau tua
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      ),
                      child: Text(
                        'Belanja Sekarang',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Gambar Nanas
            Positioned(
              right: -20,
              bottom: -10,
              child: Image.asset(
                'assets/images/nanas_banner.png',
                height: 140,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      width: 40,
      height: 5,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dummyAllCategories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        return _buildCategoryCard(
          dummyAllCategories[index]['name']!,
          dummyAllCategories[index]['image']!,
          index,
        );
      },
    );
  }

  Widget _buildCategoryCard(String name, String imagePath, int index) {
    final bool isLeftCard = index % 2 == 0;
    
    final String backgroundImage = isLeftCard
        ? 'assets/images/background_categories_left.png'
        : 'assets/images/background_categories_right.png';

    return InkWell(
      onTap: () {
        print('$name category clicked');
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
            child: Image.asset(
              backgroundImage,
              fit: BoxFit.fill,
            ),
          ),
          // ✅ PERUBAHAN: Membungkus Column dengan Center
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    name,
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
