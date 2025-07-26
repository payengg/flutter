// pages/models/product_model.dart

class Product {
  final int id;
  final String name;
  final String category;
  final double price;
  final String? unit; // JSON Anda tidak punya 'unit', jadi buat nullable
  final String?
  discount; // JSON Anda tidak punya 'discount', jadi buat nullable
  final List<String> galleries;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.unit,
    this.discount,
    required this.galleries,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Mengubah list objek galleries menjadi list string (URL)
    List<String> galleryUrls = (json['galleries'] as List)
        .map((gallery) => gallery['url'] as String)
        .toList();

    return Product(
      id: json['id'],
      name: json['name'],
      // PERBAIKAN 1: Ambil 'name' dari objek 'category'
      category: json['category']['name'],
      price: (json['price'] as num).toDouble(),
      // PERBAIKAN 2: Handle jika 'unit' dan 'discount' tidak ada di JSON
      unit: json['unit'],
      discount: json['discount'],
      // PERBAIKAN 3: Gunakan list URL yang sudah diproses
      galleries: galleryUrls,
    );
  }
}
