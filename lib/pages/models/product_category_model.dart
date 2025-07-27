import 'package:terraserve_app/pages/models/product_subcategory_model.dart';

class ProductCategory {
  final int id;
  final String name;
  final String? iconUrl;
  final String? imageUrl; // ✅ Properti yang hilang, sekarang ditambahkan
  final List<ProductSubCategory> subCategories;

  ProductCategory({
    required this.id,
    required this.name,
    this.iconUrl,
    this.imageUrl, // ✅ Ditambahkan di constructor
    required this.subCategories,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    var subCategoryList = (json['sub_categories'] as List? ?? [])
        .map((i) => ProductSubCategory.fromJson(i))
        .toList();

    return ProductCategory(
      id: json['id'],
      name: json['name'],
      iconUrl: json['icon_url'],
      imageUrl: json['image_url'], // ✅ Mengambil data dari JSON
      subCategories: subCategoryList,
    );
  }
}
