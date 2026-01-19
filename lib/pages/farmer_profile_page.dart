// lib/pages/farmer_profile_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:terraserve_app/pages/models/product_model.dart' as model;
import 'package:terraserve_app/pages/widgets/product_card.dart';
import 'package:terraserve_app/pages/product_detail_page.dart';

class FarmerProfilePage extends StatefulWidget {
  const FarmerProfilePage({super.key});

  @override
  State<FarmerProfilePage> createState() => _FarmerProfilePageState();
}

class _FarmerProfilePageState extends State<FarmerProfilePage> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    // ✅ URL Gambar Baru (Yang lama 404)
    const String dummyImage =
        'https://images.unsplash.com/photo-1601004890684-d8cbf643f5f2?w=500&q=80';

    final List<model.Product> dummyProducts = [
      model.Product(
          id: 10,
          name: 'Strawberry premium',
          price: 17500,
          galleries: [dummyImage], // Pakai variabel gambar baru
          description: 'Strawberry segar dari perkebunan Yanti.',
          category: 'Buah',
          seller: model.Seller(id: 1, name: 'Petani Yanti'),
          unit: '85-90gr /paket',
          discount: 25), // Data Int
      model.Product(
          id: 11,
          name: 'Tomat Segar',
          price: 12000,
          galleries: [
            'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=500&q=80'
          ],
          description: 'Tomat merah segar langsung panen.',
          category: 'Sayur',
          seller: model.Seller(id: 1, name: 'Petani Yanti'),
          unit: '1 kg',
          discount: 10),
      model.Product(
          id: 12,
          name: 'Sawi Hijau',
          price: 5000,
          galleries: [
            'https://images.unsplash.com/photo-1627308595229-7830a5c91f9f?w=500&q=80'
          ],
          description: 'Sawi hijau organik tanpa pestisida.',
          category: 'Sayur',
          seller: model.Seller(id: 1, name: 'Petani Yanti'),
          unit: '250gr /ikat',
          discount: 0),
      model.Product(
          id: 13,
          name: 'Wortel Brastagi',
          price: 15000,
          galleries: [
            'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?w=500&q=80'
          ],
          description: 'Wortel manis dan renyah.',
          category: 'Sayur',
          seller: model.Seller(id: 1, name: 'Petani Yanti'),
          unit: '500gr /paket',
          discount: 5),
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
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 70.0),
                    child: Column(
                      children: [
                        Text(
                          'Yanti',
                          style: GoogleFonts.poppins(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Lampung Selatan, Lampung',
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildTabButton(context, 'Ulasan', 1),
                            const SizedBox(width: 16),
                            _buildTabButton(context, 'Pesan', 2),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // ✅ PERBAIKAN UTAMA DISINI (Grid)
                        GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            // ⚠️ Ubah ini jadi 0.55 atau 0.58 biar kartu lebih tinggi
                            childAspectRatio: 0.55,
                          ),
                          itemCount: dummyProducts.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailPage(
                                        product: dummyProducts[index]),
                                  ),
                                );
                              },
                              child: ProductCard(product: dummyProducts[index]),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                  const Positioned(
                    top: -60,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 56,
                        backgroundImage:
                            AssetImage('assets/images/profilyanti.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.5),
              child: const BackButton(color: Colors.black),
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
}
