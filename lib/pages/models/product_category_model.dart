// lib/pages/models/product_category_model.dart
class ProductCategory {
  // Ubah nama class
  final int id;
  final String name;
  final String? iconUrl;

  ProductCategory({required this.id, required this.name, this.iconUrl});

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'],
      name: json['name'],
      iconUrl: json['icon_url'],
    );
  }
}
