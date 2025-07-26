import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- DATA DUMMY ---
final List<Map<String, String>> dummyCategories = [
  {'name': 'All', 'icon': 'assets/images/semua.png'},
  {'name': 'Beras', 'icon': 'assets/images/beras.png'},
  {'name': 'Buah', 'icon': 'assets/images/buah.png'},
  {'name': 'Sayuran', 'icon': 'assets/images/sayuran.png'},
  {'name': 'Umbi', 'icon': 'assets/images/umbi.png'},
  {'name': 'Rempah', 'icon': 'assets/images/rempah.png'},
];

final List<Map<String, dynamic>> dummyProducts = [
  {
    'name': 'Wortel Organik',
    'price': 'Rp12.500',
    'unit': '80-100gr /ikat',
    'image': 'assets/images/wortel.png',
    'discount': null,
    'category': 'Sayuran',
  },
  {
    'name': 'Strawberry',
    'price': 'Rp35.000',
    'unit': '250gr /paket',
    'image': 'assets/images/strawberry.png',
    'discount': '50%',
    'category': 'Buah',
  },
  {
    'name': 'Kangkung',
    'price': 'Rp9.000',
    'unit': '200gr /ikat',
    'image': 'assets/images/kangkung.png',
    'discount': null,
    'category': 'Sayuran',
  },
  {
    'name': 'Tomat',
    'price': 'Rp5.000',
    'unit': '250gr /paket',
    'image': 'assets/images/tomat.png',
    'discount': '10%',
    'category': 'Sayuran',
  },
  {
    'name': 'Beras Mantap',
    'price': 'Rp68.000',
    'unit': '5kg /karung',
    'image': 'assets/images/beras_putih.png',
    'discount': null,
    'category': 'Beras',
  },
  {
    'name': 'Beras Ketan',
    'price': 'Rp68.000',
    'unit': '5kg /karung',
    'image': 'assets/images/beras_ketan.png',
    'discount': null,
    'category': 'Beras',
  },
  {
    'name': 'Umbi Produk',
    'price': 'Rp68.000',
    'unit': '5kg /karung',
    'image': 'assets/images/umbiproduk.png',
    'discount': null,
    'category': 'Umbi',
  },
  {
    'name': 'Singkong',
    'price': 'Rp68.000',
    'unit': '5kg /karung',
    'image': 'assets/images/singkong.png',
    'discount': null,
    'category': 'Umbi',
  },
  {
    'name': 'Kentank',
    'price': 'Rp68.000',
    'unit': '5kg /karung',
    'image': 'assets/images/kentank.png',
    'discount': null,
    'category': 'Umbi',
  },
  {
    'name': 'Umbi Jalar',
    'price': 'Rp68.000',
    'unit': '5kg /karung',
    'image': 'assets/images/umbi_jalar.png',
    'discount': null,
    'category': 'Umbi',
  },
  {
    'name': 'Pisang',
    'price': 'Rp28.000',
    'unit': '1kg /pak',
    'image': 'assets/images/pisang.png',
    'discount': null,
    'category': 'Buah',
  },
  {
    'name': 'Serai',
    'price': 'Rp28.000',
    'unit': '1kg /pak',
    'image': 'assets/images/serai.png',
    'discount': null,
    'category': 'Rempah',
  },
  {
    'name': 'Cengkeh',
    'price': 'Rp28.000',
    'unit': '1kg /pak',
    'image': 'assets/images/cengkeh.png',
    'discount': null,
    'category': 'Rempah',
  },
  {
    'name': 'Kayu Manis',
    'price': 'Rp28.000',
    'unit': '1kg /pak',
    'image': 'assets/images/kayu_manis.png',
    'discount': null,
    'category': 'Rempah',
  },
  {
    'name': 'Ketumbar',
    'price': 'Rp28.000',
    'unit': '1kg /pak',
    'image': 'assets/images/ketumbar.png',
    'discount': null,
    'category': 'Rempah',
  },
];
// --- END DATA DUMMY ---

class DashboardPages extends StatefulWidget {
  final Map<String, dynamic> user;
  final ScrollController? controller;

  const DashboardPages({super.key, required this.user, this.controller});

  @override
  State<DashboardPages> createState() => _DashboardPagesState();
}

class _DashboardPagesState extends State<DashboardPages> {
  String _selectedCategory = 'All';
  List<Map<String, dynamic>> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _filteredProducts = List.from(dummyProducts);
  }

  void _filterProducts(String category) {
    setState(() {
      _selectedCategory = category;
      if (category == 'All') {
        _filteredProducts = List.from(dummyProducts);
      } else {
        _filteredProducts = dummyProducts
            .where((product) => product['category'] == category)
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
            _buildProductGrid(),
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
              Text('Dikirim ke', style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 12)),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on, color: Color(0xFF859F3D), size: 18),
                  const SizedBox(width: 4),
                  Text('Dexter\'s Home', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14)),
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
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 5)],
            ),
            child: IconButton(
              onPressed: () {},
              icon: Image.asset('assets/images/shopping_bag.png', height: 22),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0, bottom: 16.0),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(color: const Color(0xFF859F3D), borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.only(left: 24, top: 20, right: 140),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Belanja Lebih Cerdas,\nHemat Lebih Banyak!', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800, height: 1.2)),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.white.withOpacity(0.25),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Colors.white, width: 1.5)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: Text('Diskon 40%', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          Positioned(
            right: 5,
            top: -60,
            child: Image.asset('assets/images/banner.png', height: 210, fit: BoxFit.contain),
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
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
              Text('Kategori', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Text('Lihat semua', style: GoogleFonts.poppins(color: const Color(0xFF31511E), fontWeight: FontWeight.w500)),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward_ios, color: Color(0xFF61AD4E), size: 17),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dummyCategories.length,
              itemBuilder: (context, index) {
                return _buildCategoryItem(dummyCategories[index]['name']!);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String name) {
    final bool isSelected = name == _selectedCategory;
    final String iconPath = dummyCategories.firstWhere((cat) => cat['name'] == name)['icon']!;
    return GestureDetector(
      onTap: () => _filterProducts(name),
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
                decoration: BoxDecoration(color: const Color(0xFFF0F4E8), borderRadius: BorderRadius.circular(15)),
                child: Image.asset(iconPath, errorBuilder: (context, error, stackTrace) => const Icon(Icons.error)),
              ),
              const SizedBox(height: 8),
              Text(
                name,
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
        child: Text('Produk tidak ditemukan', style: GoogleFonts.poppins(color: Colors.grey)),
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
  final Map<String, dynamic> product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int _quantity = 0;

  void _increment() {
    setState(() {
      _quantity++;
    });
  }

  void _decrement() {
    setState(() {
      if (_quantity > 0) {
        _quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                image: DecorationImage(
                  image: AssetImage(widget.product['image'] ?? 'assets/images/placeholder.png'),
                  fit: BoxFit.cover,
                  onError: (e, s) => const Icon(Icons.image_not_supported),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product['name'] ?? 'Nama Produk',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.product['unit'] ?? '',
                  style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        widget.product['price'] ?? 'Rp0',
                        style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
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
      decoration: BoxDecoration(color: const Color(0xFFF0F4E8), borderRadius: BorderRadius.circular(8)),
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
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14),
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
