import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- DATA DUMMY (Telah disesuaikan dengan gambar dan kategori) ---
// ✅ PERUBAHAN: Urutan dan nama disesuaikan dengan Figma
final List<Map<String, String>> dummyCategories = [
  {'name': 'All', 'icon': 'assets/images/semua.png'},
  {'name': 'Beras', 'icon': 'assets/images/beras.png'},
  {'name': 'Buah', 'icon': 'assets/images/buah.png'},
  {'name': 'Sayuran', 'icon': 'assets/images/sayuran.png'},
  {'name': 'Umbi', 'icon': 'assets/images/umbi.png'},
  {'name': 'Rempah', 'icon': 'assets/images/rempah.png'},
];

// Menambahkan key 'category' pada setiap produk untuk filtering
final List<Map<String, dynamic>> dummyProducts = [
  {
    'name': 'Wortel Organik',
    'price': 'Rp 12.500',
    'unit': '/ kg',
    'image': 'assets/images/wortel.png',
    'discount': null,
    'category': 'Sayuran',
  },
  {
    'name': 'Strawberry Premium',
    'price': 'Rp 35.000',
    'unit': '/ pack',
    'image': 'assets/images/strawberry.png',
    'discount': '50%',
    'category': 'Buah',
  },
  {
    'name': 'Kangkung',
    'price': 'Rp 9.000',
    'unit': '/ 500gr',
    'image': 'assets/images/kangkung.png',
    'discount': null,
    'category': 'Sayuran',
  },
  {
    'name': 'Tomat',
    'price': 'Rp 5.000',
    'unit': '/ 250gr',
    'image': 'assets/images/tomat.png',
    'discount': '10%',
    'category': 'Sayuran',
  },
  {
    'name': 'Beras Pandan Wangi',
    'price': 'Rp 68.000',
    'unit': '/ 5kg',
    'image': 'assets/images/beras.png', // Ganti dengan gambar produk beras
    'discount': null,
    'category': 'Beras',
  },
  {
    'name': 'Apel Fuji',
    'price': 'Rp 28.000',
    'unit': '/ kg',
    'image': 'assets/images/buah.png', // Ganti dengan gambar produk apel
    'discount': null,
    'category': 'Buah',
  },
];
// --- END OF DATA DUMMY ---

// Diubah menjadi StatefulWidget untuk mengelola state kategori
class DashboardPages extends StatefulWidget {
  final Map<String, dynamic> user;
  const DashboardPages({super.key, required this.user});

  @override
  State<DashboardPages> createState() => _DashboardPagesState();
}

class _DashboardPagesState extends State<DashboardPages> {
  // ✅ PERUBAHAN: State awal diubah ke "All"
  String _selectedCategory = 'All';
  // State untuk menyimpan daftar produk yang sudah difilter
  List<Map<String, dynamic>> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    // Saat halaman pertama kali dimuat, tampilkan semua produk
    _filteredProducts = List.from(dummyProducts);
  }

  // Fungsi untuk memfilter produk berdasarkan kategori yang dipilih
  void _filterProducts(String category) {
    setState(() {
      _selectedCategory = category;
      // ✅ PERUBAHAN: Kondisi diubah ke "All"
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildPromoBanner(),
          _buildSearchBar(),
          _buildCategorySection(),
          _buildProductGrid(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // WIDGET HEADER (Telah Diperbarui)
  Widget _buildHeader() {
    return Padding(
      // Mengatur jarak dari tepi layar sesuai keinginan Anda
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
                  const Icon(Icons.location_on, color: Color(0xFF859F3D), size: 18),
                  const SizedBox(width: 4),
                  Text(
                    'Dexter\'s Home', // Ganti dengan data alamat user
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
          // Ikon Keranjang Belanja
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
                )
              ]
            ),
            child: IconButton(
              onPressed: () {
                // TODO: Navigasi ke halaman keranjang
              },
              // ✅ PERBAIKAN: Nama file aset dengan spasi diubah menjadi underscore
              // Pastikan nama file Anda 'shopping_bag.png'
              icon: Image.asset('assets/images/shopping bag.png', height: 22),
            ),
          )
        ],
      ),
    );
  }

  // WIDGET PROMO BANNER (Telah Diperbarui)
  Widget _buildPromoBanner() {
    return Padding(
      // Mengatur jarak banner
      padding: const EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0, bottom: 16.0),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // 1. Container hijau sebagai latar belakang
          Container(
            height: 150, // Atur tinggi banner
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF859F3D),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 24, top: 20, right: 140),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Belanja Lebih Cerdas,\nHemat Lebih Banyak!',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16, // Ukuran font sesuai keinginan Anda
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
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                    ),
                    child: Text(
                      'Diskon 40%',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          // 2. Gambar petani yang diposisikan di kanan atas
          Positioned(
            right: 5,
            top: -60, // Posisi atas sesuai keinginan Anda
            child: Image.asset(
              'assets/images/banner.png',
              height: 210, // Tinggi gambar sesuai keinginan Anda
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET SEARCH BAR
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

  // WIDGET BAGIAN KATEGORI (Telah Diperbarui)
  Widget _buildCategorySection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Kategori',
                  style: GoogleFonts.poppins(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              // Menggunakan InkWell agar area klik lebih luas
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Text(
                      'Lihat semua', // Teks diubah
                      style: GoogleFonts.poppins(
                          color: const Color(0xFF31511E), // Warna diubah
                          fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward_ios, color: Color(0xFF61AD4E), size: 17), // Ikon panah
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20), // Jarak ke bawah ditambah
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

  // ✅ WIDGET UNTUK SATU ITEM KATEGORI (Telah Diperbarui)
  Widget _buildCategoryItem(String name) {
    final bool isSelected = name == _selectedCategory;
    final String iconPath = dummyCategories.firstWhere((cat) => cat['name'] == name)['icon']!;

    return GestureDetector(
      onTap: () => _filterProducts(name),
      child: Container(
        width: 75,
        // 👇 STYLING JARAK DEKATNYA DI SINI
        margin: const EdgeInsets.only(right: 8.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Box yang membungkus gambar
              Container(
                height: 70,
                width: 70,
                padding: const EdgeInsets.all(12), // Jarak gambar dari tepi box
                decoration: BoxDecoration(
                  // 👇 STYLING WARNA BOX DI SINI
                  color: const Color(0xFFF0F4E8), // Warna hijau muda
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.asset(iconPath,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error)),
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? const Color(0xFF859F3D) : Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // WIDGET UNTUK GRID PRODUK
  Widget _buildProductGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _filteredProducts.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          return _buildProductCard(_filteredProducts[index]);
        },
      ),
    );
  }

  // WIDGET UNTUK SATU KARTU PRODUK
  Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    image: DecorationImage(
                      image: AssetImage(product['image']),
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) =>
                          const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
                if (product['discount'] != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        product['discount'],
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'],
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      product['price'],
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF859F3D),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      product['unit'],
                      style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
