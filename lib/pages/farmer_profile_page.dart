// lib/pages/farmer_profile_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:terraserve_app/pages/models/product_model.dart' as model;

class FarmerProfilePage extends StatefulWidget {
  const FarmerProfilePage({super.key});

  @override
  State<FarmerProfilePage> createState() => _FarmerProfilePageState();
}

class _FarmerProfilePageState extends State<FarmerProfilePage> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Data dummy untuk produk petani
    final List<model.Product> dummyProducts = [
      model.Product(
          id: 10,
          name: 'Strawberry premium',
          price: 17500,
          galleries: ['https://images.unsplash.com/photo-1587393855524-7ab3f96c972e?w=500&q=80'],
          description: 'Strawberry segar dari perkebunan Yanti.',
          category: 'Buah',
          seller: model.Seller(id: 1, name: 'Petani Yanti'),
          unit: '85-90gr /paket',
          discount: '20.000'),
      model.Product(
          id: 11,
          name: 'Strawberry premium',
          price: 17500,
          galleries: ['https://images.unsplash.com/photo-1587393855524-7ab3f96c972e?w=500&q=80'],
          description: 'Strawberry segar dari perkebunan Yanti.',
          category: 'Buah',
          seller: model.Seller(id: 1, name: 'Petani Yanti'),
          unit: '85-90gr /paket',
          discount: '20.000'),
      model.Product(
          id: 12,
          name: 'Strawberry premium',
          price: 17500,
          galleries: ['https://images.unsplash.com/photo-1587393855524-7ab3f96c972e?w=500&q=80'],
          description: 'Strawberry segar dari perkebunan Yanti.',
          category: 'Buah',
          seller: model.Seller(id: 1, name: 'Petani Yanti'),
          unit: '85-90gr /paket',
          discount: '20.000'),
      model.Product(
          id: 13,
          name: 'Strawberry premium',
          price: 17500,
          galleries: ['https://images.unsplash.com/photo-1587393855524-7ab3f96c972e?w=500&q=80'],
          description: 'Strawberry segar dari perkebunan Yanti.',
          category: 'Buah',
          seller: model.Seller(id: 1, name: 'Petani Yanti'),
          unit: '85-90gr /paket',
          discount: '20.000'),
       model.Product(
          id: 14,
          name: 'Strawberry premium',
          price: 17500,
          galleries: ['https://images.unsplash.com/photo-1587393855524-7ab3f96c972e?w=500&q=80'],
          description: 'Strawberry segar dari perkebunan Yanti.',
          category: 'Buah',
          seller: model.Seller(id: 1, name: 'Petani Yanti'),
          unit: '85-90gr /paket',
          discount: '20.000'),
        model.Product(
          id: 15,
          name: 'Strawberry premium',
          price: 17500,
          galleries: ['https://images.unsplash.com/photo-1587393855524-7ab3f96c972e?w=500&q=80'],
          description: 'Strawberry segar dari perkebunan Yanti.',
          category: 'Buah',
          seller: model.Seller(id: 1, name: 'Petani Yanti'),
          unit: '85-90gr /paket',
          discount: '20.000'),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Image
          SizedBox(
            height: 250,
            width: double.infinity,
            child: Image.asset(
              'assets/images/bg_profile.png',
              fit: BoxFit.cover,
            ),
          ),
          // Scrollable Content
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(top: 250),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              // ✅ Perbaikan: Gunakan Stack untuk menumpuk avatar di atas konten
              child: Stack(
                clipBehavior: Clip.none, // Izinkan avatar keluar dari batas
                alignment: Alignment.topCenter,
                children: [
                  // Konten di bawah avatar
                  Padding(
                    padding: const EdgeInsets.only(top: 70.0), // Beri ruang untuk avatar
                    child: Column(
                      children: [
                        Text(
                          'Yanti',
                          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Lampung Selatan, Lampung',
                          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 16),
                        // Tabs
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildTabButton(context, 'Ulasan', 1),
                            const SizedBox(width: 16),
                            _buildTabButton(context, 'Pesan', 2),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Product Grid
                        GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.65,
                          ),
                          itemCount: dummyProducts.length,
                          itemBuilder: (context, index) {
                            return _buildProductCard(dummyProducts[index]);
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                  // Avatar yang menumpuk di atas
                  const Positioned(
                    top: -60, // Geser avatar ke atas
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 56,
                        backgroundImage: AssetImage('assets/images/farmer_avatar.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Custom AppBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: const BackButton(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(BuildContext context, String text, int index) {
    bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(model.Product product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.network(
                    product.galleries.first,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '25%',
                      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  product.unit ?? '',
                  style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rp${product.price.toStringAsFixed(0)}',
                          style: GoogleFonts.poppins(color: const Color(0xFF859F3D), fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        if (product.discount != null)
                          Text(
                            'Rp${product.discount}',
                            style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),
                    Container(
                      height: 28,
                      width: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.add, color: Color(0xFF859F3D), size: 18),
                    )
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
