// lib/pages/services/product_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:terraserve_app/pages/models/product_model.dart';
import 'package:terraserve_app/config/api.dart'; // <-- 1. IMPORT FILE CONFIG

class ProductService {
  // Hapus variabel baseUrl dari sini karena sudah diimpor

  Future<List<Product>> getProducts() async {
    // 2. Gunakan `baseUrl` yang diimpor
    final Uri url = Uri.parse('$baseUrl/products');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
        final List<dynamic> data = body['data']['data'];
        List<Product> products = data
            .map((item) => Product.fromJson(item))
            .toList();
        return products;
      } else {
        throw Exception(
          'Failed to load products (Status code: ${response.statusCode})',
        );
      }
    } catch (e) {
      print('Error in getProducts: $e');
      throw Exception('Failed to connect to the server.');
    }
  }
}
