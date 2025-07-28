// lib/pages/models/product_model.dart

// Class Seller tidak perlu diubah
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
  final String? unit;
  final String? discount;
  final String? description;
  final List<String> galleries;
  final Seller? seller; // ✅ 1. Jadikan nullable dengan tanda tanya (?)

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.unit,
    this.discount,
    this.description,
    required this.galleries,
    this.seller, // ✅ 2. Sesuaikan di constructor
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    List<String> galleryUrls = (json['galleries'] as List)
        .map((gallery) => gallery['url'] as String)
        .toList();

    return Product(
      id: json['id'],
      name: json['name'],
      category: json['category']['name'],
      price: (json['price'] as num).toDouble(),
      unit: json['unit'],
      discount: json['discount'],
      description: json['description'],
      galleries: galleryUrls,
      // ✅ 3. Tambahkan pengecekan: jika user null, jangan diproses
      seller: json['user'] != null ? Seller.fromJson(json['user']) : null,
    );
  }
}
