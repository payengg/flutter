class ProductSubCategory {
  final int id;
  final String name;
  final String imageUrl;

  ProductSubCategory({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory ProductSubCategory.fromJson(Map<String, dynamic> json) {
    return ProductSubCategory(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'],
    );
  }
}
