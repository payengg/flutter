// lib/pages/models/category_banner_model.dart
class CategoryBannerModel {
  final int id;
  final String title;
  final String description;
  final String buttonText; // Tambahkan properti ini
  final String? titleTextColor;
  final String imageUrl;
  final String backgroundColor;
  final String? buttonBackgroundColor;
  final String? buttonTextColor;

  CategoryBannerModel({
    required this.id,
    required this.title,
    required this.description,
    required this.buttonText,
    this.titleTextColor,
    required this.imageUrl,
    required this.backgroundColor,
    this.buttonBackgroundColor,
    this.buttonTextColor,
  });

  factory CategoryBannerModel.fromJson(Map<String, dynamic> json) {
    return CategoryBannerModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      buttonText:
          json['button_text'] ??
          'Belanja Sekarang', // Ambil data & beri nilai default
      titleTextColor: json['title_text_color'],
      imageUrl: json['image_url'],
      backgroundColor: json['background_color'],
      buttonBackgroundColor: json['button_background_color'],
      buttonTextColor: json['button_text_color'],
    );
  }
}
