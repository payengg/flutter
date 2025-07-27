// lib/pages/models/banner_model.dart
class BannerModel {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final String gradientStartColor;
  final String?
  gradientMiddleColor; // 1. Tambahkan properti ini dan buat nullable
  final String? gradientEndColor; // 2. Buat properti ini nullable

  BannerModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.gradientStartColor,
    this.gradientMiddleColor, // 3. Tambahkan di constructor
    this.gradientEndColor, // 4. Sesuaikan di constructor
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
      gradientStartColor: json['gradient_start_color'],
      // 5. Ambil data nullable dari JSON
      gradientMiddleColor: json['gradient_middle_color'],
      gradientEndColor: json['gradient_end_color'],
    );
  }
}
