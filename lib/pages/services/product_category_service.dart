// lib/pages/services/product_category_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:terraserve_app/config/api.dart';
import 'package:terraserve_app/pages/models/product_category_model.dart'; // Import model yang benar

class ProductCategoryService {
  // Ubah nama class
  Future<List<ProductCategory>> getCategories() async {
    // Kembalikan List<ProductCategory>
    final url = Uri.parse('$baseUrl/categories');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final List<dynamic> data = body['data'];

        List<ProductCategory> categories = data
            .map((item) => ProductCategory.fromJson(item))
            .toList();

        categories.insert(
          0,
          ProductCategory(
            id: 0,
            name: 'All',
            iconUrl: 'assets/images/semua.png',
          ),
        );

        return categories;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      rethrow;
    }
  }
}
