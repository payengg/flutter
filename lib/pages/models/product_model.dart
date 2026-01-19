// lib/pages/models/product_model.dart

class Seller {
  final int id;
  final String name;

  Seller({required this.id, required this.name});

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(id: json['id'], name: json['name']);
  }
}

class Product {
  final int id;
  final String name;
  final String category;
  final double price;
  final String description;
  final List<String> galleries;
  final Seller? seller;

  // ✅ Tambahan variabel agar FavoritPage tidak error
  final double rating;

  // ✅ Variabel "Wadah" Backend
  final String? unit;
  final int? discount;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.galleries,
    this.seller,
    this.unit,
    this.discount,
    this.rating = 0.0, // Default rating 0.0 jika tidak ada data
  });

  // ✅ GETTER PENTING:
  // FavoritPage memanggil 'product.imageUrl'.
  // Kita buat getter ini untuk otomatis mengambil gambar pertama dari galleries.
  String get imageUrl {
    if (galleries.isNotEmpty) {
      return galleries.first;
    }
    // Gambar default jika galeri kosong
    return 'https://via.placeholder.com/150';
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],

      // Mengubah harga ke double dengan aman
      price: double.tryParse(json['price'].toString()) ?? 0,

      category:
          json['category'] != null ? json['category']['name'] : 'Uncategorized',

      description: json['description'] ?? '',

      galleries: json['galleries'] != null
          ? (json['galleries'] as List)
              .map((gallery) => gallery['url'] as String)
              .toList()
          : [],

      seller: json['user'] != null ? Seller.fromJson(json['user']) : null,

      // Penarikan data Unit & Discount
      unit: json['unit'],
      discount: int.tryParse(json['discount'].toString()),

      // ✅ Ambil Rating dari JSON (jika ada), kalau tidak ada set 0.0
      // Ubah 'rating' sesuai nama field di backend kamu (misal: 'average_rating')
      rating: double.tryParse(json['rating'].toString()) ?? 0.0,
    );
  }
}
