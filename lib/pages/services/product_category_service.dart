import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:terraserve_app/config/api.dart';
import 'package:terraserve_app/pages/models/product_category_model.dart';

class ProductCategoryService {
  // Fungsi privat untuk mengambil semua kategori dari API
  Future<List<ProductCategory>> _fetchAllCategoriesFromServer() async {
    final url = Uri.parse('$baseUrl/categories');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final List<dynamic> data = body['data'];

        return data.map((item) => ProductCategory.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      rethrow;
    }
  }

  // ✅ Fungsi untuk Dashboard: Mengambil kategori + menambahkan "All"
  Future<List<ProductCategory>> getCategoriesForDashboard() async {
    List<ProductCategory> categories = await _fetchAllCategoriesFromServer();
    // Tambahkan kategori "All" secara manual di awal list
    categories.insert(
      0,
      ProductCategory(
        id: 0,
        name: 'All',
        iconUrl: 'assets/images/semua.png',
        subCategories: [],
      ),
    );
    return categories;
  }

  // ✅ Fungsi untuk Halaman Semua Kategori: Hanya mengambil dari server
  Future<List<ProductCategory>> getAllCategories() async {
    return await _fetchAllCategoriesFromServer();
  }
}
