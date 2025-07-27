// lib/pages/models/product_category_model.dart
class ProductCategory {
  final int id;
  final String name;
  final String? iconUrl;
  final String? imageUrl; // Tambahkan properti ini

  ProductCategory({
    required this.id,
    required this.name,
    this.iconUrl,
    this.imageUrl, // Tambahkan di constructor
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'],
      name: json['name'],
      iconUrl: json['icon_url'],
      imageUrl: json['image_url'], // Ambil data dari JSON
    );
  }
}
