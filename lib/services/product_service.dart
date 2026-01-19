import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  static Future<List<Product>> fetchAllProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      final List data = jsonMap['data'];
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load all products');
    }
  }

  static const String baseUrl = String.fromEnvironment('API_URL',
      defaultValue: 'http://31.97.109.108:8080/api');

  static Future<List<Product>> fetchRecommendedProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products/recommended'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
