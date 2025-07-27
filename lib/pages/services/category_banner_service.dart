import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:terraserve_app/config/api.dart';
import 'package:terraserve_app/pages/models/category_banner_model.dart';

class CategoryBannerService {
  Future<List<CategoryBannerModel>> getBanners() async {
    // Menggunakan endpoint yang benar
    final url = Uri.parse('$baseUrl/category-banners');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final List<dynamic> data = body['data'];

        return data.map((item) => CategoryBannerModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load category banners');
      }
    } catch (e) {
      print('Error fetching category banners: $e');
      rethrow;
    }
  }
}
